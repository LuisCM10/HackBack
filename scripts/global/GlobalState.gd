extends Node
 
var nodoActual: Nodo = null
var nodoAnterior: Array[Nodo] = []
const Loader = "res://scenes/global/Loader.tscn"
var mapa

func set_nodoActual(nodo : Nodo):
	nodoAnterior.append(nodo)
	nodoActual = nodo
	
func volverAnterior():
	nodoActual = nodoAnterior.pop_back()
	
func get_nodoActual() -> Nodo:
	return nodoActual

func iniciarMapa(scene):
	mapa = scene
