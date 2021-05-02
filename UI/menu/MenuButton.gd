extends Control

signal pause
signal resume
signal exit

func _ready():
	_connect()
	$Menu.visible = false
	$Menu/MuteButton.pressed = GameOptions.sound_volume == 0.0

func _connect():
	$PauseButton.connect("pressed", self, "_pause")
	$Menu/ExitButton.connect("pressed", self, "_exit")
	$Menu/ResumeButton.connect("pressed", self, "_resume")
	$Menu/MuteButton.connect("toggled", self, "_toggle_mute")

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

func _toggle_mute(on):
	GameOptions.sound_volume = 0.0 if on else 1.0
