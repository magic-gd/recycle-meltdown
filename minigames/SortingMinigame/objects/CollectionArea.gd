tool
extends Area2D

signal score
signal collected
signal mistake

export var collection_type = "paper" setget set_collection_type
export var max_fill = 5

# State
var accepting_trash = true
var fill = 0 setget set_fill

func set_fill(p_fill):
	fill = p_fill
	$TextureProgress.value = fill
	if fill >= max_fill:
		_ship_trash()

func set_collection_type(type):
	collection_type = type
	match collection_type:
		"paper": $Sprite.texture = preload("res://assets/minigames/sort minigame/paper_container.png")
		"plastic": $Sprite.texture = preload("res://assets/minigames/sort minigame/plastic_container.png")
		"glass": $Sprite.texture = preload("res://assets/minigames/sort minigame/glass_container.png")
		"metal": $Sprite.texture = preload("res://assets/minigames/sort minigame/metal_container.png")

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
	if item.collected: return
	item.collected = true
	play_collect_sound(item)
	if item.type != collection_type:
		_on_collection_error()
	else:
		set_fill(fill + item.size)
		emit_signal("collected", collection_type)
		print(fill)
		if fill >= max_fill:
			score()
	
	item.queue_free()

func score():
	if fill <= 0: return
	print("scoring %s" % fill)
	emit_signal("score", collection_type, fill)
	set_fill(0)

func play_collect_sound(item):
	var sounds
	match item.type:
		"paper":
			sounds = [
				"res://assets/sound/paper-1.mp3",
				"res://assets/sound/paper-2.mp3",
			]
		"plastic":
			sounds = [
				"res://assets/sound/plastic-1.mp3",
				"res://assets/sound/plastic-2.mp3",
				"res://assets/sound/plastic-3.mp3",
			]
			# Only plastic bottle makes plastic bottle sound
			if item.get_node("Sprite").frame != 2:
				sounds.remove(0)
		"glass":
			sounds = [
				"res://assets/sound/glass-1.mp3",
				"res://assets/sound/glass-2.mp3",
				"res://assets/sound/glass-3.mp3",
				"res://assets/sound/glass-4.mp3",
			]
		"metal":
			sounds = [
				"res://assets/sound/metal-1.mp3",
				"res://assets/sound/metal-2.mp3",
			]
	
	if not sounds: return
	var sound = sounds[randi() % sounds.size()]
	$AudioStreamPlayer.stream = load(sound)
	$AudioStreamPlayer.volume_db *= GameOptions.sound_volume
	if GameOptions.sound_volume > 0:
		$AudioStreamPlayer.play()

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
