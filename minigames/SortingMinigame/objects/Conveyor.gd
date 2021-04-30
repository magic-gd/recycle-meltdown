extends Area2D

export var speed = 100

func _process(delta):
	# Move trash on conveyor
	for area in get_overlapping_areas():
		if area is TrashItem:
			if not area.pressed:
				area.position.y -= speed * delta
	
	# Animate movement
	$Sprite.texture.region.position.y += speed * delta
