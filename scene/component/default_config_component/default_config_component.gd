extends Node
class_name DefaultConfigComponent


func get_default_new_table(position: Vector2) -> Table:
	var table = Table.new()
	table.name = "new_table"
	table.position = position
	
	var id = TableColumn.new()
	id.name = "id"
	id.is_primary_key = true
	id.is_not_null = true
	id.is_auto_increment = true
	
	table.columns = [
		id
	] as Array[TableColumn]
	
	return table
