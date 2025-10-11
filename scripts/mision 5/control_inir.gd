extends Control

@onready var users = LoadResources.loadUsers()
@onready var scene = preload("res://scenes/mision 5/control_permisos_user.tscn")
var scene_ini

func _ready() -> void:
	scene_ini = scene.instantiate()
	add_child(scene_ini)
	scene_ini.ocultar()
	
func _on_button_pressed() -> void:
	scene_ini.mostrar_usuarios(users)
	scene_ini.mostrar()
	pass # Replace with function body.
