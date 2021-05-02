extends Node

func play(sound_path):
	$AudioStreamPlayer.stream = load(sound_path)
	$AudioStreamPlayer.volume_db *= GameOptions.sound_volume
	if GameOptions.sound_volume > 0:
		$AudioStreamPlayer.play()
