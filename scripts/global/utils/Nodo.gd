class_name Nodo

var scene : String
var izq : Nodo
var der : Nodo
var i
var fe = 0
var icon

func actualizar(ascene, id: int, iconpath):
	self.scene = ascene
	izq = null
	der = null
	self.i = id
	self.icon = iconpath
	self.fe = 1
	print("Nodo creado: ", self.i)
