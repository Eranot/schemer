extends Control

signal dragged

## Whether the dragging behaviour is active or not
@export var active: bool = true

## The node that will be dragged
@export var parent: Control

@onready var timer = $Timer

var drag_position = null
var was_dragged = false
var min_x
var max_x


func _ready():
	self.gui_input.connect(_on_gui_input)
	timer.timeout.connect(on_timer_timeout)


func _on_gui_input(event):
	if not active:
		self.mouse_default_cursor_shape = CursorShape.CURSOR_ARROW
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_position = get_global_mouse_position()
		
		if event.pressed:
			drag_position = mouse_position - parent.global_position
		else:
			drag_position = null
		return
	elif event is InputEventMouseMotion:
		var mouse_position = get_global_mouse_position()
		self.mouse_default_cursor_shape = CursorShape.CURSOR_HSIZE
		if drag_position:
			var new_x = (mouse_position - drag_position).x
			
			if min_x != null and max_x != null:
				new_x = clamp(new_x, min_x, max_x)
			
			parent.global_position.x = new_x
			was_dragged = true
		return


func on_timer_timeout():
	if was_dragged:
		dragged.emit()
		was_dragged = false
