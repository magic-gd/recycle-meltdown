extends Node2D

onready var end_screen := $UI/GameOver
onready var carton_scene := load("res://minigames/PaperMinigame/carton.tscn")

const BOX_WIDTH := 60

var elapsed_time : float = 0 # time since the last carton spawn
var carton_spawn_timeout : float = 5 # seconds. Overwritten by paper input
var spawn_enabled := false
var scoring_enabled := true
var width : float
var cols : int
var collected_paper : int = 0

func _ready():
	_connect()
	randomize()
	_apply_upgrades()
	
	width = get_viewport().size.x
	cols = int(floor(width / BOX_WIDTH))
	
	set_paper_input()
	elapsed_time = carton_spawn_timeout # shorten time until first carton spawn
	
func set_paper_input(duration_till_repeat : float = 20):
	var paper_waste := float(GameData.factory_output["paper_waste"])
	if paper_waste > 0.01:
		spawn_enabled = true
		$UI/NoPaperInfoText.visible = false
		carton_spawn_timeout = duration_till_repeat / paper_waste

func _connect():
	$UI/MenuButton.connect("exit", SceneManager, "goto_main")
	$Ground.connect("score", self, "score")

func _process(delta):
	elapsed_time += delta
	
	if elapsed_time >= carton_spawn_timeout:
		elapsed_time = 0
		spawn_carton(randi() % cols)

func score(amount : int = 1):
	if scoring_enabled:
		collected_paper += amount
		GameData.change_resource("paper", amount)
		
func game_over(reason : String = ""):
	end_screen.set_reason(reason)
	end_screen.set_paper(collected_paper)
	end_screen.visible = true
	spawn_enabled = false
	scoring_enabled = false
	
func _on_Player_game_over():
	game_over("Tiffany went missing under all that paper!\n"
		+"We have to pause the machines and help her out of there first.")

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

func _apply_upgrades():
	if "paper_double_jump" in GameData.upgrades:
			$Player.max_air_jumps += 1
