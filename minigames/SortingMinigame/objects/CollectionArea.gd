extends Area2D

export var collection_type = "paper"
export var max_fill = 100

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
	print(fill)
	if fill >= max_fill:
		print("scoring %s" % max_fill)
		emit_signal("score", collection_type, max_fill)
		fill = 0


func _on_collection_error():
	fill = 0
	print(fill)
	pass
