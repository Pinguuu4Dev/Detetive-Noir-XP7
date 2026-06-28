## Salva informações que devem ser salvas e carregadas dos diferentes nós num só lugar.
extends Node

var timelines_finished: Array
## Estados de todos os puzzles do jogo. Não guarda se eles foram completos, 
## no caso do caderno guarda apenas a posição de cada texto.
var puzzles_states: Dictionary

## Retorna todas as informações do GameState num dicionário.
func to_dict() -> Dictionary:
	return {
		"timelines_finished": timelines_finished,
		"puzzles_states": puzzles_states
	}

## Restaura todos os valores a partir do save que foi carregado.
func from_dict(data: Dictionary) -> void:
	timelines_finished.clear()
	
	timelines_finished = data.get("timelines_finished")
	puzzles_states = data.get("puzzles_states")
