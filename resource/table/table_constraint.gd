extends Resource
class_name TableConstraint

signal updated

enum ConstraintType {
	FOREIGN_KEY = 0,
}

@export var id: int


func _init():
	id = randi()


func emit_updated():
	updated.emit()
