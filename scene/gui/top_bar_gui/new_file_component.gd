extends Node

var current_file: String:
	get:
		return get_parent().current_file
	set(file):
		get_parent().current_file = file


func new_file(path: String = ""):
	DisplayServer.window_set_title("Schemer - new file")
	ProjectController.emit_clean_project()
	current_file = ""
