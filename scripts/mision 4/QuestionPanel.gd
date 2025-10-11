class_name QuestionPanel extends Panel

var question: Question
func _ready() -> void:
	$AnimatedSprite2D.play("default")
	$lose.visible = false

func _process(delta):
	pass

func mostrar_panel():
		# Método público para mostrar el panel
	self.visible = true
	$lose.visible = false
	$AnimatedSprite2D.play("default")
	print("Panel mostrado desde global")
		# Opcional: Si es PopupPanel, usa panel.show() o panel.popup_centered()
	
	# Opcional: Lógica adicional, como posicionar el panel o animarlo

func actualizar_info(quest: Question) -> void:
	self.question = quest
	$pregunta.set_text(question.textQ)
	$opcion1.set_text(question.options[0])
	$opcion2.set_text(question.options[1])

func ocultar_panel():
	self.visible = false

func _on_salir_pressed() -> void:
	ocultar_panel()
	pass # Replace with function body.


func _on_opcion_1_pressed() -> void:
	if question.answerReview(0):
		ocultar_panel()
	else:
		$AnimatedSprite2D.play("dead")
		get_parent().actualizar()
		$lose.visible = true
		$AnimatedSprite2D.play("default")
		
	 # Replace with function body.


func _on_opcion_2_pressed() -> void:
	if question.answerReview(1):
		ocultar_panel()
	else:
		$AnimatedSprite2D.play("dead")
		get_parent().actualizar()
		$lose.visible = true
		$AnimatedSprite2D.play("default") # Replace with function body.
