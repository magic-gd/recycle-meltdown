extends Control

export var upgrade_shop_path = "res://UI/shop/sorting shop/SortingUpgradeShop.tscn"

func _ready():
	_connect()

func _connect():
	$VBoxContainer/ConfigureButton.connect("pressed", self, "goto_factory")
	$VBoxContainer/UpgradesButton.connect("pressed", self, "goto_upgrades")

func goto_factory():
	get_tree().change_scene("res://screens/SortingFactoryScreen.tscn")

func goto_upgrades():
	get_tree().change_scene(upgrade_shop_path)
