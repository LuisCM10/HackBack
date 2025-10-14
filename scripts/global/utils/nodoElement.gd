class_name NodoVisual extends Node2D

var clave: int
var nodo_avl: Nodo

func _init(nodo: Nodo, pos: Vector2):
	position = pos
	clave = Resources.arbol.nivel_nodo(nodo)
	nodo_avl = nodo
	
	var label = Label.new()
	label.text = "Nivel " + str(clave)
	label.position = Vector2(-30, -20)  # Centrado
	label.add_theme_font_size_override("font_size", 16)
	add_child(label)

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Clic en nivel: ", clave)
