extends Resource
class_name TableColumn

signal updated

enum ColumnType {
	INTEGER = 0,
	STRING = 1,
	DATE = 2,
}

@export var name: String
@export var type: ColumnType
@export var is_primary_key: bool
@export var is_not_null: bool
@export var is_unique: bool
@export var is_auto_increment: bool

func get_label():
	return name + ": " + get_column_type_name(type)


func get_column_type_name(_type: ColumnType) -> String:
	match(_type):
		ColumnType.INTEGER:
			return "int"
		ColumnType.STRING:
			return "string"
		ColumnType.DATE:
			return "date"
		_:
			return "?"


func emit_updated():
	updated.emit()
