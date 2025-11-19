extends Node2D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()

func salioDelJuego():
	get_tree().change_scene_to_file("res://scenes/inicio/menuinicio.tscn")
