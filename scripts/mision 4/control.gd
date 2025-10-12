extends Control

@onready var questions = Map.questions
var value : int
@onready var scene = preload("res://scenes/mision 4/Question.tscn")
var scene_inst
@onready var nodo = GlobalState.get_nodoActual()
var loading = false
var rutaEscenaPuerta =  ""
var puertas_inst

func _ready() -> void:
	scene_inst = scene.instantiate()
	get_tree().current_scene.add_child(scene_inst)
	scene_inst.ocultar_panel()
	scene_inst._win.connect(siguientenivel)
	scene_inst._quit.connect(salioDelJuego)
	if nodo.izq != null or nodo.der != null:
		rutaEscenaPuerta = Map.puerta		
	else:
		rutaEscenaPuerta = Map.hoja
	cambiar_escena_asincrona(nodo.scene)
	
func _process(delta: float) -> void:
	if loading:
		_loading(rutaEscenaPuerta)
		
	if Input.is_action_just_pressed("map"):
		Map.mostrar()
	else:
		Map.ocultar()
		
func _on_button_pressed() -> void:
	mostrar_pregunta()	
	pass # Replace with function body.

func mostrar_pregunta() -> void:
	var random = RandomNumberGenerator.new()
	value = random.randi_range(0,questions.size()-1)
	scene_inst.actualizar_info(questions[value])
	scene_inst.mostrar_panel()
	

	
func siguientenivel():
	if ResourceLoader.THREAD_LOAD_LOADED:
		#puertas_inst.actualizarPuerta(nodo.izq, nodo.der, nodo)
		get_tree().change_scene_to_packed(puertas_inst)
		print("Escena cargada y cambiada exitosamente")
	pass
	
func salioDelJuego():
	pass

func cambiar_escena_asincrona(scene : String):
	if not loading:
		loading = true
		ResourceLoader.load_threaded_request(scene)
		print("Iniciando carga asíncrona de: ", scene)
		
func _loading(scene):
	var status = ResourceLoader.load_threaded_get_status(scene)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var progress = []
			var porcentaje = ResourceLoader.load_threaded_get_status(scene, progress)
			print("Progreso: ", porcentaje * 100, "%")

		ResourceLoader.THREAD_LOAD_LOADED:
			var recurso = ResourceLoader.load_threaded_get(scene)
			if recurso is PackedScene:
				puertas_inst = recurso
				GlobalState.set_nodoActual(nodo.izq)
			else:
				print("Error: El recurso no es una PackedScene")
			loading = false

		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error al cargar la escena: ", scene)
			loading = false
