extends Control

const table_scene = preload("res://scene/object/table/table.tscn")
@onready var tables_container = %TablesContainer

var selected_tool: Enums.TOOL = Enums.TOOL.NONE

func _ready():
	GlobalEvents.create_table.connect(on_create_table)
	GlobalEvents.select_tool.connect(on_select_tool)
	ProjectController.clean_project.connect(on_clean_project)
	
	var test_tables = [
		#load("res://resource/test_resources/table_car.tres"),
		#load("res://resource/test_resources/table_person.tres"),
		#load("res://resource/test_resources/table_dog.tres"),
	]
	
	for t in test_tables:
		GlobalEvents.emit_create_table(t)


func add_table_to_canvas(table: Table):
	var new_table = table_scene.instantiate()
	new_table.table = table
	new_table.global_position = table.position
	new_table.size.x = table.size.x
	tables_container.add_child(new_table)
	new_table.table.emit_updated()
	GlobalEvents.emit_select_table(new_table.table)
	await get_tree().create_timer(0.05).timeout
	GlobalEvents.emit_table_gui_changed()


func _unhandled_input(_event):
	if Input.is_action_just_pressed("unselect_table"):
		GlobalEvents.emit_unselect_table()
		GlobalEvents.emit_select_tool(Enums.TOOL.NONE)
	
	if Input.is_action_just_pressed("click") and selected_tool == Enums.TOOL.CREATE_TABLE:
		var table = Table.get_default_new_table()
		table.position = get_global_mouse_position()
		GlobalEvents.emit_create_table(table)
		GlobalEvents.emit_select_tool(Enums.TOOL.NONE)
	elif Input.is_action_just_pressed("click") and selected_tool == Enums.TOOL.NONE:
		var focused_node = get_viewport().gui_get_focus_owner()
		if focused_node:
			focused_node.release_focus()


func on_create_table(table: Table):
	add_table_to_canvas(table)


func on_select_tool(tool: Enums.TOOL):
	selected_tool = tool


func on_clean_project():
	for child in tables_container.get_children():
		child.queue_free()
