## Se comunica com GameState para salvar e carregar o arquivo de save.
extends Node

## Emitido quando o jogo salva com sucesso;
signal game_saved()
## Emitido quando o jogo carrega com sucesso
signal game_loaded()

const SAVE_DIR: String = "user://saves/"
const FILE_PATH: String = SAVE_DIR+"save.save"

const SAVE_TEMPLATE_PATH := "res://Scripts/save_template.txt"
var save_template: String

func _ready() -> void:
	# Cria o diretório caso não exista
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

## Cria o arquivo de save caso não exista um
func initialize_save_file() -> void:
	save_template = FileAccess.get_file_as_string(SAVE_TEMPLATE_PATH)
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(save_template)
	file.close()

func save() -> void:
	var data: Dictionary = GameState.to_dict()
	var json_string: String = save_template
	
	# fazer dessa forma mantém o Array numa linha só e o arquivo fica na ordem que você quiser
	json_string = json_string.replace("{{TIMELINES}}", JSON.stringify(data.get("timelines_finished")))
	json_string = json_string.replace("{{PUZZLE_ID_&_STATE}}", JSON.stringify(data.get("puzzles_states")))
	
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	
func load_save() -> void:
	var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	
	if !FileAccess.file_exists(FILE_PATH):
		initialize_save_file()
		return
	
	var json_string: String = file.get_as_text()
	var data: Dictionary = JSON.parse_string(json_string) # Se não for dicionário pode dar erro dps
	
	GameState.from_dict(data)
