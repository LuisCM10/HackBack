extends Area2D

@onready var exclamation_mark = $ExclamationMark
@onready var anim = $AnimatedSprite2D
const DialogoNpcHoja = preload("res://Dialogues/DialogoNpcHoja.dialogue")


var is_player_close =  false

func _ready() -> void:
	anim.play("idle")

func _process(delta: float) -> void:
	if is_player_close and Input.is_action_just_pressed("interact"):
		var balloon = DialogueManager.show_dialogue_balloon(DialogoNpcHoja)
		await balloon.finished
		GlobalState.volverAnterior()	
		get_tree().change_scene_to_file(GlobalState.Loader)
		
func _on_area_entered(area: Area2D) -> void:
	exclamation_mark.visible = true
	is_player_close = true


func _on_area_exited(area: Area2D) -> void:
	exclamation_mark.visible = false
	is_player_close = false
