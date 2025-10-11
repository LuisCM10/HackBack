extends Control

var arbol : Arbol
var raiz

func _on_button_pressed() -> void:
	print("Oprime boton inicio")
	get_tree().current_scene.add_child(Map)
	await Map.iniciarJuego()	
	arbol = Map.arbol
	raiz = arbol.raiz.scene.instantiate()
	get_tree().current_scene.add_child(raiz)
	ocultar()
	raiz.mostrar()
	pass # Replace with function body.
	
func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false
