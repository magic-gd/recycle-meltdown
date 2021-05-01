tool
extends Control

export var resource_type = "dollars" setget set_resource_type

func set_resource_type(type):
	resource_type = type
	match resource_type:
		"dollars": $HBoxContainer/Icon.texture = preload("res://assets/temp/dollar.png")
		"paper": $HBoxContainer/Icon.texture = preload("res://assets/temp/paper_icon.png")
		"plastic": $HBoxContainer/Icon.texture = preload("res://assets/temp/plastic_icon.png")
		"glass": $HBoxContainer/Icon.texture = preload("res://assets/temp/glass_icon.png")
		"metal": $HBoxContainer/Icon.texture = preload("res://assets/temp/metal_icon.png")
	refresh()

func _ready():
	_connect()
	refresh()

func _connect():
	GameData.connect("resource_change", self, "refresh")

func refresh():
	if not resource_type in GameData.resources: return
	$HBoxContainer/Label.text = str(GameData.resources[resource_type])
