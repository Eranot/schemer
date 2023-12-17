extends Resource
class_name ForeignKeyTableConstraintRelationship

@export var own_column_id: int
@export var target_column_id: int

func get_json():
	var json = {
		"own_column_id": self.own_column_id,
		"target_column_id": self.target_column_id
	}
	
	return json


static func from_json(json):
	var rel = ForeignKeyTableConstraintRelationship.new()
	rel.own_column_id = json["own_column_id"]
	rel.target_column_id = json["target_column_id"]
	return rel
