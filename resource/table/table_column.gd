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
