class_name QuestionPanel extends Panel

var question: Question

var puertas_inst
var loading = false
var scene = Resources.puerta

func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$lose.visible = false
	aplicarQuestion()
	if GlobalState.get_nodoActual().izq == null and GlobalState.get_nodoActual().der == null:
		scene = Resources.hoja
	cambiar_escena_asincrona()
	
func _process(delta: float) -> void:
	if loading:
		_loading()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()
		
func aplicarQuestion ():
	self.question = Resources.chooseQuestion()
	$pregunta.set_text(question.textQ)
	$opcion1.set_text(question.options[0])
	$opcion2.set_text(question.options[1])

func _on_salir_pressed() -> void:
	salioDelJuego()
	pass # Replace with function body.


func _on_opcion_1_pressed() -> void:
	if question.answerReview(0):		
		await get_tree().create_timer(1.0).timeout
		siguientenivel()
	else:
		volverJugar()

func _on_opcion_2_pressed() -> void:
	if question.answerReview(1):		
		await get_tree().create_timer(1.0).timeout
		siguientenivel()
	else:
		volverJugar()

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

func volverJugar():
	$AnimatedSprite2D.play("dead")
	aplicarQuestion()
	$lose.visible = true
	$AnimatedSprite2D.play("default")
		
func salioDelJuego():
	get_tree().change_scene_to_file("res://scenes/inicio/menuinicio.tscn")
