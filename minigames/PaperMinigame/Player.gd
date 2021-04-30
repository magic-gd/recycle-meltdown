extends KinematicBody2D

var velocity = Vector2(0, 0)
var deltaV = 280
var jumpForce = 720
var gravity = 32

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -deltaV
	elif Input.is_action_pressed("ui_right"):
		velocity.x = deltaV
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jumpForce
		
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.1)
