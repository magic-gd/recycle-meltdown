extends Control

func _ready():
	_connect()

func _connect():
	$Panel/BackButton.connect("pressed", self, "_exit")

func set_reason(reason : String):
	$Panel/ReasonLabel.text = reason
	
func set_paper(paper_amount : int):
	$Panel/PaperScoreLabel.text = str(paper_amount)

func _exit():
	get_tree().change_scene("res://screens/main/MainScreen.tscn")
