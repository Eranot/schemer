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
		var constraint = ForeignKeyTableConstraint.new()
		constraint.id = json["id"]
		constraint.target_table_id = json["target_table_id"]
		for rel in json["relationships"]:
			constraint.relationships.append(ForeignKeyTableConstraintRelationship.from_json(rel))
	
		return constraint
	
	return null
