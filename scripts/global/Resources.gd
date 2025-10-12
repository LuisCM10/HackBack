
extends Node

var questions: Array[Question]
var users: Array[User]
const misionScenes = ["res://scenes/EscenaMision1Computador.tscn" ,
 				"res://scenes/cuarto_misión_2.tscn",
 				"res://scenes/escena_mision_3.tscn",
 				"res://scenes/escena_mision_4.tscn",
 				"res://scenes/escena_mision_5.tscn"]
const iconPath = ["res://assets/img/mapPreview/Prewiev1.jpg",
				"res://assets/img/mapPreview/Prewiev2.jpg",
				"res://assets/img/mapPreview/Preview3.png",
				"res://assets/img/mapPreview/Preview4.png",
				"res://assets/img/mapPreview/Preview5.png"]
const sceneWin = "res://scenes/escena_final.tscn"
const sceneQuit = ""
const puerta := "res://scenes/escena_puertas.tscn"
const hoja := "res://scenes/escena_hoja.tscn"
var ultQuestion = 1
var arbol : Arbol
var random = RandomNumberGenerator.new()
var CentralSeguro : Nodo

func loadQuestions ():
	if !questions.is_empty():
		return questions
	var fileQuestion = FileAccess.open("res://assets/data/questions.json", FileAccess.READ)
	if fileQuestion == null:
		print("Error: No se pudo abrir el archivo: questions.json")
		return questions
	var contenido = fileQuestion.get_as_text()
	fileQuestion.close()    
	var json_parser = JSON.new()
	var resultado_parseo = json_parser.parse(contenido)    
	if resultado_parseo != OK:
		print("Error al parsear JSON: " + json_parser.get_error_message())
		return questions
	var datos = json_parser.data
	if datos is Array:
		for dato in datos:
			questions.append(Question.new(dato["text"],dato["options"][0],dato["options"][1],dato["answer"]))		
		return questions
	elif datos is Dictionary:
		for dato in datos.values():
			questions.append(Question.new(dato["text"],dato["options"][0],dato["options"][1],dato["answer"]))
		return questions
	return questions

func loadUsers ():
	if !users.is_empty():
		return users
	var file = FileAccess.open("res://assets/data/users.json", FileAccess.READ)
	if file == null:
		print("Error: No se pudo abrir el archivo: questions.json")
		return users
	var contenido = file.get_as_text()
	file.close()    
	var json_parser = JSON.new()
	var resultado_parseo = json_parser.parse(contenido)    
	if resultado_parseo != OK:
		print("Error al parsear JSON: " + json_parser.get_error_message())
		return users
	var datos = json_parser.data
	if datos is Array:
		for dato in datos:
			users.append(User.new(dato["icon"], dato["name"], dato["rol"], dato["permisos"], dato["permisosReales"]))
		return users
	elif datos is Dictionary:
		for dato in datos.values():
			users.append(User.new(dato["icon"], dato["name"], dato["rol"], dato["permisos"], dato["permisosReales"]))
		return users
	return users

func chooseQuestion() -> Question:
	var antvalue = ultQuestion
	while (antvalue == ultQuestion):
		ultQuestion = random.randi_range(0,questions.size()-1)
	return questions[ultQuestion]
	
func chooseUsers() -> Array[User]:
	var users_usados : Array[User] = []
	for x in range(5):
		var user = users[random.randi_range(0,users.size()-1)]
		var value
		while users_usados.has(user):
			value = random.randi_range(0,users.size()-1)			
			user = users[value]	
			print(user)
		users_usados.append(user)
	return users_usados

func generarEscena() -> int :
	var value = random.randi_range(0,misionScenes.size()-1)
	return value
	
func iniciarJuego() -> void:
	arbol = Arbol.new()	
	loadQuestions()
	loadUsers()
	for x in random.randi_range(8, 15):
		var value = generarEscena()
		arbol.insertar(misionScenes[value], iconPath[value])	
	CentralSeguro = arbol.nCentralSeguro
	CentralSeguro.scene = sceneWin
