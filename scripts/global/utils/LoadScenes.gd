extends Control  # O Node, para tu loading screen

# Variables para el loading
var nodo : Nodo = GlobalState.get_nodoActual()
var nivel = Resources.arbol.nivel_nodo(nodo)
var escena_path: String  # Ruta a la escena a cargar
var icon_path: String
var loading: bool = false
var progress_array: Array = []  # Array para recibir progreso de ResourceLoader

@onready var progress_bar: ProgressBar = $ProgressBar  # Referencia al nodo ProgressBar
@onready var label: Label = $Label  #Label para texto

func _ready():
	# Configura la ProgressBar inicialmente 
	progress_bar.value = 0.0
	if label:
		label.text = "Cargando... 0%"
	
	visible = true	
	cambiar_escena_asincrona()

# Función para iniciar el cambio de escena
func cambiar_escena_asincrona():
	if not loading:
		loading = true
		progress_bar.value = 0.0
		if Resources.CentralSeguro == nodo:
			$Preview.visible = false
			$nivel.text = str("Nodo Central Seguro")
			escena_path = Resources.sceneWin
		elif nodo != null:
			$nivel.text = str("Nivel ", nivel)
			icon_path = GlobalState.iconScenes.get(nivel)
			$Preview.texture = load(icon_path)		
			escena_path = GlobalState.scenasNivel.get(nivel)
			
		else:
			$Preview.visible = false
			$nivel.text = str("Nodo Comprometido Hoja")
		
		ResourceLoader.load_threaded_request(escena_path)
		print("Iniciando carga asíncrona de: ", escena_path)
	
	
# Pollea el estado en cada frame
func _process(delta):
	if loading:
		var status = ResourceLoader.load_threaded_get_status(escena_path, progress_array)
		
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if progress_array.size() > 0:
					var progreso = progress_array[0]  
					var porcentaje = progreso * 100.0  
					
					# Actualiza la barra
					progress_bar.value = porcentaje
					
					if label:
						label.text = "Cargando... " + str(int(porcentaje)) + "%"
					
					print("Progreso: ", int(porcentaje), "%")
				
			ResourceLoader.THREAD_LOAD_LOADED:
				# Carga completa: Obtén la escena y cambia
				var recurso = ResourceLoader.load_threaded_get(escena_path)
				if recurso is PackedScene:
					if label:
						label.text = "¡Carga completa!"
					
					await get_tree().create_timer(0.75).timeout
					# Cambia la escena
					get_tree().change_scene_to_packed(recurso)
					
					print("Escena cargada y cambiada exitosamente")
				else:
					print("Error: El recurso no es una PackedScene")
				
				# Limpia: Detén loading y oculta UI si es necesario
				loading = false
				progress_bar.value = 100.0  # Asegura 100%
				# Opcional: queue_free() este loading screen si es una escena separada
				
			ResourceLoader.THREAD_LOAD_FAILED:
				print("Error al cargar la escena: ", escena_path)
				# Opcional: Muestra error en UI
				if label:
					label.text = "Error en la carga. Reintenta."
				loading = false
				progress_bar.value = 0.0  # Reset en error
