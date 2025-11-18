extends Node2D

@onready var camera: Camera2D = $Camera2D 

var drag_activo: bool = false
var posicion_mouse_inicial: Vector2 = Vector2.ZERO
var zoom_min: Vector2 = Vector2(0.3, 0.3) 
var zoom_max: Vector2 = Vector2(3.0, 3.0) 
var zoom_velocidad: float = 0.1 

var raiz = Resources.arbol.raiz
var loading := false
var puertas_init
var scape = 0
func _ready() -> void:	
	if camera:
		camera.make_current()
		camera.position = Vector2(get_viewport_rect().size.x / 2, 50)
		camera.zoom = Vector2(1.0, 1.0)
	queue_redraw()  # Fuerza a redibujar la escena
		
func _draw():
	if raiz:
		# Dibuja el árbol empezando desde la raíz
		dibujar_nodo(raiz, Vector2(get_viewport_rect().size.x / 2, 50))  # Posición inicial: centro horizontal, arriba vertical

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		nivelPuertas()
	if event.is_action_pressed("salir"):
		scape += 1
	if event.is_action_pressed("salir") and scape == 1:
		nivelPuertas()
	if event.is_action_pressed("salir") and scape == 2:
		salioDelJuego()
		
func dibujar_nodo(nodo: Nodo, posicion: Vector2, nivel: int = 0):
	var nivelTx = "Nivel " + str(nivel)
	# Dibuja el nodo como un círculo con el valor dentro
	if GlobalState.nodoAnterior.has(nodo) or GlobalState.nodoActual == nodo or Resources.CentralSeguro == nodo:
		draw_circle(posicion, 50, Color(0.9, 0.9, 1.0))  # Círculo claro (azul claro para fondo)
		draw_circle(posicion, 48, Color(0.2, 0.2, 0.8))  # Borde azul oscuro
		if Resources.CentralSeguro == nodo:
			nivelTx = "Nodo Central seguro"
		draw_string(load("res://assets/fonts/VCR_OSD_MONO_1.001.ttf"), posicion,  nivelTx,0,-1,16,Color(1, 1, 1))  # Texto blanco para el valor
	var level_spacing = 80  # Espaciado vertical entre niveles (ajústalo según necesites)
	var sibling_spacing	= 500
	if nodo != Resources.arbol.raiz:
		sibling_spacing = 500 / (nivel * 2 / 2)
	if nodo.izq:
		# Posición del hijo izquierdo: abajo del padre y a la izquierda
		var pos_hijo_izq = Vector2(posicion.x - sibling_spacing, posicion.y + level_spacing)
		if GlobalState.nodoAnterior.has(nodo) or GlobalState.nodoActual.izq == nodo or Resources.CentralSeguro == nodo:
			draw_line(posicion, pos_hijo_izq, Color(0.2, 0.2, 0.8), 2)  # Línea azul gruesa al hijo izquierdo
		dibujar_nodo(nodo.izq, pos_hijo_izq, nivel + 1)
	
	if nodo.der:
		# Posición del hijo derecho: abajo del padre y a la derecha
		var pos_hijo_der = Vector2(posicion.x + sibling_spacing, posicion.y + level_spacing)
		if GlobalState.nodoAnterior.has(nodo) or GlobalState.nodoActual.der == nodo or Resources.CentralSeguro == nodo:
			draw_line(posicion, pos_hijo_der, Color(0.2, 0.2, 0.8), 2)  # Línea azul gruesa al hijo derecho
		dibujar_nodo(nodo.der, pos_hijo_der, nivel + 1)
			
func nivelPuertas():
	if ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(puertas_init)
		print("Escena cargada y cambiada exitosamente")
	pass
	
func salioDelJuego():
	get_tree().change_scene_to_file("res://scenes/inicio/menuinicio.tscn")

func _unhandled_input(event):
	if not camera:
		return
	
	# Zoom con rueda del mouse
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			# Zoom in
			var nuevo_zoom = camera.zoom - Vector2(zoom_velocidad, zoom_velocidad)
			camera.zoom = nuevo_zoom.clamp(zoom_min, zoom_max)
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			# Zoom out
			var nuevo_zoom = camera.zoom + Vector2(zoom_velocidad, zoom_velocidad)
			camera.zoom = nuevo_zoom.clamp(zoom_min, zoom_max)
		
		# Pan con clic izquierdo + drag
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_activo = true
				posicion_mouse_inicial = get_global_mouse_position()
			else:
				drag_activo = false
	
	# Drag para pan (mueve cámara opuesto al mouse)
	elif event is InputEventMouseMotion and drag_activo:
		var posicion_mouse_actual = get_global_mouse_position()
		var delta_mouse = posicion_mouse_actual - posicion_mouse_inicial
		camera.position -= delta_mouse  # Mueve cámara en dirección opuesta al drag
		posicion_mouse_inicial = posicion_mouse_actual
