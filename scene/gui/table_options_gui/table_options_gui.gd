extends PanelContainer

const table_column_gui_scene = preload("res://scene/gui/table_options_gui/table_column_gui.tscn")
const foreign_key_gui_scene = preload("res://scene/gui/table_options_gui/foreign_key_gui.tscn")

@export var table: Table

@onready var tab_container = $TabContainer
@onready var table_name_edit: LineEdit = %TableNameEdit
@onready var add_column_button = %AddColumnButton
@onready var add_foreign_key_button = %AddForeignKeyButton
@onready var columns_list = %ColumnsList
@onready var foreign_keys_list = %ForeignKeysList
@onready var resizable = %Resizable
@onready var options_menu_button = %OptionsMenuButton


func _ready():
	hide()
	GlobalEvents.select_table.connect(on_select_table)
	GlobalEvents.create_table.connect(on_create_table)
	GlobalEvents.unselect_table.connect(on_unselect_table)
	add_column_button.pressed.connect(on_add_column)
	add_foreign_key_button.pressed.connect(on_add_foreign_key)
	
	tab_container.set_tab_title(0, "General")
	tab_container.set_tab_title(1, "Foreign keys")
	
	visibility_changed.connect(func():
		resizable.active = self.visible
	)
	
	options_menu_button.get_popup().transparent_bg = true
	
	options_menu_button.get_popup().id_pressed.connect(func(id):
		if id == 0:
			self.table.emit_deleted()
	)
	
	setup_shortcuts()


func on_select_table(_table: Table):
	table_name_edit.release_focus()
	
	if _table == null:
		self.hide()
		return
	
	self.show()
	self.table = _table
	update_columns()
	update_foreign_keys()
	
	table_name_edit.text_changed.connect(func(text):
		table.name = text
		table.emit_updated()
	)
	
	if table.updated.is_connected(on_table_updated):
		table.updated.disconnect(on_table_updated)
	
	table.updated.connect(on_table_updated)
	table.column_order_updated.connect(on_column_order_updated)
	on_table_updated()


func on_create_table(_table: Table):
	await get_tree().create_timer(0.1).timeout
	table_name_edit.grab_focus()
	table_name_edit.caret_column = 100


func on_table_updated():
	if not table_name_edit.has_focus():
		table_name_edit.text = table.name
	update_columns()
	update_foreign_keys()


func on_unselect_table():
	self.hide()


func update_columns():
	for a in columns_list.get_children():
		a.queue_free()
	
	for col: TableColumn in table.columns:
		add_column_gui(col)


func add_column_gui(col: TableColumn):
	var column_gui = table_column_gui_scene.instantiate()
	column_gui.table = table
	columns_list.add_child(column_gui)
	column_gui.setup_column(col)


func update_foreign_keys():
	for a in foreign_keys_list.get_children():
		a.queue_free()
	
	for constraint in table.constraints:
		if not constraint is ForeignKeyTableConstraint:
			continue
		add_foreign_key_gui(constraint)


func add_foreign_key_gui(constraint: ForeignKeyTableConstraint):
	var foreign_key_gui = foreign_key_gui_scene.instantiate()
	foreign_key_gui.own_table = table
	foreign_key_gui.foreign_key = constraint
	foreign_keys_list.add_child(foreign_key_gui)


func on_add_column():
	table.add_new_column()
	focus_last_column()


func on_add_foreign_key():
	table.add_new_foreign_key()


func focus_last_column():
	columns_list.get_children()[-1].grab_name_focus()
	

func setup_shortcuts():
	# Delete table
	var delete_event = InputEventAction.new()
	delete_event.action = "delete"
	var delete_shortcut = Shortcut.new()
	delete_shortcut.events = [delete_event]
	options_menu_button.get_popup().set_item_shortcut(0, delete_shortcut)


func on_column_order_updated(from_index: int, to_index: int):
	var from = columns_list.get_children()[from_index]
	
	if not from:
		return
		
	columns_list.move_child(from, to_index)
