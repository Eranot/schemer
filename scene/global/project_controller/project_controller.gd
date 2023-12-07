extends Node

@onready var tables: Array[Table] = [
	load("res://resource/test_resources/table_car.tres"),
	load("res://resource/test_resources/table_person.tres"),
	load("res://resource/test_resources/table_dog.tres"),
]


func get_all_tables() -> Array[Table]:
	return tables

func get_table_by_id(table_id: int) -> Table:
	for t in tables:
		if t.id == table_id:
			return t
	return null
