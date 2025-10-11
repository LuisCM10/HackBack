class_name Nodo extends Node

var scene
var izq : Nodo
var der : Nodo
var isVisited
signal _isVisited(nodo : Nodo, izq: Nodo, der: Nodo)
var i
var fe = 0
var icon
#@onready var puertas = preload("")
var puertas_init

func _ready() -> void:
	#puertas_init = puertas.instantiate()
	#get_tree().add_child(puertas_init)
	#puertas_init.ocultar()
	pass
	
func actualizar(scene, i: int, iconpath):
	self.scene = scene
	izq = null
	der = null
	isVisited = false
	self.i = i
	self.icon = iconpath
	self.fe = 1
	print("Nodo creado: ", i)

func is_VisitedRec(izqN, derN):
	isVisited = not isVisited
	_isVisited.emit(self, izqN, derN)

func setIzq(nodo : Nodo):
	izq = nodo
	puertas_init.actualizarPuertaIzq(nodo)

func setDer(nodo : Nodo):
	der = nodo
	puertas_init.actualizarPuertaDer(nodo)
	
func nivelSuperado(nodo : Nodo):
	is_VisitedRec(self.izq, self.der)
	puertas_init.mostrar()
