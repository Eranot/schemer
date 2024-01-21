extends TableConstraint
class_name ForeignKeyTableConstraint

@export var target_table_id: int
@export var center_point: Vector2
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
		"center_point": {
			"x": center_point.x,
			"y": center_point.y,
		} if center_point else {
			"x": 0,
			"y": 0,
		},
		"relationships": []
	}
	
	for rel: ForeignKeyTableConstraintRelationship in relationships:
		json["relationships"].append(rel.get_json())
	
	return json


static func from_json(json):
	var constraint = ForeignKeyTableConstraint.new()
	constraint.id = json["id"]
	constraint.target_table_id = json["target_table_id"]
	constraint.center_point = Vector2(json["center_point"]["x"], json["center_point"]["y"]) if json["center_point"] else Vector2.ZERO
	for rel in json["relationships"]:
		constraint.relationships.append(ForeignKeyTableConstraintRelationship.from_json(rel))

	return constraint
