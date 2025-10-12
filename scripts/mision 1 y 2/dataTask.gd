extends Control

@onready var personaje = $Panel/AnimatedSprite2D
@onready var btn_upload = $Panel/btn_upload
@onready var progress_bar = $Panel/progress_bar
@onready var status = $Panel/status
@onready var btn_correcta = $Panel/HBoxContainer/btn_correcta
@onready var btn_incorrecta = $Panel/HBoxContainer/btn_incorrecta


var uploading := false
var progress := 0.0
var speed := 8.8

var velocidad_personaje := 25
var distancia_max := 500
var corriendo := false

var puertas_inst
var loading = false

func _ready():
	personaje.animation = "quieto"
	personaje.play()
	# ProgressBar y botones
	progress_bar.value = 0
	progress_bar.visible = false
	status.visible = false
	btn_upload.visible = false
	cambiar_escena_asincrona()

func _on_btn_correcta_pressed():
	btn_correcta.disabled = true
	btn_incorrecta.disabled = true
	status.visible = true
	status.text = "      la respuesta es correcta!!"
	await get_tree().create_timer(1.0).timeout
	status.text = "        Listo para subir datos!!"
	btn_upload.visible = true
	progress_bar.visible = true
	progress_bar.value = 0


func _on_btn_incorrecta_pressed():
	status.visible = true
	status.text = "Respuesta incorrecta. Intenta otra vez."


func _process(delta):
	if loading:
		_loading()
	if uploading:
		# Actualizar barra de progreso
		progress += speed * delta
		progress_bar.value = progress
		status.text = "        Transferiendo archivos..."

		if personaje.position.x < distancia_max:
			if not corriendo:
				
				personaje.animation = "caminar"
				personaje.play()
				corriendo = true
		else:
			if corriendo:
				
				personaje.animation = "quieto"
				personaje.play()
				corriendo = false

		
		if corriendo:
			personaje.position.x += velocidad_personaje * delta

		
		if progress >= 100:
			uploading = false
			progress_bar.value = 100
			status.text = "      Tarea completada con éxito."
			btn_upload.visible = false
			# Volver a quieto
			if personaje.animation != "quieto":
				personaje.animation = "quieto"
				personaje.play()
			corriendo = false
			await get_tree().create_timer(1.0).timeout
			siguientenivel()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()

func _on_btn_upload_pressed():
	btn_upload.visible = false
	uploading = true
	progress = 0
	progress_bar.value = 0
	status.text = "Uploading..."

func cambiar_escena_asincrona():
	if not loading:
		loading = true
		ResourceLoader.load_threaded_request(Resources.puerta)
		print("Iniciando carga asíncrona de: ", Resources.puerta)
		
func _loading():
	var status = ResourceLoader.load_threaded_get_status(Resources.puerta)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			var progress = []
			var porcentaje = ResourceLoader.load_threaded_get_status(Resources.puerta, progress)
			print("Progreso: ", porcentaje * 100, "%")

		ResourceLoader.THREAD_LOAD_LOADED:
			var recurso = ResourceLoader.load_threaded_get(Resources.puerta)
			if recurso is PackedScene:
				puertas_inst = recurso
			else:
				print("Error: El recurso no es una PackedScene")
			loading = false

		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error al cargar la escena: ", Resources.puerta)
			loading = false
			
func siguientenivel():
	if ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(puertas_inst)
		print("Escena cargada y cambiada exitosamente")
	pass
	
func salioDelJuego():
	var scene_Inicio = preload("res://scenes/inicio/menuinicio.tscn")
	get_tree().change_scene_to_file(scene_Inicio)
