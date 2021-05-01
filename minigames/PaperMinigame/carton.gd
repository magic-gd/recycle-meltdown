extends KinematicBody2D

const FALLING_VELOCITY = 100
const PUSH_VELOCITY = 120
const MOVE_DIST = 60
const EPSILON = 0.1
var velocity = Vector2(0, 0)
var gets_pushed = false
var push_direction = 0
var initial_pos

func _process(delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = FALLING_VELOCITY
	
	if gets_pushed:
		var dist = diff(position.x, initial_pos.x)
		if MOVE_DIST - dist < EPSILON:
			gets_pushed = false
			push_direction = 0
		
		velocity.x = push_direction * PUSH_VELOCITY
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x == 0:
		gets_pushed = false
		push_direction = 0
	
func move(direction):
	if gets_pushed: return
	
	initial_pos = position
	push_direction = direction
	gets_pushed = true
	
func diff(a, b):
	if a > b: return a - b
	return b - a
