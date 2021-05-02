extends Control

export var upgrade_shop_path = "res://UI/shop/sorting shop/GlassUpgradeShop.tscn"

func _ready():
	_connect()
	_update_resource_panel()

func _connect():
	GameData.connect("resource_change", self, "_update_resource_panel")
	$VBoxContainer/WorkButton.connect("pressed", self, "goto_minigame")
	$VBoxContainer/UpgradesButton.connect("pressed", self, "goto_upgrades")

func goto_minigame():
	return
	get_tree().change_scene("res://minigames/PaperMinigame/PaperMinigame.tscn")

func goto_upgrades():
	get_tree().change_scene(upgrade_shop_path)

func _update_resource_panel():
	$VBoxContainer/ResourcePanel/HBoxContainer/Label.text = str(GameData.resources["glass"])
	$VBoxContainer/WastePanel/HBoxContainer/Label.text = "%s / minute" % str(GameData.factory_output["glass_waste"])
