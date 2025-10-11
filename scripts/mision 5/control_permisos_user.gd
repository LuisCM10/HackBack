extends Control


var random = RandomNumberGenerator.new()
var users_usados: Array[User] = []
var scene = preload("res://scenes/mision 5/UserPermiso.tscn")
var scene_inst : Array
var temp : int = 0

func _ready() -> void:
	for x in range(5):
		scene_inst.append(scene.instantiate()) 
		$Panel/ScrollContainer/VBoxContainer.add_child(scene_inst[x])
	$error.visible = false
	
func _process(delta: float) -> void:
	if statusWin():
		get_tree().quit()
	

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

func mostrar_usuarios(users : Array) -> void:
	for x in range(5):
		var user = users[random.randi_range(0,users.size()-1)]
		var value
		while users_usados.has(user):
			value = random.randi_range(0,users.size()-1)			
			user = users[value]	
			print(user)
		users_usados.append(user)
		scene_inst[x].actualizar_info(user)
		
	
func mostrar() -> void :
	self.visible = true
	for x in range(5):
		scene_inst[x].mostrar_panel()

func ocultar() -> void:
	self.visible = false

func _on_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func statusWin() -> bool:
	for x in range(5):
		if scene_inst[x].visible:
			return false
	return true
