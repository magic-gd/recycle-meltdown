extends KinematicBody2D

const FALLING_VELOCITY := 180
const PUSH_VELOCITY := 100
const MOVE_DIST := 60
const EPSILON := 1
var velocity := Vector2(0, 0)
var gets_pushed := false
var push_direction : int = 0
var initial_pos : Vector2
var game_manager

func _process(delta):
	if is_on_floor():
		velocity.y = 0
		check_fullness()
	else:
		velocity.y = FALLING_VELOCITY
	
	if gets_pushed:
		var dist = diff(position.x, initial_pos.x)
		if MOVE_DIST - dist < EPSILON:
			var new_pos = push_direction * MOVE_DIST + initial_pos.x
			position.x = enforce_grid(new_pos, true)
			gets_pushed = false
			push_direction = 0
		
		velocity.x = push_direction * PUSH_VELOCITY
		
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if abs(velocity.x) <= EPSILON:
		position.x = enforce_grid(position.x, true)
		gets_pushed = false
		push_direction = 0
		
	
func push(direction):
	if gets_pushed: return
	
	initial_pos = position
	push_direction = normalize(direction)
	gets_pushed = true
	
func enforce_grid(x_pos : float, include_offset : bool) -> float:
	var offset = MOVE_DIST / 2
	var left_pos = x_pos - offset
	var clean_pos = stepify(left_pos, MOVE_DIST)
	
	if include_offset:
		return clean_pos + offset
	else:
		return clean_pos
	
func check_fullness():
	if position.y < MOVE_DIST:
		game_manager.game_over("Oh no, looks like we have a blockage here.")

func diff(a : float, b : float) -> float:
	if a > b: return a - b
	return b - a
	
func normalize(num) -> int:
	if num < 0: return -1
	if num > 0: return +1
	return 0
