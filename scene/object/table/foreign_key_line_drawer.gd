## Responsible for drawing the relationhip lines
class_name ForeignKeyLineDrawer
extends Node

const foreign_key_line_gui_scene = preload("res://scene/gui/foreign_key_line_gui/foreign_key_line_gui.tscn")
@onready var relationships_container = %RelationshipsContainer


func draw_foreign_key_lines(constraints: Array[TableConstraint]):
	var children = relationships_container.get_children()
	for c in children:
		c.queue_free()
	
	for constraint in constraints:
		if constraint is ForeignKeyTableConstraint:
			draw_foreign_key(constraint)
	

func draw_foreign_key(foreign_key: ForeignKeyTableConstraint):
	var line_gui = foreign_key_line_gui_scene.instantiate()
	relationships_container.add_child(line_gui)
	line_gui.setup_line(get_parent().table.id, foreign_key.target_table_id, foreign_key)
