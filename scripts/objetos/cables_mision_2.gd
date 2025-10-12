extends Area2D

@onready var interactable: Area2D = $Interactable

@onready var animacionCompu: AnimatedSprite2D = $AnimatedSprite2D
var scene_ini
func _ready() -> void:
	interactable.interact = _on_interact
	scene_ini = preload("res://scenes/mision 2/main_scene.tscn")

func _on_interact():
	if animacionCompu.frame == 0:
		animacionCompu.frame = 1
		interactable.is_interactable = false
		print("El jugador ha empezado una misión")
		await get_tree().create_timer(1.0).timeout		
		get_tree().change_scene_to_packed(scene_ini)
