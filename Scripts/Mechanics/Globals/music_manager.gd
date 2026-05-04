extends AudioStreamPlayer

## Toca um arquivo do tipo Ogg que já foi carregado na memória. Também pode dar um fadeout na 
## música atual e colocar uma nova na fila.
func play_music(file: AudioStreamOggVorbis, fadeout: bool = false, duration: float = 0) -> void:
	if fadeout:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(self, "volume_db", -60, duration)
		await tween.finished
	
	stream = file
	volume_db = 0
	play()
