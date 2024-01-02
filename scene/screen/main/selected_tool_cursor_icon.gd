extends Control

@onready var selected_tool_cursor_icon = %SelectedToolCursorIcon


func _ready():
	GlobalEvents.select_tool.connect(on_select_tool)
	hide()


func _process(_delta):
	global_position = get_global_mouse_position() + Vector2(10, 10)


func on_select_tool(tool: Enums.TOOL):
	show()
	
	if tool == Enums.TOOL.CREATE_TABLE:
		selected_tool_cursor_icon.texture = preload("res://asset/image/create_table_icon_normal.png")
	elif tool == Enums.TOOL.ONE_TO_MANY:
		selected_tool_cursor_icon.texture = preload("res://asset/image/one_to_many_icon_normal.png")
	elif tool == Enums.TOOL.MANY_TO_MANY:
		selected_tool_cursor_icon.texture = preload("res://asset/image/many_to_many_icon_normal.png")
	else:
		hide()
