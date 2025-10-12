extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable: Area2D = $Interactable

var encendido := false
var map_init = GlobalState.mapa

func _ready():
	get_tree().current_scene.add_child(map_init)
	map_init.ocultar()
	anim.animation = "prender"
	anim.stop()
	anim.frame = 0
	anim.sprite_frames.set_animation_loop("prender", false)

	interactable.interact = _on_interact
	interactable.is_interactable = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()
	if event.is_action_pressed("map"):
		if map_init.visible:
			map_init.ocultar()
		else:
			map_init.mostrar()
func _on_interact():
	if not encendido:
		encendido = true
		anim.frame = 1
		map_init.mostrar()
	else:
		encendido = false
		anim.stop()
		anim.frame = 0

func salioDelJuego():
	var scene_Inicio = preload("res://scenes/inicio/menuinicio.tscn")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_packed(scene_Inicio)
