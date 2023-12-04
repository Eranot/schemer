extends Control


func _gui_input(event):
	if Input.is_action_just_pressed("unselect_table"):
		GlobalEvents.emit_unselect_table()
