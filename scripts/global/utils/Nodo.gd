class_name Nodo

var scene : String
var izq : Nodo
var der : Nodo
var i
var fe = 0
var icon

func actualizar(scene, i: int, iconpath):
	self.scene = scene
	izq = null
	der = null
	self.i = i
	self.icon = iconpath
	self.fe = 1
	print("Nodo creado: ", i)
