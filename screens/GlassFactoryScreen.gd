extends Control

func _ready():
	_connect()

func _connect():
	$MenuButton.connect("pressed", self, "_goto_menu")

func _goto_menu():
	get_tree().change_scene("res://screens/main/MainScreen.tscn")
