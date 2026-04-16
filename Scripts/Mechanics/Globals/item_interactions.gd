extends Node

var nb_interactions= 0
var t_interactions= 0
var d_interactions= 0

func _get_interactions(i: String) -> int:
	match i:
		"notebook":
			return nb_interactions
		"trash":
			return t_interactions
		"metal_door":
			return d_interactions
		_:
			return 0
			
func _add_interactions(i: String) -> void:
	match i:
		"notebook":
			nb_interactions += 1
		"trash":
			t_interactions += 1
		"metal_door":
			d_interactions += 1
