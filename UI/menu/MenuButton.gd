extends Control

signal pause
signal resume
signal exit

func _ready():
	_connect()
	$Menu.visible = false

func _connect():
	$PauseButton.connect("pressed", self, "_pause")
	$Menu/ExitButton.connect("pressed", self, "_exit")
	$Menu/ResumeButton.connect("pressed", self, "_resume")

func _pause():
	$Menu.visible = true
	get_tree().paused = true
	emit_signal("pause")

func _exit():
	emit_signal("exit")

func _resume():
	$Menu.visible = false
	get_tree().paused = false
	emit_signal("resume")
