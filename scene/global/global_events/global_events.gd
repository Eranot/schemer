extends Node

var selected_tool: Enums.TOOL

signal select_table(table: Table)
signal unselect_table()
signal create_table(table: Table)
signal click_table(table: Table)
signal select_tool(tool: Enums.TOOL)
signal table_gui_changed

func emit_select_table(table: Table):
	select_table.emit(table)


func emit_unselect_table():
	unselect_table.emit()


func emit_click_table(table: Table):
	click_table.emit(table)


func emit_create_table(table: Table = Table.get_default_new_table()):
	create_table.emit(table)


func emit_select_tool(tool: Enums.TOOL):
	self.selected_tool = tool
	select_tool.emit(tool)


func emit_table_gui_changed():
	table_gui_changed.emit()
