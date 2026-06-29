## Guarda StringName constantes do nome de cada level e seus paths.
class_name SceneID
extends Node

const OFFICE_SCENE: StringName = &"Office"
const ALLEY_SCENE: StringName = &"Alley"

const SCENE_PATHS: Dictionary[StringName, Variant] = {
	OFFICE_SCENE: "res://Scenes/Game Levels/Office_Scene.tscn",
	ALLEY_SCENE: "res://Scenes/Game Levels/Beco_Scene.tscn"
}
