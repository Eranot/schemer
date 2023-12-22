extends Node


func get_column_types() -> Array[String]:
	return [
		"int",
		"float",
		"bool",
		"varchar",
		"longtext",
		"date",
		"datetime",
		"json",
		"enum",
	]
