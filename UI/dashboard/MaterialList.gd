extends Control

onready var paper_waste_label = $HBoxContainer/WasteMaterials/PaperWastePanel/Label
onready var plastic_waste_label = $HBoxContainer/WasteMaterials/PlasticWastePanel/Label
onready var glass_waste_label = $HBoxContainer/WasteMaterials/GlassWastePanel/Label
onready var metal_waste_label = $HBoxContainer/WasteMaterials/MetalWastePanel/Label
onready var paper_label = $HBoxContainer/Materials/PaperPanel/Label
onready var plastic_label =  $HBoxContainer/Materials/PlasticPanel/Label
onready var glass_label = $HBoxContainer/Materials/GlassPanel/Label
onready var metal_label = $HBoxContainer/Materials/MetalPanel/Label

export var show_materials = true
export var show_waste = true

func _ready():
	refresh()
	_connect()
	
	$HBoxContainer/WasteMaterials.visible = show_waste
	$HBoxContainer/Materials.visible = show_materials

func _connect():
	GameData.connect("resource_change", self, "refresh")

func refresh():
	paper_label.text = "Paper: %s" % GameData.resources["paper"]
	plastic_label.text = "Plastic: %s" % GameData.resources["plastic"]
	glass_label.text = "Glass: %s" % GameData.resources["glass"]
	metal_label.text = "Metal: %s" % GameData.resources["metal"]
	paper_waste_label.text = "Paper Waste:\n %s / hour" % GameData.factory_output["paper_waste"]
	plastic_waste_label.text = "Plastic Waste:\n %s / hour" % GameData.factory_output["plastic_waste"]
	glass_waste_label.text = "Glass Waste:\n %s / hour" % GameData.factory_output["glass_waste"]
	metal_waste_label.text = "Metal Waste:\n %s / hour" % GameData.factory_output["metal_waste"]
