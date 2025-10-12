class_name NodoGraft extends GraphNode

var nodo: Nodo


func actualizar(nodop: Nodo, nodoHerm: Nodo) -> void:
	self.nodo = nodop
	$TextureButton.texture_normal = Image.load_from_file(nodo.icon)
	self.title = str("Nivel ",Resources.arbol.nivel_nodo(nodo, Resources.arbol.raiz))

# Replace with function body.


func _on_texture_button_pressed() -> void:
	$TextureButton.StretchMode = 3
	pass # Replace with function body.
