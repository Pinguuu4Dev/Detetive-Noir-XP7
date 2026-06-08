extends TextureButton
class_name Item
## Script para configurarmos os itens que forem criados
#@onready var col_area:= $collision_area
#@onready var shader_outline: ShaderMaterial = self.material # será removido
## Pra colocar um tipo para o item, default sendo 'leek'
@export_category("Parâmetros de Interação")
@export var item_type: String
@export var scene_ref: Node2D
@export var delete_after_interaction:= true
@export var open_after_interaction:= false
@export var notebook: Notebook
#@export var hovered_texture: Texture2D # será removido

var object_held:= false

func _ready() -> void:
	#col_area.connect("mouse_entered", _change_cursor)
	mouse_entered.connect(_change_cursor)
	
	#col_area.connect("mouse_exited", _reset_cursor)
	mouse_exited.connect(_reset_cursor)
	
	#col_area.connect("input_event", _object_is_held)
	pressed.connect(_on_pressed)
	button_up.connect(_on_button_up)
	
	if item_type == "notebook":
		TimelineManager.n_interaction_ref = self
		
## Função para mudar o cursor com o sinal do sprite de quando o mouse entra
func _change_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.hover_icon)
	
## Função para resetar o cursor com o sinal do sprite de quando o mouse sai
func _reset_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.default_icon)
	
func _on_pressed() -> void:
	if scene_ref:
		scene_ref._on_item_interacted(self)
		Input.set_custom_mouse_cursor(CursorManager.grab_icon)
		object_held = true
	
func _on_button_up() -> void:
	if !object_held:
		return
	
	object_held = false
	if open_after_interaction and PuzzleManager.puzzle_started:
		for i in scene_ref.interactable_items.get_children():
			if i != notebook:
				i.visible = false
			else:
				i._open_notebook()
	if delete_after_interaction:
		queue_free() # Destrói o item
	_reset_cursor()
