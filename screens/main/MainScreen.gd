extends Control

func _ready():
	_connect()

func _connect():
	$UI/SortingButton.connect("pressed", self, "goto_factory", ["sorting"])
	$UI/GlassButton.connect("pressed", self, "goto_factory", ["glass"])
	$UI/PaperButton.connect("pressed", self, "goto_factory", ["paper"])
	$UI/MetalButton.connect("pressed", self, "goto_factory", ["metal"])
	$UI/PlasticButton.connect("pressed", self, "goto_factory", ["plastic"])

func goto_factory(type):
	match type:
		"sorting":
			get_tree().change_scene("res://screens/SortingFactoryScreen.tscn")
		"glass":
			get_tree().change_scene("res://screens/GlassFactoryScreen.tscn")
		"paper":
			pass
		"metal":
			get_tree().change_scene("res://screens/MetalFactoryScreen.tscn")
		"plastic":
			pass
