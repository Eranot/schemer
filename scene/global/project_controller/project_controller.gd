extends Node

signal clean_project

@onready var tables: Array[Table] = []


func add_table(table: Table):
	tables.append(table)


func remove_table(table: Table):
	tables.erase(table)


func get_all_tables() -> Array[Table]:
	return tables


func get_table_by_id(table_id: int) -> Table:
	for t in tables:
		if t.id == table_id:
			return t
	return null


func get_file_json():
	var json = {
		"version": 1,
		"tables": []
	}
	
	for table: Table in tables:
		json["tables"].append(table.get_json())
	
	return json


## Removes all about the current project and cleans everything
func emit_clean_project():
	clean_project.emit()


func import_from_json(json: String):
	var obj = JSON.parse_string(json)
	if not obj:
		return
	
	for table_json in obj["tables"]:
		GlobalEvents.emit_create_table(Table.from_json(table_json))
	
	GlobalEvents.emit_unselect_table()
