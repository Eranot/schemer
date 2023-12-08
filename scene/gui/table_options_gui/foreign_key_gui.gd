extends PanelContainer

@export var own_table: Table
@export var foreign_key: ForeignKeyTableConstraint

@onready var target_table_option_button = %TargetTableOptionButton
@onready var add_relationship_button = %AddRelationshipButton
@onready var own_column = %OwnColumn
@onready var target_column = %TargetColumn

var selected_target_table: Table

const FIELD_MINIMUM_HEIGHT = 50


func _ready():
	add_relationship_button.pressed.connect(on_add_relationship)
	selected_target_table = ProjectController.get_table_by_id(foreign_key.target_table_id)
	update_table_options()
	update_relationships()
	
	foreign_key.updated.connect(func():
		update_table_options()
		update_relationships()
	)


func on_add_relationship():
	foreign_key.add_relationship()


func update_table_options():
	var all_tables: Array[Table] = ProjectController.get_all_tables()
	target_table_option_button.clear()
	for table in all_tables:
		if table.id != own_table.id:
			target_table_option_button.add_item(table.name, table.id)
	
	target_table_option_button.item_selected.connect(func(index):
		selected_target_table = ProjectController.get_table_by_id(target_table_option_button.get_item_id(index))
		foreign_key.target_table_id = target_table_option_button.get_item_id(index)
		self.update_relationships()
	)
	
	target_table_option_button.selected = target_table_option_button.get_item_index(foreign_key.target_table_id)


func update_relationships():
	for a in own_column.get_children():
		if !a is Label:
			a.queue_free()
	
	for a in target_column.get_children():
		if !a is Label:
			a.queue_free()
	
	
	for relationship: ForeignKeyTableConstraintRelationship in foreign_key.relationships:
		add_relationship(relationship)


func add_relationship(relationship: ForeignKeyTableConstraintRelationship):
	# own columns
	var own_column_option_button = OptionButton.new()
	
	for col in own_table.columns:
		own_column_option_button.add_item(col.name, col.id)
	
	own_column_option_button.selected = own_column_option_button.get_item_index(relationship.own_column_id)
	
	own_column_option_button.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	own_column.add_child(own_column_option_button)
	
	own_column_option_button.item_selected.connect(func(index):
		relationship.own_column_id = own_column_option_button.get_item_id(index)
		GlobalEvents.emit_table_gui_changed()
	)
	
	if not selected_target_table:
		return
	
	# target columns
	var target_column_option_button = OptionButton.new()
	
	for col in selected_target_table.columns:
		target_column_option_button.add_item(col.name, col.id)
	
	target_column_option_button.selected = target_column_option_button.get_item_index(relationship.target_column_id)
	
	target_column_option_button.custom_minimum_size = Vector2(0, FIELD_MINIMUM_HEIGHT)
	target_column.add_child(target_column_option_button)
	
	target_column_option_button.item_selected.connect(func(index):
		relationship.target_column_id = target_column_option_button.get_item_id(index)
		GlobalEvents.emit_table_gui_changed()
	)
	
