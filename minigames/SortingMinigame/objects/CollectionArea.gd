extends Area2D

signal score
signal collected
signal mistake

export var collection_type = "paper"
export var max_fill = 5

# State
var accepting_trash = true
var fill = 0 setget set_fill

func set_fill(p_fill):
	fill = p_fill
	$TextureProgress.value = fill
	if fill >= max_fill:
		_ship_trash()

func _ready():
	_connect()
	$TextureProgress.max_value = max_fill
	$Name.text = collection_type
	
	accepting_trash = true
	set_fill(0)

func _connect():
	pass

func _process(delta):
	if accepting_trash:
		for item in get_overlapping_areas():
			if item is TrashItem and not item.pressed:
				collect(item)


func collect(item: TrashItem):
	item.queue_free()
	if item.type != collection_type:
		_on_collection_error()
		return
	
	set_fill(fill + item.size)
	emit_signal("collected", collection_type)
	print(fill)
	if fill >= max_fill:
		score()

func score():
	if fill <= 0: return
	print("scoring %s" % fill)
	emit_signal("score", collection_type, fill)
	set_fill(0)

func _ship_trash():
	get_tree().paused = true
	$AnimationPlayer.play("ship")
	yield($AnimationPlayer, "animation_finished")
	get_tree().paused = false
	score()

func _dump_trash():
	get_tree().paused = true
	$AnimationPlayer.play("contanimated")
	yield($AnimationPlayer, "animation_finished")
	get_tree().paused = false
	set_fill(0)

func _on_collection_error():
	emit_signal("mistake", collection_type)
	_dump_trash()
