extends Resource
class_name TextData

## Valores necessários para cada texto usado nos espaços do grid }
@export_range(1, 5, 1.0, "prefer_slider") var text_num: int # }
@export var censored_sprite: Texture2D # } 
@export var clean_sprite: Texture2D # }

var is_censored: bool = true

## Atríbui um valor que deve ser mostrado atualmente, por exemplo, se é para mostrar a frase
## censurada ou não
var current_sprite: Texture2D

## Faz a troca do sprite que deve aparecer nos espaços do grid com este item }
func _set_current_sprite(sprite_num: int): # }
	match sprite_num: # } 
		1: # }
			current_sprite = censored_sprite # }
		2: # }
			current_sprite = clean_sprite # }
			is_censored = false
		_: # }
			current_sprite = null # }
	#ResourceSaver.save(self, resource_path)
	#ResourceLoader.load(resource_path)
