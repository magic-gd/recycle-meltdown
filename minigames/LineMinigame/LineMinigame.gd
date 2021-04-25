extends Node2D

const LINE_COLOR = Color("#ffffff")
const LINE_WIDTH = 10.0
const MAX_DRAW_LENGTH = 200

var pressed
var current_line

onready var draw_area = $DrawArea

func _ready():
	_connect()

func _connect():
	draw_area.connect("input_event", self, "_on_DrawArea_input")

func _on_DrawArea_input(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		pressed = event.pressed
		if pressed:
			_start_line(event.position)
		else:
			_finalize_current_line()
	
	if event is InputEventMouseMotion:
		if pressed and current_line:
			_set_line_end(event.position)

func _start_line(position):
	position = _get_valid_starting_pos(position)
	if not position: return
	
	current_line = Line2D.new()
	current_line.add_point(position)
	draw_area.add_child(current_line)
	current_line.default_color = LINE_COLOR
	current_line.width = LINE_WIDTH

func _set_line_end(end_pos):
	if not current_line or current_line.get_point_count() < 1: return
	var start_point = current_line.get_point_position(0)
	
	if start_point.distance_to(end_pos) > MAX_DRAW_LENGTH:
		end_pos = start_point + start_point.direction_to(end_pos) * MAX_DRAW_LENGTH
	
	if current_line.get_point_count() < 2:
		current_line.add_point(end_pos)
	else:
		current_line.set_point_position(1, end_pos)

func _finalize_current_line():
	if not current_line: return
	var start_pos = current_line.get_point_position(0)
	var end_pos = current_line.get_point_position(1)
	end_pos = _get_valid_end_pos(end_pos)
	if end_pos:
		current_line.set_point_position(1, end_pos)
	else:
		current_line.queue_free()
	current_line = null

func _get_valid_starting_pos(position):
	return position

func _get_valid_end_pos(position):
	return position
