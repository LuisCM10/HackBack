extends Control


@export var cols:int = 3
@export var rows:int = 3
@export var start_length:int = 3
@export var time_between_steps:float = 0.6
@export var flash_time:float = 0.35
@export var pause_before_show:float = 0.8

# Nodos principales
@onready var enunciado: Label = $Enunciado
@onready var score_label: Label = $acierto
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var sequence_display: Control = $SequenceDisplay
@onready var indicator: ColorRect = $SequenceDisplay/Indicator
@onready var grid: GridContainer = $ButtonsGrid

# Nodos para la pregunta
@onready var question_label: Label = $Question
@onready var respuesta_label: Label = $respuesta
@onready var answer_input: LineEdit = $AnswerInput
@onready var submit_button: TextureButton = $SubmitButton

var rng = RandomNumberGenerator.new()
var sequence: PackedInt32Array = []
var player_pos: int = 0
var input_enabled: bool = false
var indicator_positions: Array = []
var buttons: Array = []
var score: int = 0
var juego_terminado: bool = false  

var puertas_inst
var loading = false
var scene = Resources.puerta
func _ready():
	rng.randomize()
	_build_grid()
	_compute_indicator_positions()
	reset_game()
	score = 0
	_update_score_label()
	progress_bar.min_value = 0
	progress_bar.max_value = 3
	progress_bar.value = 0
	submit_button.pressed.connect(Callable(self, "_check_answer"))
	call_deferred("start_round")
	indicator.visible = false
	question_label.visible = false
	answer_input.visible = false
	submit_button.visible = false
	respuesta_label.visible = false
	if GlobalState.get_nodoActual().izq == null and GlobalState.get_nodoActual().der == null:
		scene = Resources.hoja
	cambiar_escena_asincrona()

func _process(delta: float) -> void:
	if loading:
		_loading()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()


func _build_grid():
	grid.columns = cols
	buttons.clear()
	for child in grid.get_children():
		child.queue_free()
	for i in range(rows * cols):
		var b = Button.new()
		b.text = ""
		b.name = "Tile_%d" % i
		b.focus_mode = Control.FOCUS_NONE
		b.custom_minimum_size = Vector2(70,70)
		b.modulate = Color(0.8, 0.8, 0.8)
		b.connect("pressed", Callable(self, "_on_tile_pressed").bind(i))
		grid.add_child(b)
		buttons.append(b)

# -------------------
func _compute_indicator_positions():
	indicator_positions.clear()
	var w = sequence_display.size.x
	var h = sequence_display.size.y
	for r in range(rows):
		for c in range(cols):
			var nx = (c + 0.5) / cols
			var ny = (r + 0.5) / rows
			var pos = Vector2(nx * w, ny * h)
			indicator_positions.append(pos - indicator.size * 0.5)

func reset_game():
	sequence.clear()
	player_pos = 0
	input_enabled = false

# -------------------
# Lógica principal
func start_round():
	if juego_terminado:
		return
	input_enabled = false
	if sequence.is_empty():
		for i in range(start_length):
			sequence.append(rng.randi_range(0, rows*cols - 1))
	else:
		sequence.append(rng.randi_range(0, rows*cols - 1))
	await get_tree().create_timer(pause_before_show).timeout
	await _play_sequence()
	player_pos = 0
	input_enabled = true

func _play_sequence():
	for idx in sequence:
		await _flash_tile(idx)
		await get_tree().create_timer(time_between_steps - flash_time).timeout

func _flash_tile(idx:int):
	var b = buttons[idx]
	var original_color = b.modulate
	b.modulate = Color(0.0, 0.0, 0.0, 1.0)
	if idx < indicator_positions.size():
		indicator.visible = true
		indicator.position = indicator_positions[idx]
	await get_tree().create_timer(flash_time).timeout
	b.modulate = original_color
	indicator.visible = false

func _on_tile_pressed(idx:int):
	if not input_enabled or juego_terminado:
		return
	var expected = sequence[player_pos]
	if idx == expected:
		player_pos += 1
		await _play_local_flash(idx)
		if player_pos >= sequence.size():
			input_enabled = false
			await _on_round_success()
	else:
		input_enabled = false
		await _on_round_fail()

func _play_local_flash(idx:int):
	var b = buttons[idx]
	var original = b.modulate
	b.modulate = Color(0.6, 1.0, 0.6)
	await get_tree().create_timer(0.2).timeout
	b.modulate = original

# -------------------
# Rondas completadas
func _on_round_success():
	score += 1
	_update_score_label()
	_update_progress_bar()

	# Al llegar a 3 aciertos, termina la secuencia
	if score >= 3:
		input_enabled = false
		juego_terminado = true
		question_label.visible = true
		respuesta_label.visible = true
		answer_input.visible = true
		submit_button.visible = true
		answer_input.text = ""
		answer_input.grab_focus()
		return

	# Parpadeo indicador normal
	for i in range(3):
		indicator.visible = not indicator.visible
		await get_tree().create_timer(0.2).timeout
	indicator.visible = false
	await get_tree().create_timer(0.6).timeout
	start_round()

func _on_round_fail():
	score = 0
	_update_score_label()
	_update_progress_bar()
	for b in buttons:
		b.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.6).timeout
	for b in buttons:
		b.modulate = Color(0.8, 0.8, 0.8)
	reset_game()
	await get_tree().create_timer(0.4).timeout
	start_round()

# -------------------
# UI actualizaciones
func _update_score_label():
	score_label.text = "Aciertos 
					   										%d" % score

func _update_progress_bar():
	progress_bar.value = score
	var tween = create_tween()
	tween.tween_property(progress_bar, "modulate", Color(1, 1, 1.3), 0.15)
	tween.tween_property(progress_bar, "modulate", Color(1, 1, 1), 0.15)
	if score == 3:
		progress_bar.add_theme_color_override("fill_color", Color(0.0, 1.0, 0.4))


# -------------------
# Verificación de la respuesta final
func _check_answer():
	var answer = answer_input.text.strip_edges()
	if answer == "3":
		question_label.text = "¡Es correcto, lo lograste!"
		await get_tree().create_timer(1.0).timeout
		siguientenivel()
	else:
		question_label.text = "Incorrecto. Intenta de nuevo."
		return

# -------------------
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		_compute_indicator_positions()

func _on_submit_button_pressed() -> void:
	pass

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
