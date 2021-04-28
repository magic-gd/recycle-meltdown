extends Control

func _ready():
	_connect()

func _connect():
	$Panel/BackButton.connect("pressed", self, "_goto_mainscreen")

func display_score(score_dict: Dictionary):
	$Panel/Results/PaperScoreLabel.text = "Paper: %s" % score_dict["paper"]
	$Panel/Results/PlasticScoreLabel.text = "Plastic: %s" % score_dict["plastic"]
	$Panel/Results/GlassScoreLabel.text = "Glass: %s" % score_dict["glass"]
	$Panel/Results/MetalScoreLabel.text = "Metal: %s" % score_dict["metal"]

func set_reason(reason_string):
	$Panel/ReasonLabel.text = reason_string

func _goto_mainscreen():
	get_tree().paused = false
	get_tree().change_scene("res://screens/main/MainScreen.tscn")
