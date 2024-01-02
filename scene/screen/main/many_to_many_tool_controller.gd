## This controller handles what happens when the many-to-many tool is active
extends Node

const table_scene = preload("res://scene/object/table/table.tscn")

var first_selected_table: Table

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalEvents.click_table.connect(on_click_table)
	GlobalEvents.select_tool.connect(on_select_tool)


func on_click_table(table: Table):
	if GlobalEvents.selected_tool == Enums.TOOL.MANY_TO_MANY:
		if first_selected_table:
			create_many_to_many_relationship(first_selected_table, table)
			first_selected_table = null
		else:
			first_selected_table = table
			table.emit_selected_for_relationship()


func create_many_to_many_relationship(table1: Table, table2: Table):
	var new_table = Table.new()
	new_table.name = table1.name + "_" + table2.name
	new_table.position = lerp(table1.position, table2.position, 0.5) + Vector2(100, 25)
	
	add_foreign_key_to_table(new_table, table1)
	add_foreign_key_to_table(new_table, table2)
	
	GlobalEvents.emit_create_table(new_table)
	GlobalEvents.emit_select_tool(Enums.TOOL.NONE)


func add_foreign_key_to_table(table_source: Table, table_destiny: Table):
	var foreign_key = ForeignKeyTableConstraint.new()
	foreign_key.target_table_id = table_destiny.id
	
	for pk in table_destiny.get_primary_keys():
		var new_column = TableColumn.new()
		new_column.name = table_destiny.name + "_" + pk.name
		new_column.type = pk.type
		new_column.is_primary_key = true
		
		
		table_source.add_new_column(new_column)
		
		var relationship = ForeignKeyTableConstraintRelationship.new()
		relationship.own_column_id = new_column.id
		relationship.target_column_id = pk.id
		foreign_key.add_relationship(relationship)
		
	table_source.add_new_foreign_key(foreign_key)


func on_select_tool(tool: Enums.TOOL):
	if tool != Enums.TOOL.MANY_TO_MANY:
		first_selected_table = null
