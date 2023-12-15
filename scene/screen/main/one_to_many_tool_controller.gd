## This controller handles what happens when the one-to-many tool is active
extends Node

var first_selected_table: Table

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvents.click_table.connect(on_click_table)
	GlobalEvents.select_tool.connect(on_select_tool)


func on_click_table(table: Table):
	if GlobalEvents.selected_tool == Enums.TOOL.ONE_TO_MANY:
		if first_selected_table:
			create_one_to_many_relationship(first_selected_table, table)
			first_selected_table = null
		else:
			first_selected_table = table


func create_one_to_many_relationship(table1: Table, table2: Table):
	add_foreign_key_to_table(table1, table2)
	table2.emit_updated()
	GlobalEvents.emit_select_tool(Enums.TOOL.NONE)


func add_foreign_key_to_table(table_source: Table, table_destiny: Table):
	var foreign_key = ForeignKeyTableConstraint.new()
	foreign_key.target_table_id = table_destiny.id
	
	for pk in table_destiny.get_primary_keys():
		var new_column = TableColumn.new()
		new_column.name = table_destiny.name + "_" + pk.name
		new_column.type = pk.type
		new_column.is_not_null = true
		
		table_source.add_new_column(new_column)
		
		var relationship = ForeignKeyTableConstraintRelationship.new()
		relationship.own_column_id = new_column.id
		relationship.target_column_id = pk.id
		foreign_key.add_relationship(relationship)
		
	table_source.add_new_foreign_key(foreign_key)


func on_select_tool(tool: Enums.TOOL):
	if tool != Enums.TOOL.ONE_TO_MANY:
		first_selected_table = null
