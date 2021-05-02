class_name TrashItem
extends Area2D

export var type = "paper"
export var size = 1.0
export var emission = 1.0
export var fuel = 1.0

export var draggable = true

var pressed = false
var collected = false

func _ready():
	$DragArea.connect("input_event", self, "_on_input_event")
	
	# Randomize sprite
	$Sprite.frame = randi() % $Sprite.hframes

func _on_input_event(viewport, event, shape_idx):
	if not draggable: return
	# Grab
	if event is InputEventMouseButton and event.pressed:
		if not get_tree().get_nodes_in_group("dragging"):
			pressed = true
			add_to_group("dragging")
			raise()
			get_tree().set_input_as_handled()


func _input(event):
	if not pressed: return
	
	# Drag
	if event is InputEventMouseMotion:
		position = event.position
	
	# Release
	if event is InputEventMouseButton and not event.pressed:
		if is_in_group("dragging"):
			pressed = false
			# Remove all nodes from dragging group
			for node in get_tree().get_nodes_in_group("dragging"):
				node.remove_from_group("dragging")
	
