extends TableConstraint
class_name ForeignKeyTableConstraint

@export var target_table_id: int
@export var relationships: Array[ForeignKeyTableConstraintRelationship]


func add_relationship(relationship: ForeignKeyTableConstraintRelationship = ForeignKeyTableConstraintRelationship.new()):
	relationships.append(relationship)
	emit_updated()
