
extends Control

var arbol : Arbol
var raiz

func _on_iniciarmision_pressed() -> void:
	print("Oprime boton inicio")
	get_tree().current_scene.add_child(Map)
	await Map.iniciarJuego()	
	arbol = Map.arbol
	raiz = arbol.raiz.scene.instantiate()
	get_tree().current_scene.add_child(raiz)
	ocultar()
	raiz.mostrar()
 # Replace with function body.


func _on_salir_pressed() -> void:
	print("Oprime boton salir")
	get_tree().quit()

func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false
