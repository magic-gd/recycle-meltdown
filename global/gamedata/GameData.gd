extends Node

signal resource_change
signal data_change

var resources = {
	"paper": 0,
	"plastic": 0,
	"glass": 0,
	"metal": 0,
	"paper_waste": 0,
	"plastic_waste": 0,
	"glass_waste": 0,
	"metal_waste": 0,
}

var data = {
}

func change_resource(type, amount):
	if not resources.has(type): return
	resources[type] += amount
	emit_signal("resource_change")
