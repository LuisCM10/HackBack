extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable
@onready var mapa = preload("res://scenes/global/map.tscn")
var encendido := false
func _ready():
	anim.animation = "prender"
	anim.stop()
	anim.frame = 0
	anim.sprite_frames.set_animation_loop("prender", false)

	interactable.interact = _on_interact
	interactable.is_interactable = true
			
func _on_interact():		
	if not encendido:
		print("mostrando mapa")
		encendido = true
		anim.frame = 1	
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_packed(mapa)
		
	else:
		print("ocultando mapa")
		encendido = false
		anim.stop()
		anim.frame = 0
