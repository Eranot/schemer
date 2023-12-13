## Responsible for drawing the relationhip lines
class_name ForeignKeyLineDrawer
extends Node

func draw_foreign_key_lines(constraints: Array[TableConstraint]):
	for c in self.get_children():
		c.queue_free()
	
	for constraint in constraints:
		if constraint is ForeignKeyTableConstraint:
			draw_foreign_key(constraint)


func draw_foreign_key(foreign_key: ForeignKeyTableConstraint):
	var target_table = get_node("../../table_" + str(foreign_key.target_table_id))
	
	if not target_table:
		return
	
	var initial_points: Array[Array] = []
	
	for relationship in foreign_key.relationships:
		var line = Line2D.new()
		line.width = 2
		line.default_color = Color.hex(0x445c85)
		line.antialiased = true
		var own_attribute_gui = get_parent().attributes_list.get_node("column_" + str(relationship.own_column_id))
		if not own_attribute_gui:
			continue
		
		var target_table_gui = get_node("../../table_" + str(foreign_key.target_table_id))
		if not target_table_gui:
			continue
			
		var target_attribute_gui = target_table_gui.attributes_list.get_node("column_" + str(relationship.target_column_id))
		if not target_attribute_gui:
			continue
		
		var points_source = get_position_of_line_point(own_attribute_gui, target_attribute_gui)
		var points_target = get_position_of_line_point(target_attribute_gui, own_attribute_gui)
		
		initial_points.append([points_source, points_target])
	
	var sum_point_source: Vector2 = Vector2.ZERO
	var sum_point_target: Vector2 = Vector2.ZERO
	
	for init_point in initial_points:
		sum_point_source += init_point[0][1]
		sum_point_target += init_point[1][1]
	
	var point_source: Vector2 = sum_point_source / Vector2(len(initial_points), len(initial_points))
	var point_target: Vector2 = sum_point_target / Vector2(len(initial_points), len(initial_points))
	
	var line = Line2D.new()
	line.width = 2
	line.default_color = Color.hex(0x445c85)
	line.antialiased = true
	
	for init_point in initial_points:
		line.add_point(init_point[0][0])
		line.add_point(point_source)
	
	var arc_points = get_points_between_positions(point_source, point_target)
	for point in arc_points:
		line.add_point(point)
	
	for init_point in initial_points:
		line.add_point(init_point[1][0])
		line.add_point(point_target)
	
	self.add_child(line)


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


func get_points_between_positions(position1: Vector2, position2: Vector2) -> Array[Vector2]:
	var points: Array[Vector2] = []
	# Determine control points for the two halves of the "S"
	
	points.append(position1)
	if position2.x < position1.x:
		points.append(Vector2(position2.x, position1.y))
	else:
		points.append(Vector2(position1.x, position2.y))
	points.append(position2)
	
	return points
