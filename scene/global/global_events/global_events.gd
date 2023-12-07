extends Node

signal select_table(table: Table)
signal unselect_table()
signal create_table(position: Vector2)
signal select_tool(tool: Enums.TOOL)

func emit_select_table(table: Table):
	select_table.emit(table)


func emit_unselect_table():
	unselect_table.emit()


func emit_create_table(position: Vector2):
	create_table.emit(position)


func emit_select_tool(tool: Enums.TOOL):
	select_tool.emit(tool)
