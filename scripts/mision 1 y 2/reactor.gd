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

# Variables Simon Dice
var rng = RandomNumberGenerator.new()
var sequence: PackedInt32Array = []
var player_pos: int = 0
var input_enabled: bool = false
var indicator_positions: Array = []
var buttons: Array = []
var score: int = 0
var juego_terminado: bool = false  

# Variables escenas
var puertas_inst
var loading = false
var scene = Resources.puerta

# Banco de preguntas
var preguntas = [
	{"enunciado": "Si estás usando RAID 5, ¿cuántos discos duros (mínimo) se necesitan para implementar la paridad distribuida y la tolerancia a fallos??", "respuesta": 3},
	{"enunciado": "¿Cuál es el número máximo de octetos (conjuntos de dígitos separados por puntos) que compone una dirección IPv4 estándar?", "respuesta": 4},
	{"enunciado": "La regla 3-2-1 exige que las copias de respaldo se guarden en un mínimo de ¿cuántos tipos diferentes de medios de almacenamiento?", "respuesta": 2},
	{"enunciado": "Un firewall de Tercera Generación opera en ¿cuántas de las siete capas del modelo OSI?", "respuesta": 3},
	{"enunciado": "Según la regla de respaldo 3-2-1, ¿cuántas copias totales de tus datos (incluyendo el original) debes mantener?", "respuesta": 3},
	{"enunciado": "¿La Autenticación de Múltiples Factores (MFA) requiere que se combinen un mínimo de ¿cuántos factores de seguridad (ej. saber, tener, ser)?", "respuesta": 2},
	{"enunciado": "Para restaurar datos usando un respaldo diferencial, ¿cuántos archivos de respaldo necesitarás como máximo (sin contar el original) para la restauración completa (el último completo y el último diferencial)?", "respuesta": 2}
]
var pregunta_actual = 0
var rondas_a_jugar = 0
var rondas_jugadas = 0
var preguntas_correctas = 0

func _ready():
	rng.randomize()
	_build_grid()
	_compute_indicator_positions()
	reset_game()
	score = 0
	_update_score_label()

	# Inicializar barra
	progress_bar.min_value = 0
	progress_bar.max_value = 1
	progress_bar.value = 0

	submit_button.pressed.connect(Callable(self, "_check_answer"))
	indicator.visible = false
	question_label.visible = false
	answer_input.visible = false
	submit_button.visible = false
	respuesta_label.visible = false
	
	mostrar_pregunta()

# ----------------------------------------------------------
#                        PREGUNTAS
# ----------------------------------------------------------

func mostrar_pregunta():
	if pregunta_actual >= preguntas.size():
		siguientenivel()
		return

	var preg = preguntas[pregunta_actual]
	enunciado.text = preg["enunciado"]

	rondas_a_jugar = preg["respuesta"]
	rondas_jugadas = 0

	# Reiniciar barra de progreso ANTES DE COMENZAR
	progress_bar.value = 0
	progress_bar.max_value = rondas_a_jugar

	score = 0
	_update_score_label()

	reset_game()
	call_deferred("_iniciar_ronda_simon")

func _iniciar_ronda_simon():
	if rondas_jugadas >= rondas_a_jugar:
		# Ya jugó N rondas → pedir respuesta
		question_label.visible = true
		answer_input.visible = true
		submit_button.visible = true
		respuesta_label.visible = true
		answer_input.text = ""
		answer_input.grab_focus()
		return

	start_round()

func _check_answer():
	var preg = preguntas[pregunta_actual]
	var answer = answer_input.text.strip_edges().to_int()

	if answer == preg["respuesta"]:
		question_label.text = "¡Correcto bro!"
		preguntas_correctas += 1
	else:
		question_label.text = "Incorrecto bro."

	await get_tree().create_timer(1.0).timeout
	pregunta_actual += 1

	if preguntas_correctas >= 3:
		siguientenivel()
	else:
		question_label.visible = false
		answer_input.visible = false
		submit_button.visible = false
		respuesta_label.visible = false
		mostrar_pregunta()

