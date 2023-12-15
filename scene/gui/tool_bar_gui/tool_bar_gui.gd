extends PanelContainer

@onready var create_table_button: Button = %CreateTableButton
@onready var one_to_many_button = %OneToManyButton
@onready var many_to_many_button = %ManyToManyButton

# Called when the node enters the scene tree for the first time.
func _ready():
	create_table_button.pressed.connect(on_create_table_button_pressed)
	one_to_many_button.pressed.connect(on_one_to_many_button_pressed)
	many_to_many_button.pressed.connect(on_many_to_many_button_pressed)
	
	GlobalEvents.select_tool.connect(func(tool):
		self.create_table_button.button_pressed = tool == Enums.TOOL.CREATE_TABLE
		self.one_to_many_button.button_pressed = tool == Enums.TOOL.ONE_TO_MANY
		self.many_to_many_button.button_pressed = tool == Enums.TOOL.MANY_TO_MANY
	)


func on_create_table_button_pressed():
	GlobalEvents.emit_select_tool(Enums.TOOL.CREATE_TABLE)


func on_one_to_many_button_pressed():
	GlobalEvents.emit_select_tool(Enums.TOOL.ONE_TO_MANY)


func on_many_to_many_button_pressed():
	GlobalEvents.emit_select_tool(Enums.TOOL.MANY_TO_MANY)
