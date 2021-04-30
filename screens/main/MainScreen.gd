extends Control

const SORTING_PANEL_PATH = "res://UI/panels/SortingFactoryInfoPanel.tscn"

onready var info_panel = $UI/InfoPanel
onready var info_panel_panel = $UI/InfoPanel/Panel # what u lookin at

func _ready():
	get_tree().paused = false
	_connect()
	info_panel.visible = false

func _connect():
	$UI/SortingButton.connect("pressed", self, "_on_sorting_pressed")
	$UI/GlassButton.connect("pressed", self, "goto_factory", ["glass"])
	$UI/PaperButton.connect("pressed", self, "goto_factory", ["paper"])
	$UI/MetalButton.connect("pressed", self, "goto_factory", ["metal"])
	$UI/PlasticButton.connect("pressed", self, "goto_factory", ["plastic"])
	
	$UI/InfoPanel/OutsideInfoPanel.connect("pressed", self, "_hide_info_panel")

func goto_factory(type):
	match type:
		"glass":
			get_tree().change_scene("res://screens/GlassFactoryScreen.tscn")
		"paper":
			pass
		"metal":
			get_tree().change_scene("res://screens/MetalFactoryScreen.tscn")
		"plastic":
			pass

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

func _on_sorting_pressed():
	_show_info_panel(SORTING_PANEL_PATH)
