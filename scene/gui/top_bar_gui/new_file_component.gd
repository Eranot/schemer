extends Node

var current_file: String:
	get:
		return get_parent().current_file
	set(file):
		get_parent().current_file = file


func new_file():
	get_parent().update_window_title()
	ProjectController.emit_clean_project()
	current_file = ""
