extends PanelContainer

@export var table: Table

@onready var name_column = %NameColumn
@onready var type_column = %TypeColumn
@onready var pk_column = %PKColumn
@onready var nn_column = %NNColumn
@onready var uq_column = %UQColumn
@onready var ai_column = %AIColumn
@onready var options_column = %OptionsColumn
@onready var table_name_edit = %TableNameEdit
@onready var add_column_button = %AddColumnButton

const FIELD_MINIMUM_HEIGHT = 50


func _ready():
	GlobalEvents.select_table.connect(on_select_table)
	GlobalEvents.unselect_table.connect(on_unselect_table)
	add_column_button.pressed.connect(on_add_column)


func on_select_table(_table: Table):
	self.show()
	self.table = _table
	on_table_updated()
	update_columns()
	
	table_name_edit.text_changed.connect(func(text):
		table.name = text
		table.emit_updated()
	)
	
	table.updated.connect(on_table_updated)


func on_table_updated():
	table_name_edit.text = table.name
	update_columns()


func on_unselect_table():
	self.hide()


func update_columns():
	for a in name_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in type_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in pk_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in nn_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in uq_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in ai_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in options_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for col: TableColumn in table.columns:
		add_column(col)


func add_column(col: TableColumn):
	var name_line_edit = LineEdit.new()
	name_line_edit.text = col.name
	name_line_edit.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	name_column.add_child(name_line_edit)
	name_line_edit.text_changed.connect(func(text):
		col.name = text
		col.emit_updated()
	)
	
	var type_option_button = OptionButton.new()
	type_option_button.add_item("Integer", TableColumn.ColumnType.INTEGER)
	type_option_button.add_item("String", TableColumn.ColumnType.STRING)
	type_option_button.add_item("Date", TableColumn.ColumnType.DATE)
	type_option_button.selected = col.type
	type_option_button.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	type_column.add_child(type_option_button)
	type_option_button.item_selected.connect(func(type):
		col.type = type
		col.emit_updated()
	)
	
	var pk_checkbox = CheckBox.new()
	pk_checkbox.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	pk_checkbox.button_pressed = col.is_primary_key
	pk_column.add_child(pk_checkbox)
	pk_checkbox.toggled.connect(func(toogled):
		col.is_primary_key = toogled
		col.emit_updated()
	)
	
	var nn_checkbox = CheckBox.new()
	nn_checkbox.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	nn_checkbox.button_pressed = col.is_not_null
	nn_column.add_child(nn_checkbox)
	nn_checkbox.toggled.connect(func(toogled):
		col.is_not_null = toogled
		col.emit_updated()
	)
	
	var uq_checkbox = CheckBox.new()
	uq_checkbox.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	uq_checkbox.button_pressed = col.is_unique
	uq_column.add_child(uq_checkbox)
	uq_checkbox.toggled.connect(func(toogled):
		col.is_unique = toogled
		col.emit_updated()
	)
	
	var ai_checkbox = CheckBox.new()
	ai_checkbox.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	ai_checkbox.button_pressed = col.is_auto_increment
	ai_column.add_child(ai_checkbox)
	ai_checkbox.toggled.connect(func(toogled):
		col.is_auto_increment = toogled
		col.emit_updated()
	)
	
	var options_menu_button = MenuButton.new()
	options_menu_button.text = "."
	var options_popup = options_menu_button.get_popup()
	options_popup.add_item("Remove", 0)
	options_menu_button.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	options_column.add_child(options_menu_button)
	options_popup.id_pressed.connect(func(id):
		if id == 0:
			self.table.remove_column(col)
	)
	


func on_add_column():
	table.add_new_column()
