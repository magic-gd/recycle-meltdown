extends KinematicBody2D

const SIZE := 60
const MIN_PUSH_SURFACE := 40
const EPSILON := 1
const GRAVITY := 32
var velocity := Vector2(0, 0)
var goes_up := false
var deltaV := 220
var jumpForce := 720

func _physics_process(delta):
	if Input.is_action_pressed("ui_left"):
		velocity.x = -deltaV
	elif Input.is_action_pressed("ui_right"):
		velocity.x = deltaV
		
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jumpForce
		goes_up = true
		
	velocity.y += GRAVITY
	if velocity.y >= 0: goes_up = false 
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(velocity.x, 0, 0.1)
	
	for i in range(get_slide_count() - 1):
		var collider = get_slide_collision(i).collider
		var delta_pos : Vector2 = collider.position - position
		if collider.is_in_group("cartons"):
			handle_carton_collision(delta_pos, collider)
	

func handle_carton_collision(v : Vector2, c : Object):
	# The player has to push a carton with at least (1/3) of his body.
	if abs(v.y) <= MIN_PUSH_SURFACE:
		c.push(v.x)
	
	var death_radius = SIZE - 2 * EPSILON
	if abs(v.x) <= death_radius and v.y <= -death_radius: 
		# The carton is above the player.
		if goes_up: 
			# The player is jumping against the carton.
			destroy_carton(c)
		else:
			die()
	
func die():
	get_parent().remove_child(self)
	print("ded")

func destroy_carton(carton):
	get_parent().remove_child(carton)

func _on_PlayerArea_area_entered(area):
	var parent = area.get_parent()
	var delta_pos : Vector2 = parent.position - position
	if parent.is_in_group("cartons"):
		handle_carton_collision(delta_pos, parent)

func print_vector(v : Vector2):
	print("{x: " + str(v.x) + ", y: " + str(v.y) + "}")
