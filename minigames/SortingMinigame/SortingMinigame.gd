extends Node2D

onready var spawn_timer = $SpawnTimer
onready var end_screen = $UI/EndScreen

export var base_speed = 100
export var base_spawn_rate = 2.0
export var speedup_on = 5
export var energy_usage = 5.0
export var max_emissions = 20000
export var max_energy = 1000.0
export var fuel_efficiency = 100

var spawn_table
var spawn_table_total_weight

var energy = 1000.0 setget set_energy
var speed setget set_speed
var spawn_rate setget set_spawn_rate
var score = {
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
}
var emissions = 0.0 setget set_emissions

var streak = 0
var speedup_factor = 1.0
var max_speedup_factor = 5.0

func set_energy(p_energy):
	p_energy = clamp(p_energy, 0, max_energy)
	energy = p_energy
	$UI/EnergyBar.value = energy
	
	if energy <= 0:
		end_game("energy")

func set_speed(p_speed):
	speed = p_speed
	$Conveyor.speed = speed

func set_spawn_rate(p_spawn_rate):
	spawn_rate = p_spawn_rate
	$SpawnTimer.wait_time = spawn_rate

func set_emissions(p_emissions):
	p_emissions = clamp(p_emissions, 0, max_emissions)
	emissions = p_emissions
	$UI/EmissionBar.value = emissions
	print("emissions: %s" % emissions)
	
	if emissions >= max_emissions:
		end_game("emissions")

func _ready():
	_apply_upgrades()
	
	randomize()
	
	_connect()
	_init_spawn_table()
	_update_score_display()
	
	end_screen.visible = false
	
	$UI/EmissionBar.set_max_value(max_emissions)
	$UI/EnergyBar.set_max_value(max_energy)
	
	set_speed(base_speed)
	set_spawn_rate(base_spawn_rate)
	set_emissions(emissions)
	set_energy(max_energy)
	
	spawn_timer.start()

func _process(delta):
	set_energy(energy - energy_usage * delta * 10)

func _connect():
	spawn_timer.connect("timeout", self, "spawn_trash")
	
	for collection_area in $CollectionAreas.get_children():
		collection_area.connect("score", self, "_on_score")
		collection_area.connect("collected", self, "_on_collected")
		collection_area.connect("mistake", self, "_on_mistake")
	
	$Incinerator.connect("burned", self, "_on_burned")
	$UI/MenuButton.connect("exit", SceneManager, "goto_main")
	$UI/EndScreen.connect("exit", SceneManager, "goto_main")

func spawn_trash():
	var spawn_point = $SpawnPoints.get_child(randi() % $SpawnPoints.get_child_count())
	var trash_item = _get_trash_item()
	if not trash_item or not spawn_point: return
	
	trash_item.position = spawn_point.position
	trash_item.rotation_degrees = randi() % 360
	trash_item.scale *= 1.5
	$Trash.add_child(trash_item)

func end_game(reason=null):
	match reason:
		"energy":
			reason = "Ran out of energy."
		"emissions":
			reason = "Emission limit reached."
	_score_collection_areas()
	_save_score_to_gamedata()
	get_tree().paused = true
	end_screen.display_score(score)
	end_screen.set_reason(reason)
	end_screen.visible = true

func _apply_upgrades():
	if "sorting_solar" in GameData.upgrades:
		energy_usage *= 0.8
	if "more_trash" in GameData.upgrades:
		base_spawn_rate *= 0.75
	if "even_more_trash" in GameData.upgrades:
		base_spawn_rate *= 0.75
	if "lots_of_trash" in GameData.upgrades:
		base_spawn_rate *= 0.75

func _init_spawn_table():
	# Setup table for weighted random selection
	spawn_table_total_weight = 0.0
	spawn_table = GameData.waste_spawn_table.duplicate(true)
	
	for item in spawn_table:
		spawn_table_total_weight += spawn_table[item]
		spawn_table[item] = spawn_table_total_weight

func _save_score_to_gamedata():
	GameData.factory_output["paper_waste"] = score["paper"]
	GameData.factory_output["plastic_waste"] = score["plastic"]
	GameData.factory_output["glass_waste"] = score["glass"]
	GameData.factory_output["metal_waste"] = score["metal"]

func _score_collection_areas():
	for collection_area in $CollectionAreas.get_children():
		collection_area.score()

func _on_score(type, amount):
	if not type in score: return
	score[type] += amount
	_update_score_display()

func _on_collected(type):
	print("collected")
	_add_streak()

func _on_mistake(type):
	_reset_speed()

func _add_streak():
	streak += 1
	if streak % speedup_on == 0:
		_speed_up()

func _speed_up():
	print("speed up")
	speedup_factor = clamp(speedup_factor + 0.5, 0, max_speedup_factor)
	set_speed(base_speed * speedup_factor)
	set_spawn_rate(base_spawn_rate / speedup_factor)

func _reset_speed():
	speedup_factor = 1.0
	set_speed(base_speed)
	set_spawn_rate(base_spawn_rate)

func _on_burned(item):
	print("burned %s" % item.emission)
	# Add energy
	set_energy(energy + item.fuel * fuel_efficiency)
	set_emissions(emissions + item.emission)
	if item.type != "waste":
		_reset_speed()

func _update_score_display():
	$UI/ScoreDisplay/PaperScoreLabel.text = "Paper: %s" % score["paper"]
	$UI/ScoreDisplay/PlasticScoreLabel.text = "Plastic: %s" % score["plastic"]
	$UI/ScoreDisplay/GlassScoreLabel.text = "Glass: %s" % score["glass"]
	$UI/ScoreDisplay/MetalScoreLabel.text = "Metal: %s" % score["metal"]

func _get_trash_item():
	var trash_item = null
	var spawn_item_type = ""
	# Weighted random selection
	var roll = rand_range(0, spawn_table_total_weight)
	for item_type in spawn_table:
		if spawn_table[item_type] > roll:
			spawn_item_type = item_type
			break
	
	print("spawning %s" % spawn_item_type)
	match spawn_item_type:
		"paper": trash_item = preload("res://objects/trash/Trash_Paper.tscn").instance()
		"plastic": trash_item = preload("res://objects/trash/Trash_Plastic.tscn").instance()
		"glass": trash_item = preload("res://objects/trash/Trash_Glass.tscn").instance()
		"metal": trash_item = preload("res://objects/trash/Trash_Metal.tscn").instance()
		"organic": trash_item = preload("res://objects/trash/Trash_Organic.tscn").instance()
	
	return trash_item
