extends Node
class_name Cursors
## Script para poder guardar os cursores que vão ser usados no jogo dependendo do que o mouse está fazendo

@export_category("Tipos de Cursores")
## Ícone padrão do mouse
@export var default_mouse_icon:= preload("res://Assets/Placeholder/Cursors/cursor_default.png") 
## Ícone para indicar que é possível interagir com um item
@export var interact_mouse_icon:= preload("res://Assets/Placeholder/Cursors/cursor_grab.png") 
## Ícone de segurando item
@export var grabbing_mouse_icon:= preload("res://Assets/Placeholder/Cursors/cursor_grabbing.png")
