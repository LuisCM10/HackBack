extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()

func salioDelJuego():
	var scene_Inicio = preload("res://scenes/inicio/menuinicio.tscn")
	get_tree().change_scene_to_packed(scene_Inicio)
