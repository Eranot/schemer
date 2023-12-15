extends Resource
class_name Table

signal updated

@export var id: int
@export var name: String
@export var columns: Array[TableColumn]
@export var constraints: Array[TableConstraint]
@export var position: Vector2


func _init():
	id = randi()


static func get_default_new_table() -> Table:
	var table = Table.new()
	table.name = "new_table"
	table.position = Vector2(0, 0)
	
	var id = TableColumn.new()
	id.name = "id"
	id.is_primary_key = true
	id.is_auto_increment = true
	
	table.columns = [
		id
	] as Array[TableColumn]
	
	return table


func emit_updated():
	updated.emit()


func add_new_column(column: TableColumn = TableColumn.new()):
	columns.append(column)
	emit_updated()


func remove_column(col: TableColumn):
	columns.erase(col)
	emit_updated()


func add_new_foreign_key(foreign_key: ForeignKeyTableConstraint = ForeignKeyTableConstraint.new()):
	constraints.append(foreign_key)
	emit_updated()


func remove_constraint(constraint: TableConstraint):
	constraints.erase(constraint)
	emit_updated()


func get_primary_keys() -> Array[TableColumn]:
	return self.columns.filter(func(col): return col.is_primary_key)