# ----------------------------------------------------------
#                  SIMON DICE (FUNCIONAL)
# ----------------------------------------------------------

func reset_game():
	sequence.clear()
	player_pos = 0
	generate_new_sequence(start_length)

func generate_new_sequence(length:int):
	for i in range(length):
		sequence.append(rng.randi_range(0, buttons.size()-1))

func start_round():
	input_enabled = false
	player_pos = 0
	await get_tree().create_timer(pause_before_show).timeout
	await _play_sequence()
	input_enabled = true

func _play_sequence():
	for idx in sequence:
		await _flash_tile(idx)
		await get_tree().create_timer(time_between_steps - flash_time).timeout

func _flash_tile(index):
	var btn = buttons[index]
	var orig_color = btn.modulate
	btn.modulate = Color(1,1,1)
	await get_tree().create_timer(flash_time).timeout
	btn.modulate = orig_color

func _on_tile_pressed(index:int):
	if not input_enabled:
		return

	await _play_local_flash(index)

	if index == sequence[player_pos]:
		player_pos += 1

		if player_pos >= sequence.size():
			_on_round_success()
	else:
		_on_round_fail()

func _play_local_flash(index):
	var btn = buttons[index]
	var orig_color = btn.modulate
	btn.modulate = Color(1, 0.2, 0.2)
	await get_tree().create_timer(0.2).timeout
	btn.modulate = orig_color

func _on_round_success():
	rondas_jugadas += 1
	progress_bar.value = rondas_jugadas

	# aumentar dificultad
	sequence.append(rng.randi_range(0, buttons.size() - 1))

	# Animación
	for i in range(3):
		indicator.visible = not indicator.visible
		await get_tree().create_timer(0.2).timeout
	indicator.visible = false
	await get_tree().create_timer(0.6).timeout

	call_deferred("_iniciar_ronda_simon")

func _on_round_fail():
	# error visual
	for b in buttons:
		b.modulate = Color(1, 0.5, 0.5)
	await get_tree().create_timer(0.6).timeout
	for b in buttons:
		b.modulate = Color(0.8, 0.8, 0.8)

	# Reset solo de rondas
	rondas_jugadas = 0
	progress_bar.value = 0

	# Reset patrón
	sequence.clear()
	for i in range(start_length):
		sequence.append(rng.randi_range(0, buttons.size() - 1))

	player_pos = 0
	input_enabled = false

	await get_tree().create_timer(0.4).timeout
	call_deferred("_iniciar_ronda_simon")

# ----------------------------------------------------------
#                         UI
# ----------------------------------------------------------

func _update_score_label():
	score_label.text = "Aciertos: " + str(score)

# ----------------------------------------------------------
#               GRID DE BOTONES E INDICADOR
# ----------------------------------------------------------

func _build_grid():
	grid.columns = cols
	buttons.clear()
	var total_tiles = cols * rows

	for i in range(total_tiles):
		var btn = Button.new()
		btn.text = ""
		btn.modulate = Color(0.4, 0.6, 1)
		btn.custom_minimum_size = Vector2(70, 70)
		btn.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_FILL
		btn.size_flags_vertical = Control.SIZE_EXPAND | Control.SIZE_FILL
		btn.connect("pressed", Callable(self, "_on_tile_pressed").bind(i))
		grid.add_child(btn)
		buttons.append(btn)

func _compute_indicator_positions():
	indicator_positions.clear()
	var tile_size = Vector2(70, 70)
	var spacing = 10

	for r in range(rows):
		for c in range(cols):
			var pos = Vector2(
				c * (tile_size.x + spacing),
				r * (tile_size.y + spacing)
			)
			indicator_positions.append(pos)

# ----------------------------------------------------------
#                    CAMBIO DE ESCENA
# ----------------------------------------------------------

func siguientenivel():
	if loading:
		return
	loading = true
	cambiar_escena_asincrona(scene)

func cambiar_escena_asincrona(new_scene):
	puertas_inst = Resources.cargando.instantiate()
	add_child(puertas_inst)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_packed(new_scene)

func salioDelJuego():
	get_tree().quit()
