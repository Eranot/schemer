extends PanelContainer

@onready var column_icon = %ColumnIcon
@onready var name_label = %NameLabel
@onready var column_type_label = %ColumnTypeLabel

var primary_key_font = preload("res://resource/font/Roboto-Bold.ttf")
var not_primary_key_font = preload("res://resource/font/Roboto-Regular.ttf")

var not_null_texture = preload("res://asset/image/column_diamond_full.png")
var nullable_texture = preload("res://asset/image/column_diamond_empty.png")

var column: TableColumn

func set_column(_column: TableColumn):
	self.column = _column
	populate()
	column.updated.connect(populate)


func populate():
	name_label.text = column.name
	column_type_label.text = TableColumn.get_column_type_name(column.type)
	if column.is_primary_key:
		name_label.set("theme_override_fonts/font", primary_key_font)
	else:
		name_label.set("theme_override_fonts/font", not_primary_key_font)
	
	if column.is_not_null or column.is_primary_key:
		column_icon.texture = not_null_texture
	else:
		column_icon.texture = nullable_texture
