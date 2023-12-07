extends Control

const table_scene = preload("res://scene/object/table/table.tscn")
@onready var tables_container = %TablesContainer
@onready var default_config_component: DefaultConfigComponent = %DefaultConfigComponent

var selected_tool: Enums.TOOL = Enums.TOOL.NONE

func _ready():
	GlobalEvents.create_table.connect(on_create_table)
	GlobalEvents.select_tool.connect(on_select_tool)
	
	add_tables_to_canvas()

func add_tables_to_canvas():
	for table: Table in ProjectController.get_all_tables():
		add_table_to_canvas(table)


func add_table_to_canvas(table: Table):
	var new_table = table_scene.instantiate()
	new_table.table = table
	new_table.global_position = table.position
	tables_container.add_child(new_table)
	new_table.table.emit_updated()
	GlobalEvents.emit_select_table(new_table.table)


func _gui_input(_event):
	if Input.is_action_just_pressed("unselect_table"):
		GlobalEvents.emit_unselect_table()
		selected_tool = Enums.TOOL.NONE
	
	if Input.is_action_just_pressed("click") and selected_tool == Enums.TOOL.CREATE_TABLE:
		GlobalEvents.emit_create_table(get_global_mouse_position())
		selected_tool = Enums.TOOL.NONE


func on_create_table(_position: Vector2):
	var table = default_config_component.get_default_new_table(_position)
	add_table_to_canvas(table)


func on_select_tool(tool: Enums.TOOL):
	selected_tool = tool
