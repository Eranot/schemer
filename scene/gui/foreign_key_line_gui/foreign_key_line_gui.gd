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
	
	var attribute_points_source = get_attribute_points(source_table, target_table, source_table_columns)
	var table_point_source = get_table_point(attribute_points_source)
	
	var attribute_points_target = get_attribute_points(target_table, source_table, target_table_columns)
	var table_point_target = get_table_point(attribute_points_target)
	
	var perfect_middle = lerp(table_point_source.x, table_point_target.x, 0.5)
	
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
	
	var attribute_points_source = get_attribute_points(source_table, target_table, source_table_columns)
	var table_point_source = get_table_point(attribute_points_source)
	
	var attribute_points_target = get_attribute_points(target_table, source_table, target_table_columns)
	var table_point_target = get_table_point(attribute_points_target)
	
	if not attribute_points_source or not attribute_points_target:
		return
	
	center_point.global_position.y = lerp(table_point_source.y, table_point_target.y, 0.5)
	
	draw_from_center_to_column(table_point_source, attribute_points_source, line_1)
	draw_from_center_to_column(table_point_target, attribute_points_target, line_2)
	
	line_draggable.min_x = min(table_point_source.x, table_point_target.x)
	line_draggable.max_x = max(table_point_source.x, table_point_target.x)


func draw_from_center_to_column(table_point, attribute_points, line: Line2D):
	var points = []
	
	var center: Vector2 = center_point.global_position + center_point.size/2
	
	points.append(center)
	
	if table_point.x < attribute_points[0][0].x and center.x > table_point.x:
		points.append(Vector2(
			table_point.x,
			center.y
		))
	else:
		points.append(Vector2(
			center.x,
			table_point.y
		))
	
	points.append(table_point)
	line.points = points
	
	for point in attribute_points:
		var new_line = create_line()
		new_line.points = [point[0], table_point]
		lines_container.add_child(new_line)
		
	return table_point


func get_position_of_line_point(source_attribute: Control, destiny_attribute: Control) -> Array[Vector2]:
	var center_source = source_attribute.global_position + source_attribute.size
	var center_destiny = destiny_attribute.global_position
	
	var margin = Vector2(30, 0)
	
	if center_source.x < center_destiny.x - margin.x*2:
		var attribute_point = Vector2(
			source_attribute.global_position.x + source_attribute.size.x,
			source_attribute.global_position.y + source_attribute.size.y/2,
		)
		return [attribute_point, attribute_point + margin]
	else:
		var attribute_point = Vector2(
			source_attribute.global_position.x,
			source_attribute.global_position.y + source_attribute.size.y/2,
		)
		return [attribute_point, attribute_point - margin]


## Attribute points are the points in the side of the columns
func get_attribute_points(table: Control, dest: Control, columns_ids):
	var attribute_points: Array[Array] = []
	
	for column_id in columns_ids:
		var attribute_gui = table.attributes_list.get_node("column_" + str(column_id))
		if not attribute_gui:
			continue
		
		var points_source = get_position_of_line_point(attribute_gui, dest)
		attribute_points.append(points_source)
	
	return attribute_points


## Table point is a bit awaiy from the table and the Y in the mean on all the Y's of the attribute points
func get_table_point(attribute_points):
	var sum_point: Vector2 = Vector2.ZERO
	for init_point in attribute_points:
		sum_point += init_point[1]
	
	var table_point: Vector2 = sum_point / Vector2(len(attribute_points), len(attribute_points))
	
	return table_point


func create_line():
	var new_line = Line2D.new()
	new_line.width = 2
	new_line.default_color = Color.hex(0x445c85ff)
	new_line.antialiased = true
	return new_line
