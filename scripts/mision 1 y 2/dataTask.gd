extends Control

@onready var personaje = $Panel/AnimatedSprite2D
@onready var btn_upload = $Panel/btn_upload
@onready var progress_bar = $Panel/progress_bar
@onready var status = $Panel/status

# Botones
@onready var btn_correcta = $Panel/btn_correcta
@onready var btn_incorrecta = $Panel/btn_incorrecta

# Labels dentro de cada botón
@onready var LabelOp1 = $Panel/btn_correcta/Op1
@onready var LabelOp2 = $Panel/btn_incorrecta/Op2
@onready var label_pregunta = $Panel/Pregunta

var uploading := false
var progress := 0.0
var speed := 8.8

var velocidad_personaje := 25
var distancia_max := 500
var corriendo := false

var puertas_inst
var loading = false
var scene = Resources.puerta

# -----------------------------
# SISTEMA DE PREGUNTAS
# -----------------------------
var preguntas = [
	{"texto": "¿Cuál es la principal herramienta en un ataque de phishing?", "correcta": "El enlace malicioso", "incorrecta": "El logo de la empresa"},
	{"texto": "¿El proceso de hashing de una contraseña es reversible?", "correcta": "No", "incorrecta": "Sí"},
	{"texto": "¿La falta de sanitización de datos web, ¿lleva a Inyección SQL o Sustitución de IP?", "correcta": "Inyección SQL", "incorrecta": "Sustitución de IP"},
	{"texto": "¿El ataque smishing se realiza por SMS o por Voz (VOIP)?", "correcta": "SMS", "incorrecta": "Voz (VOIP)"},
	{"texto": "¿La métrica RPO se relaciona con la pérdida de datos o el tiempo de recuperación?", "correcta": "Pérdida de datos", "incorrecta": "Tiempo de recuperación"},
	{"texto": "¿Dejar un puerto SSH abierto es un riesgo de Exposición o un riesgo de Malware?", "correcta": "Exposición", "incorrecta": "Malware"},
	{"texto": "¿La MFA combina factores como algo que sabes y algo que tienes, o solo dos cosas que sabes?", "correcta": "Algo que sabes y algo que tienes", "incorrecta": "Solo dos cosas que sabes"},
	{"texto": "¿Un respaldo incremental copia todos los archivos, o solo los archivos nuevos o cambiados?", "correcta": "Archivos nuevos o cambiados", "incorrecta": "Todos los archivos"},
	{"texto": "¿Cuál es el paso crucial para garantizar la restauración: probar los respaldos o cifrar los respaldos?", "correcta": "Probar los respaldos", "incorrecta": "Cifrar los respaldos"},
	{"texto": "¿Cuántas copias totales de datos requiere la regla 3-2-1?", "correcta": "Tres", "incorrecta": "Dos"}
]

var respuestas_correctas := 0
var necesarias := 3
var boton_correcto := 0
var pregunta_actual


# -----------------------------
func _ready():
	personaje.animation = "quieto"
	personaje.play()

	progress_bar.value = 0
	progress_bar.visible = false
	status.visible = true
	btn_upload.visible = false

	nueva_pregunta()

	if GlobalState.get_nodoActual().izq == null and GlobalState.get_nodoActual().der == null:
		scene = Resources.hoja

	cambiar_escena_asincrona()


# ----------------------------------------------------------
# NUEVA PREGUNTA - SOLO EN label_pregunta
# ----------------------------------------------------------
func nueva_pregunta():
	pregunta_actual = preguntas.pick_random()

	# 🔥🔥🔥 Se muestra SOLO en el label de la pregunta
	label_pregunta.text = pregunta_actual["texto"]

	var respuestas = [
		{"texto": pregunta_actual["correcta"], "correct": true},
		{"texto": pregunta_actual["incorrecta"], "correct": false}
	]

	respuestas.shuffle()

	# LABELS de los botones
	LabelOp1.text = respuestas[0]["texto"]
	LabelOp2.text = respuestas[1]["texto"]

	# Guardar botón correcto
	boton_correcto = 0 if respuestas[0]["correct"] else 1


# ----------------------------------------------------------
# BOTONES
# ----------------------------------------------------------
func _on_btn_correcta_pressed():
	if boton_correcto == 0:
		_respuesta_correcta()
	else:
		_respuesta_incorrecta()

func _on_btn_incorrecta_pressed():
	if boton_correcto == 1:
		_respuesta_correcta()
	else:
		_respuesta_incorrecta()


# ----------------------------------------------------------
# RESPUESTA CORRECTA
# ----------------------------------------------------------
func _respuesta_correcta():
	respuestas_correctas += 1
	btn_correcta.disabled = true
	btn_incorrecta.disabled = true

	if respuestas_correctas >= necesarias:
		status.text = "Correcto!! Ya puedes subir los archivos."
		btn_upload.visible = true
		progress_bar.visible = true
	else:
		var faltan = necesarias - respuestas_correctas
		status.text = "Correcto! Te faltan %s respuestas." % faltan
		await get_tree().create_timer(1.2).timeout
		nueva_pregunta()

	btn_correcta.disabled = false
	btn_incorrecta.disabled = false


# ----------------------------------------------------------
# RESPUESTA INCORRECTA
# ----------------------------------------------------------
func _respuesta_incorrecta():
	var faltan = necesarias - respuestas_correctas
	status.text = "Incorrecto :( Te faltan %s respuestas correctas." % faltan

	await get_tree().create_timer(1.2).timeout
	nueva_pregunta()


# ----------------------------------------------------------
# PROCESO DE SUBIDA
# ----------------------------------------------------------
func _process(delta):
	if loading:
		_loading()

	if uploading:
		progress += speed * delta
		progress_bar.value = progress
		status.text = "Transferiendo archivos..."

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
			status.text = "Tarea completada con éxito!"
			btn_upload.visible = false

			personaje.animation = "quieto"
			personaje.play()
			corriendo = false

			await get_tree().create_timer(1.0).timeout
			siguientenivel()


func _on_btn_upload_pressed():
	btn_upload.visible = false
	uploading = true
	progress = 0
	progress_bar.value = 0
	status.text = "Cargando..."


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()


# ------------------ CARGA DE ESCENAS -----------------------
func cambiar_escena_asincrona():
	if not loading:
		loading = true
		ResourceLoader.load_threaded_request(scene)

func _loading():
	var status = ResourceLoader.load_threaded_get_status(scene)
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
		ResourceLoader.THREAD_LOAD_LOADED:
			var recurso = ResourceLoader.load_threaded_get(scene)
			if recurso is PackedScene:
				puertas_inst = recurso
			loading = false
		ResourceLoader.THREAD_LOAD_FAILED:
			loading = false

func siguientenivel():
	if ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(puertas_inst)


func salioDelJuego():
	var scene_Inicio = preload("res://scenes/inicio/menuinicio.tscn")
	get_tree().change_scene_to_packed(scene_Inicio)
