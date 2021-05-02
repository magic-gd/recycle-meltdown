extends Control

func _ready():
	_connect()

func _connect():
	$VBoxContainer/NewGameButton.connect("pressed", self, "start_new")
	$VBoxContainer/LoadButton.connect("pressed", self, "load_game")

func start_new():
	SceneManager.goto_main()

func load_game():
	SaveManager.load_save()
	yield(get_tree().create_timer(0.5), "timeout")
	SceneManager.goto_main()
