extends AudioStreamPlayer

func play_music(file: AudioStreamOggVorbis) -> void:
	stream = file
	play()
