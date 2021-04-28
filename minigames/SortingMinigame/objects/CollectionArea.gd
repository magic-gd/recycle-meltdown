extends Area2D

signal score
signal collected
signal mistake

export var collection_type = "paper"
export var max_fill = 5

var fill = 0

func _ready():
	_connect()

func _connect():
	pass

func _process(delta):
	for item in get_overlapping_areas():
		if item is TrashItem and not item.pressed:
			collect(item)

func collect(item: TrashItem):
	item.queue_free()
	if item.type != collection_type:
		_on_collection_error()
		return
	
	fill += item.size
	emit_signal("collected", collection_type)
	print(fill)
	if fill >= max_fill:
		score()

func score():
	if fill <= 0: return
	print("scoring %s" % fill)
	emit_signal("score", collection_type, fill)
	fill = 0

func _on_collection_error():
	fill = 0
	emit_signal("mistake", collection_type)
	print(fill)
	pass
