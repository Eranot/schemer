extends Node

signal select_table(table: Table)
signal unselect_table()

func emit_select_table(table: Table):
	select_table.emit(table)


func emit_unselect_table():
	unselect_table.emit()
