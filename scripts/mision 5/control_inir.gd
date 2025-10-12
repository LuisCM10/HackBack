extends Control

@onready var users = Map.users
@onready var scene = preload("res://scenes/mision 5/control_permisos_user.tscn")
var scene_ini

@onready var nodo : Nodo = GlobalState.get_nodoActual()
var loading = false
var rutaEscenaPuerta := ""
var puertas_inst

func _ready() -> void:
	scene_ini = scene.instantiate()
	add_child(scene_ini)
	scene_ini.ocultar()
	if nodo.izq != null or nodo.der != null:
		rutaEscenaPuerta = Map.puerta		
	else:
		rutaEscenaPuerta = Map.hoja
	

		
	if Input.is_action_just_pressed("map"):
		Map.mostrar()
	else:
		Map.ocultar()
		
func _on_button_pressed() -> void:
	scene_ini.mostrar_usuarios(users)
	scene_ini.mostrar()
	pass # Replace with function body.
