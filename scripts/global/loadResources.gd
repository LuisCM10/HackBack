
extends Node

var questions: Array[Question]
var users: Array[User]

func loadQuestions () -> Array[Question]:
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

func loadUsers () -> Array[User]:
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
