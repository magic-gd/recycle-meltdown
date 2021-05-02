extends Node

var score_file = "user://recycle_game_score.save"

func save():
	var save_dict = {}
	save_dict["resources"] = GameData.resources.duplicate(true)
	save_dict["factory_output"] = GameData.factory_output.duplicate(true)
	save_dict["upgrades"] = GameData.upgrades.duplicate(true)
	save_dict["state"] = GameData.state.duplicate(true)
	var file = File.new()
	var file_err = file.open(score_file, File.WRITE)
	if file_err != 0: return
	file.store_var(save_dict, true)
	file.close()

func load_save():
	var file = File.new()
	if file.file_exists(score_file):
		var file_err = file.open(score_file, File.READ)
		if file_err != 0: return
		var loaded_data = file.get_var(true)
		file.close()
		
		GameData.resources = loaded_data["resources"]
		GameData.factory_output = loaded_data["factory_output"]
		GameData.upgrades = loaded_data["upgrades"]
		GameData.state = loaded_data["state"]
