extends PanelContainer

@onready var name_label = %NameLabel
var column: TableColumn


func set_column(_column: TableColumn):
	self.column = _column
	populate()
	column.updated.connect(populate)


func populate():
	name_label.text = column.get_label()
