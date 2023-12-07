extends Camera2D

@export var min_zoom := 0.1
@export var max_zoom := 5.0
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2
var zoom_level: float = 1
var position_before_drag
var position_before_drag2


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level + zoom_factor)
	if event.is_action_pressed("zoom_out"):
		set_zoom_level(zoom_level - zoom_factor)
	if event.is_action_pressed("camera_drag"):
		position_before_drag = event.global_position
		position_before_drag2 = self.global_position
	if event.is_action_released("camera_drag"):
		position_before_drag = null
	
	if position_before_drag:
		self.global_position = position_before_drag2 + (position_before_drag - event.global_position) * (1/zoom_level)


func set_zoom_level(level: float):
	var tween = get_tree().create_tween()
	zoom_level = clampf(level, min_zoom, max_zoom)
	tween.tween_property(self, "zoom", Vector2(zoom_level, zoom_level), zoom_duration)\
		.set_trans(Tween.TRANS_SINE)
