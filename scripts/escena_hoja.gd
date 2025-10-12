extends Node2D

@onready var player = $player  

func _ready():
	if player and player.has_node("Camera2D"):   # Verifica que el player y su cámara existan
		var camera = player.get_node("Camera2D")
		camera.zoom = Vector2(4, 4)  # Aumenta el zoom 
