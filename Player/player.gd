extends CharacterBody2D

const speed = 70
var current_dir = "none"

func _physics_process(delta: float) -> void:
	player_movement(delta)	

func player_movement(delta):
	var input = Vector2.ZERO

	if Input.is_action_pressed("derecha"):
		current_dir = "right"
		input.x += 1
	elif Input.is_action_pressed("izquierda"):
		current_dir = "left"
		input.x -= 1
	elif Input.is_action_pressed("abajo"):
		current_dir = "down"
		input.y += 1
	elif Input.is_action_pressed("arriba"):
		current_dir = "up"
		input.y -= 1

	if input != Vector2.ZERO:
		velocity = input.normalized() * speed
		play_anim(1)
	else:
		velocity = Vector2.ZERO
		play_anim(0)

	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("right")
		elif movement == 0:
			anim.stop()
			anim.frame = 0
			
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("left")
		elif movement == 0:
			anim.stop()
			anim.frame = 0
			
	if dir == "up":
		anim.flip_h = false
		if movement == 1:
			anim.play("up")
		elif movement == 0:
			anim.stop()
			anim.frame = 0
			
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("down")
		elif movement == 0:
			anim.stop()
			anim.frame = 0
