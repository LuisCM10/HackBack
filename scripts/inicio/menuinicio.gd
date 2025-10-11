extends Control

# Nodos principales
@onready var fondo = $fondo
@onready var boton_inicio = $BotonInicio
@onready var boton_config = $BotonConfiguracion
@onready var boton_salir =$salir  # Asegúrate que el nodo se llame así exactamente
@onready var panel = $PanelConfiguracion
@onready var musica = $musica # Nodo de música

# Panel de configuración
@onready var boton_quitar_musica = $PanelConfiguracion/BotonQuitarMusica
@onready var boton_cerrar = $PanelConfiguracion/CerrarButton
@onready var label_instrucciones = $PanelConfiguracion/LabelInstrucciones

# Íconos de música
@onready var icono_sonido = preload("res://assets/img/inicio/sonido.png")
@onready var icono_mute = preload("res://assets/img/inicio/sonido.png")

var arbol : Arbol
var raiz

var musica_activa = true


func _ready():
	panel.visible = false

	# Conectar botones a sus funciones
	boton_config.pressed.connect(_on_boton_configuracion_pressed)
	boton_cerrar.pressed.connect(_on_boton_cerrar_pressed)
	boton_quitar_musica.pressed.connect(_on_boton_quitar_musica_pressed)
	boton_salir.pressed.connect(_on_boton_salir_pressed)
	boton_inicio.pressed.connect(_on_boton_inicio_pressed)

	_actualizar_icono_musica()


# ===========================
# Funciones de botones
# ===========================

func _on_boton_configuracion_pressed():
	mostrar_Config(false)

func _on_boton_cerrar_pressed():
	mostrar_Config(true)

func _on_boton_quitar_musica_pressed():
	if musica.playing:
		musica.stop()
		musica_activa = false
	else:
		musica.play()
		musica_activa = true
	_actualizar_icono_musica()

func _on_boton_salir_pressed():
	get_tree().quit()

func _on_boton_inicio_pressed():
	print("Oprime boton inicio")
	await Map.iniciarJuego()	
	arbol = Map.arbol
	raiz = arbol.raiz.scene.instantiate()
	get_tree().current_scene.add_child(raiz)
	ocultar()


# ===========================
# Función de icono de música
# ===========================
func _actualizar_icono_musica():
	if musica_activa:
		boton_quitar_musica.texture_normal = icono_sonido
	else:
		boton_quitar_musica.texture_normal = icono_mute

func mostrar_Config(value: bool):
	fondo.visible = value
	boton_inicio.visible = value
	boton_salir.visible = value
	boton_config.visible = value
	panel.visible = not value
	
func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false
