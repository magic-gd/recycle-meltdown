extends Node2D

onready var spawn_timer = $SpawnTimer

var spawn_table

var energy = 1000
var speed = 100
var score = {
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
}

func _ready():
	_connect()
	
	spawn_timer.start()
	$Conveyor.speed = speed

func _connect():
	spawn_timer.connect("timeout", self, "spawn_trash")
	
	$CollectionAreas/PaperCollectionArea.connect("score", self, "_on_score")

func spawn_trash():
	var spawn_point = $SpawnPoints.get_child(randi() % $SpawnPoints.get_child_count())
	var trash_item = _get_trash_item()
	if not trash_item or not spawn_point: return
	
	trash_item.position = spawn_point.position
	$Trash.add_child(trash_item)

func _on_score(type, amount):
	if not score.has(type): return
	score["type"] += amount

func _get_trash_item():
	var trash_item
	match randi() % 3:
		0: trash_item = preload("res://objects/trash/Trash_Newspaper.tscn").instance()
		_: trash_item = preload("res://objects/trash/Trash_GlassBottle.tscn").instance()
	
	return trash_item
