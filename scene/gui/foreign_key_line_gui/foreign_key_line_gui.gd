extends Control

@onready var center_point = %CenterPoint
@onready var tables_container = get_tree().get_first_node_in_group("tables_container")
@onready var line_draggable = %LineDraggable
@onready var lines_container = %LinesContainer
var line_1: Line2D
var line_2: Line2D

var source_table
var target_table
var source_table_columns: Array
var target_table_columns: Array

func _ready():
	line_1 = create_line()
	add_child(line_1)
	
	line_2 = create_line()
	add_child(line_2)


func setup_line(source_table_id: int, target_table_id: int, foreign_key: ForeignKeyTableConstraint):
	source_table = tables_container.get_node("table_" + str(source_table_id))
	target_table = tables_container.get_node("table_" + str(target_table_id))
	
	if not source_table or not target_table:
		return
	
	line_draggable.dragged.connect(func():
		foreign_key.center_point = center_point.global_position
		draw_lines()
	)
	
	source_table_columns = foreign_key.relationships.map(func(rel: ForeignKeyTableConstraintRelationship):
		return rel.own_column_id
	)
	
	target_table_columns = foreign_key.relationships.map(func(rel: ForeignKeyTableConstraintRelationship):
		return rel.target_column_id
	)
	
	var point_source: TablePoint = get_table_point(source_table, target_table, source_table_columns)
	var point_target: TablePoint = get_table_point(target_table, source_table, target_table_columns)
	var perfect_middle = lerp(point_source.end_point.x, point_target.end_point.x, 0.5)
	
	## If the saved point is way to far of the perfect middle, we snap back to it
	if not foreign_key.center_point \
		or foreign_key.center_point == Vector2.ZERO \
		or abs(perfect_middle - foreign_key.center_point.x) > 200:
		center_point.global_position.x = perfect_middle
		foreign_key.center_point = Vector2.ZERO
	else:
		center_point.global_position = foreign_key.center_point

	draw_lines()


func draw_lines():
	for c in lines_container.get_children():
		c.queue_free()
	
	var point_source: TablePoint = get_table_point(source_table, target_table, source_table_columns)
	var point_target: TablePoint = get_table_point(target_table, source_table, target_table_columns)
	
	center_point.global_position.y = lerp(point_source.end_point.y, point_target.end_point.y, 0.5)
	
	draw_from_center_to_column(point_source, line_1)
	draw_from_center_to_column(point_target, line_2)
	
	if point_source.side == Enums.SIDE.LEFT:
		line_draggable.min_x = min(point_source.end_point.x - 50, point_target.end_point.x - 50)
		line_draggable.max_x = max(point_source.end_point.x, point_target.end_point.x)
	elif point_source.side == Enums.SIDE.RIGHT:
		line_draggable.min_x = min(point_source.end_point.x, point_target.end_point.x)
		line_draggable.max_x = max(point_source.end_point.x + 50, point_target.end_point.x + 50)


func draw_from_center_to_column(table_point: TablePoint, line: Line2D):
	var points: Array[Vector2] = []
	
	var center: Vector2 = center_point.global_position + center_point.size/2
	
	points.append(center)
	
	if table_point.side == Enums.SIDE.LEFT and center.x > table_point.end_point.x:
		points.append(Vector2(
			table_point.end_point.x,
			center.y
		))
	else:
		points.append(Vector2(
			center.x,
			table_point.end_point.y
		))
	
	points.append(table_point.end_point)
	points.append(table_point.middle_point)
	
	line.points = round_edges(points) + [table_point.middle_point]
	
	for point in table_point.attribute_points:
		var new_line = create_line()
		new_line.points = [point, table_point.middle_point]
		lines_container.add_child(new_line)


## Attribute points are the points in the side of the columns
func get_table_point(table: Control, dest: Control, columns_ids) -> TablePoint:
	var attribute_points: Array[Vector2] = []
	var side: Enums.SIDE = Enums.SIDE.LEFT
	
	for column_id in columns_ids:
		var attribute_gui = table.attributes_list.get_node("column_" + str(column_id))
		if not attribute_gui:
			continue
		
		var source_attribute = attribute_gui
		var destiny_attribute = dest
		
		var center_source = source_attribute.global_position + source_attribute.size
		var center_destiny = destiny_attribute.global_position
		
		if center_source.x < center_destiny.x - (TablePoint.MIDDLE_MARGIN + TablePoint.END_MARGIN) *2:
			side = Enums.SIDE.RIGHT
			var attribute_point = Vector2(
				source_attribute.global_position.x + source_attribute.size.x,
				source_attribute.global_position.y + source_attribute.size.y/2,
			)
			attribute_points.append(attribute_point)
		else:
			side = Enums.SIDE.LEFT
			var attribute_point = Vector2(
				source_attribute.global_position.x,
				source_attribute.global_position.y + source_attribute.size.y/2,
			)
			attribute_points.append(attribute_point)
	
	return TablePoint.new(attribute_points, side)



func create_line():
	var new_line = Line2D.new()
	new_line.width = 2
	new_line.default_color = Color.hex(0x445c85ff)
	new_line.antialiased = true
	return new_line


func round_edges(points: Array[Vector2]) -> Array[Vector2]:
	if points.size() < 3:
		return points
		
	for i in range(points.size()-1, 1, -1):
		if points[i] == points[i-1]:
			points.remove_at(i)
	
	var new_points: Array[Vector2] = round_edge(points[0], points[1], points[2])
	
	for i in range(3, points.size()):
		var p = round_edge(new_points[-2], points[i-1], points[i])
		new_points.append_array(p)
	
	
	return new_points


func round_edge(start_point: Vector2, control_point: Vector2, end_point: Vector2) -> Array[Vector2]:
	const num_points: int = 8
	const roundness: float = 2
	const corner_size: float = 15
	
	var points: Array[Vector2] = []

	# Calculate the distances from the control point to the start and end points
	var start_dist = start_point.distance_to(control_point)
	var end_dist = end_point.distance_to(control_point)

	# Calculate the ratio of the corner size to the total distance
	var start_ratio = min(corner_size / start_dist, 1.0)
	var end_ratio = min(corner_size / end_dist, 1.0)

	# Calculate the actual start and end points of the curve
	var curve_start = start_point.lerp(control_point, 1-start_ratio)
	var curve_end = end_point.lerp(control_point, 1-end_ratio)
	
	points.append(start_point)
	points.append(curve_start)

	for i in range(num_points):
		var t: float = i / float(num_points - 1)
		# Adjust the roundness by modifying the interpolation
		var round_t: float = pow(t, roundness)
		# Quadratic Bezier curve calculation for the curved part
		var point: Vector2 = (1 - round_t) * (1 - round_t) * curve_start + 2 * (1 - round_t) * round_t * control_point + round_t * round_t * curve_end
		points.append(point)
	
	points.append(curve_end)
	
	return points


