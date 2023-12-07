extends PanelContainer

@onready var create_table_button = %CreateTableButton

# Called when the node enters the scene tree for the first time.
func _ready():
	create_table_button.pressed.connect(on_create_table_button_pressed)


func on_create_table_button_pressed():
	GlobalEvents.emit_select_tool(Enums.TOOL.CREATE_TABLE)
