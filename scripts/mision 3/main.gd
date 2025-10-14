extends Node2D

@export var total_needed: int = 4
var connected_count: int = 0

var puertas_inst
var loading = false
var scene = Resources.puerta
func _ready():
	var left = $LeftPanel
	for cable in left.get_children():
		if cable is Node:
			cable.connect("connected", Callable(self, "_on_cable_connected"))
	if GlobalState.get_nodoActual().izq == null and GlobalState.get_nodoActual().der == null:
		scene = Resources.hoja
	cambiar_escena_asincrona()

func _process(delta: float) -> void:
	if loading:
		_loading()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()

func _on_cable_connected(color_name: String)->void:
	connected_count += 1
	$Label.text = "Conectados: %d / %d" % [connected_count, total_needed]
	if connected_count >= total_needed:
		$Label.text = "Tarea completada"
		await get_tree().create_timer(1.0).timeout
		siguientenivel()

func cambiar_escena_asincrona():
	if not loading:
		loading = true
		ResourceLoader.load_threaded_request(scene)
		print("Iniciando carga asíncrona de: ", scene)
		
func _loading():
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
			else:
				print("Error: El recurso no es una PackedScene")
			loading = false

		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error al cargar la escena: ", scene)
			loading = false
			
func siguientenivel():
	if ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(puertas_inst)
		print("Escena cargada y cambiada exitosamente")
	pass
	
func salioDelJuego():
	var scene_Inicio = preload("res://scenes/inicio/menuinicio.tscn")
	get_tree().change_scene_to_packed(scene_Inicio)
