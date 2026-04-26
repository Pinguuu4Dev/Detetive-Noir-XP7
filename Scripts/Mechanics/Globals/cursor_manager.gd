extends Node
class_name Cursor_Manager
## Script para poder guardar os cursores que vão ser usados no jogo dependendo do que o mouse está fazendo

@export_category("Tipos de Cursores")
## Ícone padrão do mouse
@export var default_icon:= preload("res://Assets/Placeholder/Cursors/default.png") 
## Ícone para indicar que é possível interagir com um item
@export var hover_icon:= preload("res://Assets/Placeholder/Cursors/hover.png") 
## Ícone de segurando item
@export var grab_icon:= preload("res://Assets/Placeholder/Cursors/click.png")
