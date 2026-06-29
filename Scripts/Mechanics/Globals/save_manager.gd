## Salva e carrega as informaçõe do GameState de um arquivo.
extends Node

signal game_saved()
signal game_loaded()

const SAVE_DIR: String = "user://saves/"
const FILE_PATH: String = SAVE_DIR+"save.save"

const SAVE_TEMPLATE_PATH := "res://Scripts/save_template.txt"
var save_template: String

func _ready() -> void:
	# Cria o diretório caso não exista
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

## Cria o arquivo de save baseado no save_template.
func initialize_save_file() -> void:
	save_template = FileAccess.get_file_as_string(SAVE_TEMPLATE_PATH)
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(save_template)
	file.close()

## Salva as informações do GameState no arquivo de save. Emite o sinal game_saved ao salvar.
func save() -> void:
	var data: Dictionary = GameState.to_dict()
	var json_string: String = save_template
	
	# Fazer dessa forma mantém arrays numa linha só e o arquivo fica na ordem que você quiser
	json_string = json_string.replace("{{CURRENT_SCENE}}", JSON.stringify(data.get("current_scene")))
	json_string = json_string.replace("{{TIMELINES}}", JSON.stringify(data.get("timelines_finished")))
	json_string = json_string.replace("{{PUZZLE_ID_&_STATE}}", JSON.stringify(data.get("puzzles_states")))
	
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
	
	game_saved.emit()

## Atualiza as informações do GameState usando o arquivo de save. Emite o sinal game_loaded ao carregar.
func load_save() -> void:
	var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	
	if !FileAccess.file_exists(FILE_PATH):
		initialize_save_file()
		return
	
	var json_string: String = file.get_as_text()
	var data: Dictionary = JSON.parse_string(json_string)
	
	GameState.from_dict(data)
	
	game_loaded.emit()
