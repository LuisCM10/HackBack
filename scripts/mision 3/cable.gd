extends ColorRect
signal connected(color_name)

@export var snap_radius: float = 48.0

var dragging: bool = false
var start_pos: Vector2
var connected_flag: bool = false
var color_name: String = ""
var target_name: String = ""

func _ready():
	start_pos = global_position
	
	var parts = name.split("_")
	if parts.size() >= 2:
		color_name = parts[1].to_lower()
		target_name = "Target_" + parts[1]
	else:
		color_name = "unknown"
		target_name = ""

func _input(event):
	if connected_flag:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Inicia el arrastre si se hace clic cerca del cable
				if global_position.distance_to(event.position) <= 32:
					dragging = true
					var dragline = get_parent().get_parent().get_node("LineDrawer/DragLine")
					dragline.points = [global_position, event.position]
					dragline.width = 10.0
					dragline.antialiased = true
					dragline.default_color = Color(1, 1, 1)
			else:
				
				if dragging:
					dragging = false
					_try_connect(event.position)
					var dragline = get_parent().get_parent().get_node("LineDrawer/DragLine")
					dragline.points = []
	elif event is InputEventMouseMotion and dragging:
		var dragline = get_parent().get_parent().get_node("LineDrawer/DragLine")
		dragline.points = [global_position, event.position]

func _try_connect(mouse_pos: Vector2) -> void:
	var main = get_parent().get_parent()
	var right = main.get_node("RightPanel")
	var target = right.get_node_or_null(target_name)
	if target and target.global_position.distance_to(mouse_pos) <= snap_radius:
		# CONEXIÓN CORRECTA
		connected_flag = true

		# Crear línea permanente
		var seg = Line2D.new()
		seg.width = 10.0
		seg.antialiased = true

		match color_name:
			"red": seg.default_color = Color(1, 0.25, 0.25)
			"blue": seg.default_color = Color(0.2, 0.6, 1)
			"green": seg.default_color = Color(0.25, 1, 0.6)
			"yellow": seg.default_color = Color(1, 0.9, 0.4)
			_: seg.default_color = Color(1, 1, 1)

		seg.points = [global_position, target.global_position]
		main.get_node("LineDrawer/PermanentLines").add_child(seg)

		# Animaciónr
		var tween = create_tween()
		tween.tween_property(seg, "modulate", Color(1, 1, 1, 0.3), 0.1)
		tween.tween_property(seg, "modulate", Color(1, 1, 1, 1), 0.2)

		# Sonido de conexión
		var sfx = AudioStreamPlayer.new()
		sfx.stream = preload("res://assets/music/beep-412601.mp3")
		main.add_child(sfx)
		sfx.play()

		global_position = start_pos
		emit_signal("connected", color_name)
	else:
		# CONEXIÓN FALLIDA
		_fail_feedback()

func _fail_feedback():
	var main = get_parent().get_parent()

	# Sonido de fallo
	var sfx_fail = AudioStreamPlayer.new()
	sfx_fail.stream = preload("res://assets/music/reject-interface-sound-201948.mp3")
	main.add_child(sfx_fail)
	sfx_fail.play()

	global_position = start_pos
