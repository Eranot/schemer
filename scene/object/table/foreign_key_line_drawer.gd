extends Node
class_name ForeignKeyLineDrawer

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
	
	for relationship in foreign_key.relationships:
		var line = Line2D.new()
		line.width = 3
		var own_attribute_gui = get_parent().attributes_list.get_node("column_" + str(relationship.own_column_id))
		if not own_attribute_gui:
			continue
		
		var target_table_gui = get_node("../../table_" + str(foreign_key.target_table_id))
		if not target_table_gui:
			continue
			
		var target_attribute_gui = target_table_gui.attributes_list.get_node("column_" + str(relationship.target_column_id))
		if not target_attribute_gui:
			continue
			
		line.add_point(get_position_of_line_point(own_attribute_gui, target_attribute_gui))
		line.add_point(get_position_of_line_point(target_attribute_gui, own_attribute_gui))
		self.add_child(line)


func get_position_of_line_point(source_attribute: Control, destiny_attribute: Control) -> Vector2:
	var center_source = source_attribute.global_position + source_attribute.size/2
	var center_destiny = destiny_attribute.global_position + destiny_attribute.size/2
	if center_source.x < center_destiny.x:
		return Vector2(
			source_attribute.global_position.x + source_attribute.size.x,
			source_attribute.global_position.y + source_attribute.size.y/2,
		)
	else:
		return Vector2(
			source_attribute.global_position.x,
			source_attribute.global_position.y + source_attribute.size.y/2,
		)
