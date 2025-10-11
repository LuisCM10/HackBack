class_name User_permiso extends Panel

@onready var http_request: HTTPRequest = $HTTPRequest
var user : User
var scene = preload("res://scenes/mision 5/permiso.tscn")
var scene_inst : Array
var HTTPs

func _ready() -> void:
	for x in range(5):
		scene_inst.append(scene.instantiate())
		$HBoxContainer.add_child(scene_inst[x])

func mostrar_panel():
	self.visible = true
	for x in range(user.permisos.size()):
		scene_inst[x].mostrar_panel()

func actualizar_info(user: User) -> void:
	self.user = user
	cargar_imagen_desde_url(self.user.icon)
	$nombreEmpleado.text = user.name
	$rol.text = user.rol
	for x in range(5):
		var elem = user.permisos.keys()[x]
		scene_inst[x].actualizar_info(user, elem, user.permisosReales[elem])

func ocultar_panel():
	self.visible = false
	for x in range(user.permisos.size()):
		scene_inst[x].ocultar_panel()

func cargar_imagen_desde_url(url: String):
	if url == "":
		return
	if $imagenEmpleado != null:
		$imagenEmpleado.texture = null
	# Crea la request HTTP (GET)
	var error = await http_request.request(url, [], HTTPClient.METHOD_GET)
	if error != OK:
		push_error("Error al iniciar request: " + str(error) + " (código: " + str(error) + ")")
		return
	print("Request enviada a: " + url)


func mostrar_error(mensaje: String):
	print("ERROR en carga de imagen: " + mensaje)
	if $imagenEmpleado != null:
		# Crea un Label temporal para error si no hay imagen
		var label_error = Label.new()
		label_error.text = "Error: " + mensaje
		$imagenEmpleado.add_child(label_error)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	print("Request completada - Result: " + str(result) + ", Código HTTP: " + str(response_code))

	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Fallo en request: " + str(result))
		mostrar_error("Error de red: Verifica conexión o URL")
		return

	if response_code != 200:
		push_error("HTTP no OK: " + str(response_code))
		mostrar_error("Servidor respondió: " + str(response_code))
		return

	# Verifica si es una imagen (chequea headers MIME)
	var content_type = ""
	for header in headers:
		if header.to_lower().begins_with("content-type:"):
			content_type = header.split(":")[1].strip_edges().to_lower()
			break

	if not content_type.begins_with("image/"):
		push_error("No es una imagen: " + content_type)
		mostrar_error("Contenido no es imagen (MIME: " + content_type + ")")
		return
	# Carga los bytes en una Image
	var imagen_cargada = Image.new()
	var load_error = imagen_cargada.load_jpg_from_buffer(body)
	if load_error != OK:
		push_error("Error al cargar imagen desde buffer: " + str(load_error))
		mostrar_error("Formato de imagen no soportado (ej: solo PNG/JPG/WEBP)")
		imagen_cargada = null
		return
	var texture = ImageTexture.new()
	texture.set_image(imagen_cargada)
	# Asigna al TextureRect para mostrar
	if $imagenEmpleado != null:
		$imagenEmpleado.texture = texture
