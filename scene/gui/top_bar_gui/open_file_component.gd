extends Node

@onready var open_file_dialog = %OpenFileDialog

var current_file: String:
	get:
		return get_parent().current_file
	set(file):
		get_parent().current_file = file


func _ready():
	open_file_dialog.file_selected.connect(on_open_file_selected)


func open():
	if OS.has_feature("web"):
		open_file_web()
	else:
		open_file_dialog.show()


func on_open_file_selected(path: String):
	current_file = path
	get_parent().update_window_title()
	open_file_pc(path)



func open_file_pc(path: String):
	ProjectController.emit_clean_project()
	await get_tree().create_timer(0.1).timeout
	
	var save_file = FileAccess.open(path, FileAccess.READ)
	var json = save_file.get_as_text()
	ProjectController.import_from_json(json)


func open_file_web():
	var json = await WebFileController.open_file()
	await get_tree().create_timer(0.1).timeout
	if json:
		ProjectController.emit_clean_project()
		ProjectController.import_from_json(json)
