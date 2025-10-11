extends Control

@onready var users = LoadResources.loadUsers()
@onready var question = LoadResources.loadQuestions()
var arbol : Arbol
var scene = []
var random = RandomNumberGenerator.new()
var iconpath = []
#@onready var sceneWin = preload("")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("salir"):
		ocultar()
	
func generarEscena() -> int :
	var value = random.randi_range(0,scene.size()-1)
	return value

func _dibujarNodo(nodo : Nodo, izq: Nodo, der: Nodo):
	var new_nodo = NodoGraft.new()
	$GraphEdit.add_child(new_nodo)
	new_nodo.actualizar(nodo, null)
	new_nodo._irA.connect(irA)
	if (izq != null) and (der != null):
		var new_nodoIzq = NodoGraft.new()
		$GraphEdit.add_child(new_nodoIzq)
		new_nodoIzq.actualizar(izq, der)
		new_nodoIzq._irA.connect(irA)
		var new_nodoDer = NodoGraft.new()
		$GraphEdit.add_child(new_nodoDer)
		new_nodoDer.actualizar(der, izq)
		new_nodoDer._irA.connect(irA)
	
func irA (nodo : Nodo, nodoHer : Nodo):
	if not nodo.isVisited:
		self.ocultar()
		nodo.mostrar()
		nodoHer.is_VisitedRec(null, null)

func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false

func iniciarJuego() -> void:
	arbol = Arbol.new()
	scene.append(preload("res://scenes/mision 5/control_inir.tscn"))
	scene.append(preload("res://scenes/mision 4/control.tscn"))
	#scene.append(preload(""))
	#scene.append(preload(""))
	#scene.append(preload(""))	
	iconpath.append("res://assests/img/Prewiev2.jpg")
	iconpath.append("res://assests/img/Prewiev1.jpg")
	for x in random.randi_range(0, 15):
		var value = generarEscena()
		arbol.insertar(scene[value], iconpath[value])
	var lejano = arbol.nodo_mas_lejano_mejorado()
	#if lejano != null:
		#lejano.scene = sceneWin
		#print("nodo lejano Central Seguro establecido")
	arbol._graficarNodo.connect(_dibujarNodo)
	
