extends Resource
class_name Table

signal updated
signal deleted

@export var id: int
@export var name: String
@export var columns: Array[TableColumn]
@export var constraints: Array[TableConstraint]
@export var position: Vector2


func _init():
	id = randi()
	
	GlobalEvents.table_deleted.connect(on_any_table_deleted)


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


func emit_deleted():
	GlobalEvents.emit_table_deleted(id)
	deleted.emit()


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
