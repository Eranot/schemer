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


func emit_updated():
	updated.emit()


func add_new_column():
	columns.append(TableColumn.new())
	emit_updated()


func remove_column(col: TableColumn):
	columns.erase(col)
	emit_updated()


func add_new_foreign_key():
	constraints.append(ForeignKeyTableConstraint.new())
	emit_updated()


func remove_constraint(constraint: TableConstraint):
	columns.erase(constraint)
	emit_updated()
