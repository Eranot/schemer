extends Resource
class_name Table

signal updated
signal deleted
signal column_order_updated(from_index: int, to_index: int)

## Emitted when the table is selected to create a relationshop
signal selected_for_relationship

@export var id: int
@export var name: String
@export var columns: Array[TableColumn]
@export var constraints: Array[TableConstraint]
@export var position: Vector2
@export var size: Vector2


func _init():
	id = randi()
	
	GlobalEvents.table_deleted.connect(on_any_table_deleted)
	size = Vector2(300, 0)


static func get_default_new_table() -> Table:
	var table = Table.new()
	table.name = "new_table"
	table.position = Vector2(0, 0)
	
	var id_col = TableColumn.new()
	id_col.name = "id"
	id_col.type = "int"
	id_col.is_primary_key = true
	id_col.is_auto_increment = true
	
	table.columns = [
		id_col
	] as Array[TableColumn]
	
	return table


func emit_updated():
	updated.emit()


func emit_selected_for_relationship():
	selected_for_relationship.emit()


func emit_deleted():
	GlobalEvents.emit_table_deleted(id)
	deleted.emit()


func emit_column_order_updated(from_index: int, to_index: int):
	column_order_updated.emit(from_index, to_index)


func add_new_column(column: TableColumn = TableColumn.new()):
	columns.append(column)
	emit_updated()


func remove_column(col: TableColumn):
	for constraint in constraints:
		if constraint is ForeignKeyTableConstraint:
			for rel: ForeignKeyTableConstraintRelationship in constraint.relationships:
				if rel.own_column_id == col.id:
					constraint.remove_relationship(rel)
					if len(constraint.relationships) == 0:
						self.remove_constraint(constraint)
	columns.erase(col)
	emit_updated()


func move_column_up(col: TableColumn):
	var index = columns.find(col)
	
	if index == -1 or index == 0:
		return
	
	columns.remove_at(index)
	columns.insert(index-1, col)
	
	emit_column_order_updated(index, index-1)


func move_column_down(col: TableColumn):
	var index = columns.find(col)
	
	if index == -1 or index == columns.size() - 1:
		return
	
	columns.remove_at(index)
	columns.insert(index+1, col)
	
	emit_column_order_updated(index, index+1)


func remove_column_by_id(col_id: int):
	for col in columns:
		if col.id == col_id:
			remove_column(col)


func add_new_foreign_key(foreign_key: ForeignKeyTableConstraint = ForeignKeyTableConstraint.new()):
	constraints.append(foreign_key)
	emit_updated()


func remove_constraint(constraint: TableConstraint):
	if constraint is ForeignKeyTableConstraint:
		for rel: ForeignKeyTableConstraintRelationship in constraint.relationships:
			self.remove_column_by_id(rel.own_column_id)
	
	constraints.erase(constraint)
	emit_updated()


func get_primary_keys() -> Array[TableColumn]:
	return self.columns.filter(func(col): return col.is_primary_key)


func on_any_table_deleted(table_id: int):
	for constraint in constraints:
		if constraint is ForeignKeyTableConstraint:
			if constraint.target_table_id == table_id:
				for rel in constraint.relationships:
					self.remove_column_by_id(rel.own_column_id)
				
				self.remove_constraint(constraint)
	
	emit_updated()


func get_json():
	var json = {
		"id": self.id,
		"name": self.name,
		"position": {
			"x": self.position.x,
			"y": self.position.y,
		},
		"size": {
			"x": self.size.x,
			"y": self.size.y,
		},
		"columns": [],
		"constraints": []
	}
	
	for col: TableColumn in columns:
		json["columns"].append(col.get_json())
	
	for constraint: TableConstraint in constraints:
		json["constraints"].append(constraint.get_json())
	
	return json


static func from_json(json) -> Table:
	var table = Table.new()
	table.id = json["id"]
	table.name = json["name"]
	table.position = Vector2(json["position"]["x"], json["position"]["y"])
	table.size = Vector2(json["size"]["x"], json["size"]["y"])
	
	for col in json["columns"]:
		table.columns.append(TableColumn.from_json(col))
	
	for col in json["constraints"]:
		table.constraints.append(TableConstraint.from_json(col))
	
	return table
