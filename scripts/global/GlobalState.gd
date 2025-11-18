extends Node
 
var nodoActual: Nodo = null
var nodoAnterior: Array[Nodo] = []
var scenasNivel: Array[String]
var iconScenes: Array[String]
const Loader = "res://scenes/global/Loader.tscn"
var player__position

func set_nodoActual(nodo : Nodo):
	nodoAnterior.append(nodoActual)
	nodoActual = nodo
	
func volverAnterior():
	set_nodoActual(nodoAnterior.pop_back())
	
func get_nodoActual() -> Nodo:
	return nodoActual
