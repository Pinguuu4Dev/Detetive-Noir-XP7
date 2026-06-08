extends Node
class_name Cursor_Manager
## Script para poder guardar os cursores que vão ser usados no jogo dependendo do que o mouse está fazendo

const PATA = preload("res://Assets/Placeholder/Cursors/default.png")
const PATAHOVER = preload("res://Assets/Placeholder/Cursors/hover.png")
const PATACLICK = preload("res://Assets/Placeholder/Cursors/click.png")

## Configurações necessárias do mouse para visualização bonita do notebook puzzle
func _ready() -> void:
	Input.set_custom_mouse_cursor(PATA, Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_FORBIDDEN)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_CAN_DROP)
	Input.set_custom_mouse_cursor(PATACLICK, Input.CURSOR_DRAG)

@export_category("Tipos de Cursores")
## Ícone padrão do mouse
@export var default_icon:= preload("res://Assets/Placeholder/Cursors/default.png") 
## Ícone para indicar que é possível interagir com um item
@export var hover_icon:= preload("res://Assets/Placeholder/Cursors/hover.png") 
## Ícone de segurando item
@export var grab_icon:= preload("res://Assets/Placeholder/Cursors/click.png")
