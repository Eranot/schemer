extends PanelContainer

@onready var file_menu_button = %FileMenuButton
@onready var help_menu_button = %HelpMenuButton
@onready var new_file_component = $NewFileComponent
@onready var save_file_component = $SaveFileComponent
@onready var open_file_component = $OpenFileComponent


var current_file: String


func _ready():
	file_menu_button.get_popup().transparent_bg = true
	help_menu_button.get_popup().transparent_bg = true
	
	file_menu_button.get_popup().id_pressed.connect(on_file_menu_pressed)
	help_menu_button.get_popup().id_pressed.connect(on_help_menu_pressed)
	
	setup_shortcuts()
	
	update_window_title()


func on_file_menu_pressed(id: int):
	if id == 0: # New file
		new_file_component.new_file()
	elif id == 1: # Open file
		open_file_component.open()
	elif id == 2: # Save
		save_file_component.save()
	elif id == 3: # Save as
		save_file_component.save_as()


func on_help_menu_pressed(id: int):
	if id == 0: # Website
		OS.shell_open("https://schemer.gg")
	elif id == 1: # Github
		OS.shell_open("https://github.com/Eranot/schemer")
	elif id == 2: # About
		save_file_component.save()


func setup_shortcuts():
	# New File
	var new_event = InputEventAction.new()
	new_event.action = "new_file"
	var new_shortcut = Shortcut.new()
	new_shortcut.events = [new_event]
	file_menu_button.get_popup().set_item_shortcut(0, new_shortcut)
	
	# Open file
	var open_event = InputEventAction.new()
	open_event.action = "open_file"
	var open_shortcut = Shortcut.new()
	open_shortcut.events = [open_event]
	file_menu_button.get_popup().set_item_shortcut(1, open_shortcut)
	
	# Save file
	var save_event = InputEventAction.new()
	save_event.action = "save_file"
	var save_shortcut = Shortcut.new()
	save_shortcut.events = [save_event]
	file_menu_button.get_popup().set_item_shortcut(2, save_shortcut)
	
	# Save file as
	var save_as_event = InputEventAction.new()
	save_as_event.action = "save_file_as"
	var save_as_shortcut = Shortcut.new()
	save_as_shortcut.events = [save_as_event]
	file_menu_button.get_popup().set_item_shortcut(3, save_as_shortcut)


func update_window_title():
	if current_file:
		DisplayServer.window_set_title("Schemer - " + current_file)
	else:
		DisplayServer.window_set_title("Schemer - new file")
