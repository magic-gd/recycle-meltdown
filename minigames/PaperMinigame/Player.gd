extends KinematicBody2D

var velocity = Vector2(0, 0)
var deltaV = 280
var jumpForce = 720
var gravity = 32

func _physics_process(delta):
	var direction = 0
	
	if Input.is_action_pressed("ui_left"):
		velocity.x = -deltaV
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = deltaV
		direction = 1
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jumpForce
		
	velocity.y += gravity
	velocity = move_and_slide(velocity, Vector2.UP)	
	velocity.x = lerp(velocity.x, 0, 0.1)
	
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if "carton" in collision.collider.name:
			collision.collider.move(direction)
