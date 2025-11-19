extends Node2D

@onready var player = $player  

func _ready():
	if player and player.has_node("Camera2D"):   # Verifica que el player y su cámara existan
		var camera = player.get_node("Camera2D")
		camera.zoom = Vector2(6, 6)  # Aumenta el zoom 

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()

func salioDelJuego():
	get_tree().change_scene_to_file("res://scenes/inicio/menuinicio.tscn")
