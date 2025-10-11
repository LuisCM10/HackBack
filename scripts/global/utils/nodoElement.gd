class_name NodoGraft extends GraphElement

var nodo: Nodo
var nodoHermano : Nodo
signal _irA(nodo: Nodo)


func actualizar(nodop: Nodo, nodoHerm: Nodo) -> void:
	self.nodo = nodop
	self.nodoHermano = nodoHerm
	$Button.icon = Image.load_from_file(nodo.icon)


func _on_button_pressed() -> void:
	_irA.emit(nodo, nodoHermano)
	pass # Replace with function body.
