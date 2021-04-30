extends KinematicBody2D

const FALLING_VELOCITY = 10
var velocity = Vector2(0, 0)

func _ready():
	velocity.y = FALLING_VELOCITY

func _process(delta):
	var collision = move_and_collide(velocity)
	
