extends Resource
class_name Table

signal updated

@export var name: String
@export var columns: Array[TableColumn]
@export var foreign_keys: Array[ForeignKey]


func emit_updated():
	updated.emit()


func add_new_column():
	columns.append(TableColumn.new())
	emit_updated()


func remove_column(col: TableColumn):
	columns.erase(col)
	emit_updated()
