extends Control



var users_usados: Array[User] = []
var scene = preload("res://scenes/mision 5/UserPermiso.tscn")
var scene_inst : Array

var puertas_inst
var loading = false

func _ready() -> void:
	for x in range(5):
		scene_inst.append(scene.instantiate()) 
		$Panel/ScrollContainer/VBoxContainer.add_child(scene_inst[x])
	$error.visible = false
	usuarios()
	cambiar_escena_asincrona()
	
func _process(delta: float) -> void:
	if loading:
		_loading()
	if statusWin():
		await get_tree().create_timer(1.0).timeout
		siguientenivel()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("salir"):
		salioDelJuego()
		
func _on_button_verificar_pressed() -> void:
	var i: int = 0
	if users_usados == null or users_usados.is_empty():
		push_error("users_usados es null o vacío - no hay usuarios para verificar")
		return
	
	if scene_inst == null or scene_inst.is_empty():
		push_error("scene_inst es null o vacío - no hay panels para ocultar")
		return
	if users_usados.size() != scene_inst.size():
		push_error("Mismatch de tamaños: users_usados (" + str(users_usados.size()) + ") vs scene_inst (" + str(scene_inst.size()) + ")")
		return    
	for x in users_usados:
		if x == null or not (x is User):  # Chequeo de tipo/null
			push_error("Usuario inválido en índice " + str(i))
			i += 1
			continue
		if not x.correctPermisos():
			if not $error.visible:
				$error.visible = true
			print("Equivocación en empleado: ", x.name) 
		else:
			if i < scene_inst.size() and scene_inst[i] != null:
				scene_inst[i].ocultar_panel()
				print("Correcto para empleado: ", x.name, " - Panel ocultado")
			else:
				push_error("Panel inválido en índice " + str(i) + " para usuario " + str(x.name))
		i += 1

func usuarios() -> void:
	users_usados = Resources.chooseUsers()
	for x in range(5):		
		scene_inst[x].actualizar_info(users_usados[x])

func _on_button_pressed() -> void:
	salioDelJuego()
	pass # Replace with function body.

func statusWin() -> bool:
	for x in range(5):
		if scene_inst[x].visible:
			return false
	return true

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
