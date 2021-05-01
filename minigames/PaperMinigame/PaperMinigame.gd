extends Node2D

var carton_scene
var elapsed_time = 0 # time since the last carton spawn
var carton_spawn_timeout = 5 # seconds
var width
var cols
var box_width = 60

func _ready():
	carton_scene = load("res://minigames/PaperMinigame/carton.tscn")
	width = get_viewport().size.x
	cols = int(floor(width / box_width))

func _process(delta):
	elapsed_time += delta
	
	if elapsed_time >= carton_spawn_timeout:
		spawn_carton(randi() % cols)

func spawn_carton(col):
	var new_carton = carton_scene.instance()
	var offset = box_width / 2
	new_carton.position.x = (col * box_width) + offset
	new_carton.position.y = offset
	elapsed_time = 0
	new_carton.add_to_group("cartons")
	add_child(new_carton)
