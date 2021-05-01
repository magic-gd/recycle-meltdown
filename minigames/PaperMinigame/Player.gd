extends KinematicBody2D

const SIZE := 60
const MIN_PUSH_SURFACE := 40
var velocity := Vector2(0, 0)
var deltaV := 280
var jumpForce := 720
var gravity := 32

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
	
	for i in range(get_slide_count() - 1):
		var collider = get_slide_collision(i).collider
		var delta_pos : Vector2 = collider.position - position
		if collider.is_in_group("cartons"):
			handle_carton_collision(delta_pos, collider)

func handle_carton_collision(v : Vector2, c : Object):
	if abs(v.y) <= MIN_PUSH_SURFACE:
		c.push(v.x)
	
func die():
	hide()
	print("ded")
