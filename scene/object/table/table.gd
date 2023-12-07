extends PanelContainer

@export var table: Table

@onready var attributes_list = %AttributesList
@onready var draggable = $Draggable
@onready var table_name = %TableName

const table_column_scene = preload("res://scene/object/table/table_column.tscn")


func _ready():
	if not table:
		table = Table.new()
	
	table_name.text = table.name
	populate_attributes()
	draggable.gui_input.connect(on_gui_input)
	
	table.updated.connect(on_table_updated)


func on_gui_input(event):
	if event is InputEventMouseButton\
		and event.is_pressed()\
		and event.double_click\
		and event.button_index == MOUSE_BUTTON_LEFT:
			GlobalEvents.emit_select_table(table)


func populate_attributes():
	for c in attributes_list.get_children():
		c.queue_free()
	
	for col: TableColumn in table.columns:
		var col_obj = table_column_scene.instantiate()
		attributes_list.add_child(col_obj)
		col_obj.set_column(col)


func on_table_updated():
	table_name.text = table.name
	populate_attributes()
