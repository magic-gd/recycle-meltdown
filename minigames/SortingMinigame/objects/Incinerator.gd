extends Area2D

signal burned

func _process(delta):
	for item in get_overlapping_areas():
		if item is TrashItem and not item.pressed:
			burn(item)

func burn(item: TrashItem):
	item.queue_free()
	$AnimationPlayer.play("burn")
	emit_signal("burned", item)
