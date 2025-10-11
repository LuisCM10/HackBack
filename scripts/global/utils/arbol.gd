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
	elif i > nodo.i:
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
		print("Árbol vacío: No hay nodos.")
		return null
	
	var nodo_lejano: Nodo = null
	var max_profundidad: int = -1
	
	_encontrar_nodo_lejano_rec(raiz, 0, max_profundidad, nodo_lejano)
	
	if nodo_lejano != null:
		print("Nodo más lejano: ", nodo_lejano ," a profundidad ", max_profundidad)
	else:
		print("No se encontró nodo lejano.")
	
	return nodo_lejano

# Función recursiva auxiliar
func _encontrar_nodo_lejano_rec(nodo: Nodo, profundidad_actual: int, max_profundidad: int, nodo_lejano: Nodo) -> void:
	if nodo == null:
		return
	
	# Actualiza si esta profundidad es mayor
	if profundidad_actual > max_profundidad:
		max_profundidad = profundidad_actual
		nodo_lejano = nodo
	
	# Recursión en hijos (izquierda primero, luego derecha; el orden no afecta el resultado)
	_encontrar_nodo_lejano_rec(nodo.izq, profundidad_actual + 1, max_profundidad, nodo_lejano)
	_encontrar_nodo_lejano_rec(nodo.der, profundidad_actual + 1, max_profundidad, nodo_lejano)
