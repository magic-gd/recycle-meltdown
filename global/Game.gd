extends Node

#
# Core game loop
#

func _ready():
	_connect()

func _connect():
	$Tick.connect("timeout", self, "tick")

func tick():
	_tick_factories()

func _tick_factories():
	for resource in ["paper", "plastic", "glass", "metal"]:
		GameData.change_resource(resource, GameData.factory_output[resource])
