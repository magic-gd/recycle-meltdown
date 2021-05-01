extends Node2D

var carton_scene : Resource
var elapsed_time : float = 0 # time since the last carton spawn
var carton_spawn_timeout : float = 5 # seconds
var spawn_enabled := false
var scoring_enabled := true
var width : float
var cols : int
const BOX_WIDTH := 60

func _ready():
	_connect()
	carton_scene = load("res://minigames/PaperMinigame/carton.tscn")
	width = get_viewport().size.x
	cols = int(floor(width / BOX_WIDTH))
	elapsed_time = 4 # shorten time until first carton spawn
	set_paper_input()
	randomize()
	
func set_paper_input(duration_till_repeat : float = 20):
	var paper_waste := float(GameData.factory_output["paper_waste"])
	if paper_waste > 0.01:
		spawn_enabled = true
		carton_spawn_timeout = duration_till_repeat / paper_waste

func _connect():
	$CanvasLayer/MenuButton.connect("exit", SceneManager, "goto_main")
	$Ground.connect("score", self, "score")

func _process(delta):
	elapsed_time += delta
	
	if elapsed_time >= carton_spawn_timeout:
		elapsed_time = 0
		spawn_carton(randi() % cols)

func score(amount):
	if scoring_enabled:
		GameData.change_resource("paper", amount)
		
func game_over():
	# TODO: game over screen
	spawn_enabled = false
	scoring_enabled = false
	
func _on_Player_game_over():
	game_over()

func spawn_carton(col : int):
	if not spawn_enabled: return
	var new_carton = carton_scene.instance()
	var offset = BOX_WIDTH / 2
	new_carton.position.x = (col * BOX_WIDTH) + offset
	new_carton.position.y = -offset
	new_carton.game_manager = self
	add_child(new_carton)

func decrease_spawn_timeout(scale : float = 0.05, minimum : float = 0.8):
	var decrease = log(carton_spawn_timeout + 1) * scale
	carton_spawn_timeout = max(carton_spawn_timeout - decrease, minimum)


