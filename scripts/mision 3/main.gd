extends Node2D

@export var total_needed: int = 4
var connected_count: int = 0

func _ready():
	var left = $LeftPanel
	for cable in left.get_children():
		if cable is Node:
			cable.connect("connected", Callable(self, "_on_cable_connected"))

func _on_cable_connected(color_name: String)->void:
	connected_count += 1
	$Label.text = "Conectados: %d / %d" % [connected_count, total_needed]
	if connected_count >= total_needed:
		$Label.text = "Tarea completada"
		var t = get_tree().create_timer(0.6)
		t.timeout.connect(func():
			get_tree().change_scene_to_file("res://next_scene.tscn")
		)
