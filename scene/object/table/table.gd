extends PanelContainer

@export var table: Table

@onready var attributes_list = %AttributesList
@onready var draggable = %Draggable
@onready var table_name = %TableName
@onready var foreign_key_line_drawer: ForeignKeyLineDrawer = %ForeignKeyLineDrawer

const table_column_scene = preload("res://scene/object/table/table_column.tscn")


func _ready():
	if not table:
		table = Table.new()
	
	name = "table_" + str(table.id)
	
	table_name.text = table.name
	populate_attributes()
	draggable.gui_input.connect(on_gui_input)
	
	table.updated.connect(on_table_updated)
	table.deleted.connect(on_table_deleted)
	table.column_order_updated.connect(func(a, b): self.on_table_updated())
	
	draggable.dragged.connect(on_table_dragged)
	self.resized.connect(on_table_resized)
	
	GlobalEvents.table_gui_changed.connect(func():
		foreign_key_line_drawer.draw_foreign_key_lines(table.constraints)
	)
	
	GlobalEvents.select_table.connect(func(_table):
		self.theme_type_variation = "TableContainer" if _table != self.table else "SelectedTableContainer"
	)
	
	GlobalEvents.unselect_table.connect(func():
		self.theme_type_variation = "TableContainer"
	)


func on_gui_input(event):
	if event is InputEventMouseButton\
		and event.is_pressed()\
		and event.double_click\
		and event.button_index == MOUSE_BUTTON_LEFT:
			GlobalEvents.emit_select_table(table)
	elif event is InputEventMouseButton\
		and event.is_pressed()\
		and not event.double_click\
		and event.button_index == MOUSE_BUTTON_LEFT:
			GlobalEvents.emit_click_table(table)


func populate_attributes():
	for c in attributes_list.get_children():
		c.set_name("null")
		c.queue_free()
	
	for col: TableColumn in table.columns:
		var col_obj = table_column_scene.instantiate()
		var n = "column_" + str(col.id)
		col_obj.name = n
		attributes_list.add_child(col_obj, true)
		col_obj.set_column(col)


func on_table_updated():
	table_name.text = table.name
	populate_attributes()


func on_table_deleted():
	self.queue_free()
	GlobalEvents.emit_select_table(null)


func on_table_dragged():
	table.position = self.global_position
	GlobalEvents.emit_table_gui_changed()


func on_table_resized():
	table.size = self.size
	GlobalEvents.emit_table_gui_changed()
