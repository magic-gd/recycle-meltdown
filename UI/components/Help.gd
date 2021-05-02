extends Control

func _on_Button_pressed():
	$InfoText.visible = not $InfoText.visible
	get_tree().paused = $InfoText.visible

func _on_Continue_pressed():
	$InfoText.visible = false
	get_tree().paused = false
