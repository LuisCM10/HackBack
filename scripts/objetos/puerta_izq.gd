extends Area2D

@onready var interactable: Area2D = $Interactable
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	anim.animation = "abrir"
	anim.stop()
	anim.frame = 0
	anim.sprite_frames.set_animation_loop("abrir", false) 
	interactable.interact = _on_interact
	anim.animation_finished.connect(_on_animation_finished)

func _on_interact():
	if anim.frame == 0: # Solo si no se ha abierto		
		print("El jugador escogió la puerta izquierda")
		anim.play("abrir")
		await get_tree().create_timer(1.0).timeout
		if GlobalState.get_nodoActual().izq:
			GlobalState.set_nodoActual(GlobalState.get_nodoActual().izq)
			get_tree().change_scene_to_file(GlobalState.Loader)
		else:			
			get_tree().change_scene_to_file("res://scenes/escena_hoja.tscn")

func _on_animation_finished():
	anim.stop()
	anim.frame = 11
	interactable.is_interactable = false
