extends Node
class_name Item
## Script para configurarmos os itens que forem criados

## Pra colocar um tipo para o item, default sendo 'leek'
@export var item_type:= "leek"
var object_held:= false

## Sinal para comunicar com outros scripts
signal item_collected_signal(i_type: Item)

# Roda no início do jogo
func _ready() -> void:
	item_collected_signal.connect(_item_collected_func) # Conecta o sinal 'item_collected' com a função 'item_collected'

# Roda a cada tick do jogo
func _process(delta: float) -> void:
	pass

## Função para mudar o cursor com o sinal do sprite de quando o mouse entra
func _change_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.interact_mouse_icon)
	
## Função para resetar o cursor com o sinal do sprite de quando o mouse sai
func _reset_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.default_mouse_icon)
	
## Função para mudar o ícone para segurando enquanto o jogador estiver segurando enquanto está com o mouse no item
func object_is_held(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact_with_items"):
		Input.set_custom_mouse_cursor(CursorManager.grabbing_mouse_icon)
		object_held = true
	if event.is_action_released("interact_with_items") and object_held:
		item_collected_signal.emit(self)
		object_held = false

func _item_collected_func(i: Item) -> void:
	queue_free() # Destrói o item
	_reset_cursor()
