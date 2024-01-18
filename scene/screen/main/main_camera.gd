extends Camera2D

@export var min_zoom := 0.1
@export var max_zoom := 5.0
@export var zoom_factor := 0.1
@export var zoom_duration := 0.2
var zoom_level: float = 1
var position_before_drag
var position_before_drag2


func _ready():
	GlobalEvents.center_camera.connect(center_on_tables)


func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		set_zoom_level(zoom_level + zoom_factor)
	elif event.is_action_pressed("zoom_out"):
		set_zoom_level(zoom_level - zoom_factor)
	elif event.is_action_pressed("camera_drag"):
		position_before_drag = event.global_position
		position_before_drag2 = self.global_position
	elif event.is_action_released("camera_drag"):
		position_before_drag = null
	elif event is InputEventPanGesture:
		self.global_position += event.delta * 20
	elif event is InputEventScreenDrag:
		self.global_position -= event.relative
	elif event is InputEventMagnifyGesture:
		if event.factor > 1:
			set_zoom_level(zoom_level + (zoom_factor * 0.5))
		elif event.factor < 1:
			set_zoom_level(zoom_level - (zoom_factor * 0.5))
	
	if position_before_drag and event is InputEventMouseMotion:
		self.global_position = position_before_drag2 + (position_before_drag - event.global_position) * (1/zoom_level)


func set_zoom_level(level: float, mouse_world_position = self.get_global_mouse_position()):
	var old_zoom_level = zoom_level
	
	zoom_level = clampf(level, min_zoom, max_zoom)
	
	var direction = (mouse_world_position - self.global_position)
	var new_position = self.global_position + direction - ((direction) / (zoom_level/old_zoom_level))
	
	self.zoom = Vector2(zoom_level, zoom_level)
	self.global_position = new_position


func center_on_tables():
	var tables: Array[Node] = get_tree().get_nodes_in_group("tables")
	
	var max_x = tables[0].global_position.x + tables[0].size.x
	var min_x = tables[0].global_position.x
	var max_y = tables[0].global_position.y + tables[0].size.y
	var min_y = tables[0].global_position.y
	
	for table in tables:
		max_x = max(max_x, table.global_position.x + table.size.x)
		min_x = min(min_x, table.global_position.x)
		max_y = max(max_y, table.global_position.y + table.size.y)
		min_y = min(min_y, table.global_position.y)
	
	var center = Vector2((max_x - min_x) / 2 + min_x, (max_y - min_y) / 2 + min_y)
	global_position = center
	
	# Find out the zoom
	var screen_width = get_viewport().get_visible_rect().size.x
	var project_width = max_x - min_x + 300
	
	if project_width > screen_width:
		var new_zoom_level = screen_width/project_width
		set_zoom_level(new_zoom_level, global_position)
