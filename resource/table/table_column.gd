extends Resource
class_name TableColumn

signal updated

@export var id: int
@export var name: String
@export var type: String
@export var is_primary_key: bool
@export var is_not_null: bool
@export var is_unique: bool
@export var is_auto_increment: bool


func _init():
	id = int(randi() / 2.0)


func emit_updated():
	updated.emit()


func get_json():
	var json = {
		"id": self.id,
		"name": self.name,
		"type": self.type,
		"is_primary_key": self.is_primary_key,
		"is_not_null": self.is_not_null,
		"is_unique": self.is_unique,
		"is_auto_increment": self.is_auto_increment
	}
	
	return json


static func from_json(json) -> TableColumn:
	var column = TableColumn.new()
	column.id = json["id"]
	column.name = json["name"]
	column.type = json["type"]
	column.is_primary_key = json["is_primary_key"]
	column.is_not_null = json["is_not_null"]
	column.is_unique = json["is_unique"]
	column.is_auto_increment = json["is_auto_increment"]

	return column
