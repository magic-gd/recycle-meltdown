extends Node2D

onready var spawn_timer = $SpawnTimer
onready var end_screen = $UI/EndScreen

export var speedup_on = 5
export var base_speed = 100
export var max_emissions = 100
export var max_energy = 1000.0
export var energy_usage = 5.0
export var base_spawn_rate = 1.0

var spawn_table

var energy = 1000.0 setget set_energy
var speed setget set_speed
var spawn_rate setget set_spawn_rate
var score = {
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
}
var emissions = 0 setget set_emissions

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
	_connect()
	randomize()
	
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

func spawn_trash():
	var spawn_point = $SpawnPoints.get_child(randi() % $SpawnPoints.get_child_count())
	var trash_item = _get_trash_item()
	if not trash_item or not spawn_point: return
	
	trash_item.position = spawn_point.position
	trash_item.rotation_degrees = randi() % 360
	$Trash.add_child(trash_item)

func end_game(reason="none"):
	_score_collection_areas()
	get_tree().paused = true
	end_screen.display_score(score)
	end_screen.visible = true
	pass

func _score_collection_areas():
	for collection_area in $CollectionAreas.get_children():
		collection_area.score()

func _on_score(type, amount):
	if not type in score: return
	score[type] += amount

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
	speedup_factor = 0.5
	_speed_up()

func _on_burned(item):
	print("burned %s" % item.emission)
	# Add energy
	set_energy(energy + item.fuel * 100)
	set_emissions(emissions + item.emission)
	if item.type != "waste":
		_reset_speed()

func _get_trash_item():
	var trash_item
	match randi() % 100000:
		0: trash_item = preload("res://objects/trash/Trash_Newspaper.tscn").instance()
		_: trash_item = preload("res://objects/trash/Trash_GlassBottle.tscn").instance()
	
	return trash_item
