extends Control

export var sorting_panel_path = "res://UI/panels/SortingFactoryInfoPanel.tscn"
export var paper_panel_path = "res://UI/panels/PaperFactoryInfoPanel.tscn"
export var plastic_panel_path = "res://UI/panels/PlasticFactoryInfoPanel.tscn"
export var glass_panel_path = "res://UI/panels/GlassFactoryInfoPanel.tscn"
export var metal_panel_path = "res://UI/panels/MetalFactoryInfoPanel.tscn"


onready var info_panel = $UI/InfoPanel
onready var info_panel_panel = $UI/InfoPanel/Panel # what u lookin at

func _ready():
	get_tree().paused = false
	_connect()
	info_panel.visible = false
	SaveManager.save()
	_show_intro()

func _connect():
	$UI/SortingButton.connect("pressed", self, "_on_factory_pressed", ["sorting"])
	$UI/GlassButton.connect("pressed", self, "_on_factory_pressed", ["glass"])
	$UI/PaperButton.connect("pressed", self, "_on_factory_pressed", ["paper"])
	$UI/MetalButton.connect("pressed", self, "_on_factory_pressed", ["metal"])
	$UI/PlasticButton.connect("pressed", self, "_on_factory_pressed", ["plastic"])
	
	$UI/InfoPanel/OutsideInfoPanel.connect("pressed", self, "_hide_info_panel")

func _hide_info_panel():
	info_panel.visible = false

func _show_info_panel(panel_path=null):
	if panel_path:
		_clear_info_panel()
		var panel = load(panel_path).instance()
		info_panel_panel.add_child(panel)
	info_panel.visible = true

func _clear_info_panel():
	for child in info_panel_panel.get_children():
		child.queue_free()

func _on_factory_pressed(type):
	match type:
		"sorting": _show_info_panel(sorting_panel_path)
		"paper": _show_info_panel(paper_panel_path)
		"plastic": _show_info_panel(plastic_panel_path)
		"glass": _show_info_panel(glass_panel_path)
		"metal": _show_info_panel(metal_panel_path)

func _show_intro():
	if "intro_done" in GameData.state: return
	GameData.state["intro_done"] = 1
	
	$UI/Intro.visible = true
