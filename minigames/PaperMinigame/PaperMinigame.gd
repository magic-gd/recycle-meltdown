extends Node2D

var carton_scene
var elapsed_time = 0 # time since the last carton spawn
var carton_spawn_timeout = 10000 # seconds
var width
var cols
const BOX_WIDTH = 60

func _ready():
	_connect()
	_apply_upgrades()
	if float(GameData.factory_output["paper_waste"]) > 0.001:
		carton_spawn_timeout = 20 / float(GameData.factory_output["paper_waste"])
	carton_scene = load("res://minigames/PaperMinigame/carton.tscn")
	width = get_viewport().size.x
	cols = int(floor(width / BOX_WIDTH))
	elapsed_time = 4 # shorten time until first carton spawn
	randomize()

func _connect():
	$CanvasLayer/MenuButton.connect("exit", SceneManager, "goto_main")
	$Ground.connect("score", self, "score")

func _process(delta):
	elapsed_time += delta
	
	if elapsed_time >= carton_spawn_timeout:
		spawn_carton(randi() % cols)

func score(amount):
	if find_node("Player"):
		GameData.change_resource("paper", amount)

func spawn_carton(col : int):
	var new_carton = carton_scene.instance()
	var offset = BOX_WIDTH / 2
	new_carton.position.x = (col * BOX_WIDTH) + offset
	new_carton.position.y = -offset
	elapsed_time = 0
#	decrease_spawn_timeout()
	add_child(new_carton)

func decrease_spawn_timeout(scale : float = 0.05, minimum : float = 0.8):
	var decrease = log(carton_spawn_timeout + 1) * scale
	carton_spawn_timeout = max(carton_spawn_timeout - decrease, minimum)

func _apply_upgrades():
	if "paper_double_jump" in GameData.upgrades:
			$Player.max_air_jumps += 1
