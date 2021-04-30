extends KinematicBody2D

const FALLING_VELOCITY = 100
const PUSH_VELOCITY = 120
const MOVE_DIST = 60
var velocity = Vector2(0, 0)
var gets_pushed = false
var initial_pos

func _ready():
	velocity.y = FALLING_VELOCITY

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if gets_pushed:
		var dist = diff(position.x, initial_pos.x)
		if dist - MOVE_DIST < 0.1:
			gets_pushed = false
			velocity.x = 0
	
func move(direction):
	if gets_pushed: return
	
	initial_pos = position
	velocity.x = direction * PUSH_VELOCITY
	gets_pushed = true
	
func diff(a, b):
	if a > b: return a - b
	return b - a
