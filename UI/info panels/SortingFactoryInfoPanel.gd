extends Control

func _ready():
	_connect()

func _connect():
	$VBoxContainer/ConfigureButton.connect("pressed", self, "goto_factory")

func goto_factory():
	get_tree().change_scene("res://screens/SortingFactoryScreen.tscn")
