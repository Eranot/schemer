extends TableConstraint
class_name ForeignKeyTableConstraint

@export var target_table_id: int
@export var relationships: Array[ForeignKeyTableConstraintRelationship]


func add_relationship(relationship: ForeignKeyTableConstraintRelationship = ForeignKeyTableConstraintRelationship.new()):
	relationships.append(relationship)
	emit_updated()


func remove_relationship(relationship: ForeignKeyTableConstraintRelationship):
	relationships.erase(relationship)


func get_json():
	var json = {
		"id": self.id,
		"type": 0,
		"target_table_id": self.target_table_id,
		"relationships": []
	}
	
	for rel: ForeignKeyTableConstraintRelationship in relationships:
		json["relationships"].append(rel.get_json())
	
	return json
