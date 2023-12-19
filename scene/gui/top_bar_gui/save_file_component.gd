extends Node

@onready var save_file_dialog = %SaveFileDialog

var current_file: String:
	get:
		return get_parent().current_file
	set(file):
		get_parent().current_file = file


func _ready():
	save_file_dialog.file_selected.connect(on_save_file_selected)


func save():
	if current_file:
		save_file(current_file)
	else:
		if OS.has_feature("web"):
			save_file()
		else:
			save_file_dialog.show()


func save_as():
	if current_file:
		save_file_dialog.current_file = current_file
	save_file_dialog.show()


func on_save_file_selected(path: String):
	save_file(path)


func save_file(path: String = ""):
	current_file = path
	if OS.has_feature("web"):
		if path != "":
			save_file_web(path.split("/")[-1])
		else:
			save_file_web("schemer_file.schemer.json")
	else:
		save_file_pc(path)


func save_file_pc(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json = ProjectController.get_file_json()
	file.store_line(JSON.stringify(json, "\t"))
	
	get_parent().update_window_title()


func save_file_web(file_name: String):
	var json = ProjectController.get_file_json()
	WebFileController.save_file(JSON.stringify(json), file_name)
