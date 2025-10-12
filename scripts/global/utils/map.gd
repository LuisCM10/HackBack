extends Control

func _ready() -> void:
	if not GlobalState.nodoAnterior.is_empty():
		for x in GlobalState.nodoAnterior:
			_dibujarNodo(x, x.izq, x.der)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("map"):
		ocultar()
	
func _dibujarNodo(nodo : Nodo, izq: Nodo, der: Nodo):
	var new_nodo = NodoGraft.new()
	$Panel/GraphEdit.attach_graph_element_to_frame(new_nodo)
	$Panel/GraphEdit.connect_node()
	new_nodo.actualizar(nodo, null)
	if (izq != null) and (der != null):
		var new_nodoIzq = NodoGraft.new()
		$Panel/GraphEdit.attach_graph_element_to_frame(new_nodoIzq)
		$Panel/GraphEdit.connect_node(new_nodo, new_nodoIzq)
		new_nodoIzq.actualizar(izq, der)
		var new_nodoDer = NodoGraft.new()
		$Panel/GraphEdit.attach_graph_element_to_frame(new_nodoIzq)
		$Panel/GraphEdit.connect_node(new_nodo, new_nodoDer)
		new_nodoDer.actualizar(der, izq)

func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false


	
	
