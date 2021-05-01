extends Control



func _on_LeftButton_button_down():
	Input.action_press("move_left")


func _on_LeftButton_button_up():
	Input.action_release("move_left")


func _on_RightButton_button_down():
	Input.action_press("move_right")


func _on_RightButton_button_up():
	Input.action_release("move_right")


func _on_JumpButton_button_down():
	Input.action_press("jump")


func _on_JumpButton_button_up():
	Input.action_release("jump")
