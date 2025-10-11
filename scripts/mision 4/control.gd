extends Control

@onready var question = LoadResources.loadQuestions()
var value : int
@onready var scene = preload("res://scenes/mision 4/Question.tscn")
var scene_inst


	
func _ready() -> void:
	scene_inst = scene.instantiate()
	get_tree().current_scene.add_child(scene_inst)
	scene_inst.ocultar_panel()
	
func _on_button_pressed() -> void:
	mostrar_pregunta()	
	pass # Replace with function body.

func mostrar_pregunta() -> void:
	var random = RandomNumberGenerator.new()
	value = random.randi_range(0,question.size()-1)
	scene_inst.actualizar_info(question[value])
	scene_inst.mostrar_panel()
	
func actualizar() -> void:
	var antvalue = value
	var random = RandomNumberGenerator.new()
	value+= 1
	while (antvalue == value):
		value = random.randi_range(0,question.size()-1)
	scene_inst.actualizar_info(question[value])
