extends Control

var current_line = 0

var text_lines = [
	"Hi! I'm Caleb!",
	"Look I'll be honest with you. I can't focus on my trash empire right now. I need to find my waifu.",
	"If you make 10000$ using our trash factories, I'll make you CEO!",
	"To turn trash to dough you have to sort it first",
	"Once the sorting is taken care of, use the factories to turn trash into valuable raw materials.",
	"I gotta go. Good luck!",
]

onready var text_label = $TextPanel/Label


func _ready():
	_connect()
	text_label.text = text_lines[0]
	

func _connect():
	$NextButton.connect("pressed", self, "next")

func next():
	current_line += 1
	if current_line >= text_lines.size():
		SaveManager.save()
		queue_free()
		return
	text_label.text = text_lines[current_line]
	
