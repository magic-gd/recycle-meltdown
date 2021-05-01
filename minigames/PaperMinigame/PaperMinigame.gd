extends Node2D

var carton_scene
var elapsed_time = 0 # time since the last carton spawn
var carton_spawn_timeout = 5 # seconds
var width
var cols
const BOX_WIDTH = 60

func _ready():
	carton_scene = load("res://minigames/PaperMinigame/carton.tscn")
	width = get_viewport().size.x
	cols = int(floor(width / BOX_WIDTH))
	elapsed_time = 4 # shorten time until first carton spawn
	randomize()

func _process(delta):
	elapsed_time += delta
	
	if elapsed_time >= carton_spawn_timeout:
		spawn_carton(randi() % cols)

func spawn_carton(col : int):
	var new_carton = carton_scene.instance()
	var offset = BOX_WIDTH / 2
	new_carton.position.x = (col * BOX_WIDTH) + offset
	new_carton.position.y = -offset
	elapsed_time = 0
	decrease_spawn_timeout()
	new_carton.add_to_group("cartons")
	add_child(new_carton)

func decrease_spawn_timeout(scale : float = 0.02, minimum : float = 1):
	var decrease = log(carton_spawn_timeout + 1) * scale
	carton_spawn_timeout = max(carton_spawn_timeout - decrease, minimum)
	print(carton_spawn_timeout)
