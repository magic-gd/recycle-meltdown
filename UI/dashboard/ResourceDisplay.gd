tool
extends Control

export var resource_type = "dollars" setget set_resource_type

func set_resource_type(type):
	resource_type = type
	match resource_type:
		"dollars": $HBoxContainer/Icon.texture = preload("res://assets/UI/icons/resource icons/dollar_icon.png")
		"paper": $HBoxContainer/Icon.texture = preload("res://assets/UI/icons/resource icons/paper_icon.png")
		"plastic": $HBoxContainer/Icon.texture = preload("res://assets/UI/icons/resource icons/plastic_icon.png")
		"glass": $HBoxContainer/Icon.texture = preload("res://assets/UI/icons/resource icons/glass_icon.png")
		"metal": $HBoxContainer/Icon.texture = preload("res://assets/UI/icons/resource icons/metal_icon.png")
	refresh()

func _ready():
	_connect()
	refresh()

func _connect():
	GameData.connect("resource_change", self, "refresh")

func refresh():
	if not resource_type in GameData.resources: return
	$HBoxContainer/Label.text = str(GameData.resources[resource_type])
