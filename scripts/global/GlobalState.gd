extends Node
 
var nodoActual: Nodo = null
var nodoAnterior: Array[Nodo] = []
const Loader = "res://scenes/global/Loader.tscn"
var player__position

func set_nodoActual(nodo : Nodo):
	nodoAnterior.append(nodo)
	nodoActual = nodo
	
func volverAnterior():
	nodoAnterior.push_front(nodoActual)
	nodoActual = nodoAnterior.pop_back()
	
func get_nodoActual() -> Nodo:
	return nodoActual
