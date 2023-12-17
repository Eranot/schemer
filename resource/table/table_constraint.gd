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


static func from_json(json) -> TableConstraint:
	if json["type"] == ConstraintType.FOREIGN_KEY:
		return ForeignKeyTableConstraint.from_json(json)
	
	return null
