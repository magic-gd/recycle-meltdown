extends Control

export var upgrade_shop_path = "res://UI/shop/sorting shop/SortingUpgradeShop.tscn"

func _ready():
	_connect()
	_update_display()

func _connect():
	$VBoxContainer/ConfigureButton.connect("pressed", self, "goto_factory")
	$VBoxContainer/UpgradesButton.connect("pressed", self, "goto_upgrades")

func goto_factory():
	get_tree().change_scene("res://minigames/SortingMinigame/SortingMinigame.tscn")

func goto_upgrades():
	get_tree().change_scene(upgrade_shop_path)

func _update_display():
	$VBoxContainer/MaterialList/PaperWastePanel/HBoxContainer/Label.text = "%s per minute" % GameData.factory_output["paper_waste"]
	$VBoxContainer/MaterialList/PlasticWastePanel/HBoxContainer/Label.text = "%s per minute" % GameData.factory_output["plastic_waste"]
	$VBoxContainer/MaterialList/GlassWastePanel/HBoxContainer/Label.text = "%s per minute" % GameData.factory_output["glass_waste"]
	$VBoxContainer/MaterialList/MetalWastePanel/HBoxContainer/Label.text = "%s per minute" % GameData.factory_output["metal_waste"]
