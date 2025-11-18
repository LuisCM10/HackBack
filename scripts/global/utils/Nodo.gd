class_name Nodo

var izq : Nodo
var der : Nodo
var i
var fe = 0

func _init(id : int) -> void:
	self.i = id
	izq = null
	der = null
	self.fe = 1
	print("Nodo creado: ", self.i)
	
	
