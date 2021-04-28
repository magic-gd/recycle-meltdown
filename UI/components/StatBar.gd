tool
extends Control

onready var bar = $BarHolder/Bar

export var value = 1000 setget set_value

func set_value(p_value):
	value = p_value
	if bar:
		bar.value = value

func set_max_value(max_value):
	bar.max_value = max_value
