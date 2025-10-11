class_name Arbol

var raiz: Nodo
var random = RandomNumberGenerator.new()
signal _graficarNodo(nodo : Nodo, izq, der)


func altura_nodo(nodo: Nodo) -> int:
	if nodo == null:
		return 0
	return nodo.fe

func altura(point: Nodo) -> int:
	if point == null:
		return 0
	return 1 + max(altura(point.izq), altura(point.der))

func fe(nodo: Nodo) -> int:
	if nodo == null:
		return 0
	return altura_nodo(nodo.izq) - altura_nodo(nodo.der)

func rotar_der(y: Nodo) -> Nodo:
	var x: Nodo = y.izq
	var temp: Nodo = x.der
	x.der = y
	y.izq = temp

	y.fe = max(altura_nodo(y.izq), altura_nodo(y.der)) + 1
	x.fe = max(altura_nodo(x.izq), altura_nodo(x.der)) + 1

	return x

func rotar_izq(y: Nodo) -> Nodo:
	var x: Nodo = y.der
	var temp: Nodo = x.izq
	x.izq = y
	y.der = temp

	y.fe = max(altura_nodo(y.izq), altura_nodo(y.der)) + 1
	x.fe = max(altura_nodo(x.izq), altura_nodo(x.der)) + 1

	return x

func insertar(scene, iconpath):
	var i = random.randi_range(1,50)
	raiz = insertar_rec(scene, raiz, i, iconpath)
	

func insertar_rec(scene, nodo: Nodo, i : int, iconpath) -> Nodo:
	if nodo == null:		
		var nuevo : Nodo = Nodo.new()
		nuevo.actualizar(scene, i, iconpath)
		nuevo._isVisited.connect(_Nodo_visitado)		
		return nuevo

	if i < nodo.i:
		nodo.izq = insertar_rec(scene, nodo.izq, i, iconpath)
	elif i >= nodo.i:
		nodo.der = insertar_rec(scene, nodo.der, i, iconpath)
	else:
		return nodo
	
	nodo.fe = max(altura(nodo.izq), altura(nodo.der)) + 1

	var balance: int = fe(nodo)

	var a: int = nodo.der.i if nodo.der != null else 0
	var b: int = nodo.izq.i if nodo.izq != null else 0

	if balance > 1 and i < b:
		print("Rotacion derecha")
		return rotar_der(nodo)

	if balance < -1 and i > a:
		print("Rotacion izquierda")
		return rotar_izq(nodo)

	if balance > 1 and i > b:
		print("Rotacion Doble izquierda")
		nodo.izq = rotar_izq(nodo.izq)
		return rotar_der(nodo)

	if balance < -1 and i < a:
		print("Rotacion Doble derecha")
		nodo.der = rotar_der(nodo.der)
		return rotar_izq(nodo)
	
	return nodo

func _Nodo_visitado(nodo : Nodo, izq, der) -> void:
	_graficarNodo.emit(nodo, izq, der)
	print("Señal emitida class Arbol")

# Función principal: Encuentra el nodo más lejano desde la raíz
func nodo_mas_lejano() -> Nodo:
	if raiz == null:
		return null
	
	var cola: Array = []  # Cola de [nodo, profundidad]
	cola.append([raiz, 0])
	
	var nodo_lejano: Nodo = null
	var max_prof: int = -1
	
	while not cola.is_empty():
		var actual = cola.pop_front()  # FIFO
		var nodo_actual: Nodo = actual[0]
		var prof_actual: int = actual[1]
		
		if prof_actual > max_prof:
			max_prof = prof_actual
			nodo_lejano = nodo_actual
			print("Nuevo lejano en BFS: ", nodo_actual.i, " prof: ", prof_actual)
		
		# Agrega hijos a la cola
		if nodo_actual.izq != null:
			cola.append([nodo_actual.izq, prof_actual + 1])
		if nodo_actual.der != null:
			cola.append([nodo_actual.der, prof_actual + 1])
	
	return nodo_lejano
