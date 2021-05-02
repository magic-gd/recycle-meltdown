extends Node

signal resource_change
signal data_change

var resources = {
	"dollars": 10000,
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
}

var factory_output = {
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
	"paper_waste": 0,
	"plastic_waste": 0,
	"glass_waste": 0,
	"metal_waste": 0,
}

var upgrades = []

var waste_spawn_table = {
	"paper": 10.0,
	"plastic": 10.0,
	"glass": 8.0,
	"metal": 5.0,
	"organic": 0.5,
}

var state = {}

func change_resource(type, amount):
	if not resources.has(type): return
	resources[type] += amount
	emit_signal("resource_change")
