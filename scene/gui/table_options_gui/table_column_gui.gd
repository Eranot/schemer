extends HBoxContainer

var table: Table

@onready var name_line_edit = %NameLineEdit
@onready var type_option_button = %TypeOptionButton
@onready var pk_checkbox = %PKCheckBox
@onready var nn_checkbox = %NNCheckBox
@onready var uq_checkbox = %UQCheckBox
@onready var ai_checkbox = %AICheckBox
@onready var options_menu_button = %OptionsMenuButton

func _ready():
	type_option_button.get_popup().transparent_bg = true
	options_menu_button.get_popup().transparent_bg = true


func setup_column(col: TableColumn):
	name_line_edit.text = col.name
	name_line_edit.text_changed.connect(func(text):
		col.name = text
		col.emit_updated()
	)
	
	for type in ColumnTypesController.get_column_types():
		type_option_button.add_item(type)
	
	type_option_button.selected = ColumnTypesController.get_column_types().find(col.type)
	type_option_button.item_selected.connect(func(index):
		col.type = ColumnTypesController.get_column_types()[index]
		col.emit_updated()
	)
	
	pk_checkbox.button_pressed = col.is_primary_key
	pk_checkbox.toggled.connect(func(toogled):
		col.is_primary_key = toogled
		col.emit_updated()
	)
	
	nn_checkbox.button_pressed = col.is_not_null
	nn_checkbox.toggled.connect(func(toogled):
		col.is_not_null = toogled
		col.emit_updated()
	)
	
	uq_checkbox.button_pressed = col.is_unique
	uq_checkbox.toggled.connect(func(toogled):
		col.is_unique = toogled
		col.emit_updated()
	)
	
	ai_checkbox.button_pressed = col.is_auto_increment
	ai_checkbox.toggled.connect(func(toogled):
		col.is_auto_increment = toogled
		col.emit_updated()
	)
	
	var options_popup = options_menu_button.get_popup()
	options_popup.id_pressed.connect(func(id):
		if id == 0:
			self.table.remove_column(col)
		elif id == 1:
			self.table.move_column_up(col)
		elif id == 2:
			self.table.move_column_down(col)
	)
	options_menu_button.shortcut_context = self
	
	var move_up_event = InputEventAction.new()
	move_up_event.action = "move_up"
	var move_up_shortcut = Shortcut.new()
	move_up_shortcut.events = [move_up_event]
	options_popup.set_item_shortcut(1, move_up_shortcut)
	
	var move_down_event = InputEventAction.new()
	move_down_event.action = "move_down"
	var move_down_shortcut = Shortcut.new()
	move_down_shortcut.events = [move_down_event]
	options_popup.set_item_shortcut(2, move_down_shortcut)


func grab_name_focus():
	name_line_edit.grab_focus()
