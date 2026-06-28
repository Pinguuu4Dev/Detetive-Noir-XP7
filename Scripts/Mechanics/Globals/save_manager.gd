## Se comunica com GameState para salvar e carregar o arquivo de save.
extends Node

## Emitido quando o jogo salva com sucesso;
signal game_saved()
## Emitido quando o jogo carrega com sucesso
signal game_loaded()

const SAVE_DIR: String = "user://saves/"

func _ready() -> void:
	# Cria o diretório caso não exista
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

func save() -> void:
	var data: Dictionary = GameState.to_dict()
	print(data)
	# Converte o dicionário pra um tipo que JSON aceita.
	# O segundo argumento é 2 espaços para melhor legibilidade do arquivo.
	var json_string: String = JSON.stringify(data, "  ")
	
	var file := FileAccess.open(SAVE_DIR+"save.save", FileAccess.WRITE)
	file.store_string(json_string)
	file.close()

# Dicionários não salvam em ordem, o ideal é ou usar array (se der) ou criar o JSON linha por linha.

#func save() -> void:
	#var json_string: String = "{\n"
	#json_string += '  "timelines_finished": ' + JSON.stringify(GameState.timelines_finished, "  ") + ",\n"
	#json_string += '  "puzzle_states": ' + JSON.stringify(GameState.puzzles_states, "  ") + "\n"
	#json_string += "}"
	#var file := FileAccess.open(SAVE_DIR+"save.save", FileAccess.WRITE)
	#file.store_string(json_string)
	#file.close()
