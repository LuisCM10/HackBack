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
@onready var icono_sonido = preload("res://BotonVol.png")
@onready var icono_mute = preload("res://BotónNoVol.png")

var arbol : Arbol
var raiz

var musica_activa = true
var loading = false
var scene_init

func _ready():
	Resources.iniciarJuego()	
	arbol = Resources.arbol
	raiz = arbol.raiz
	mostrar_Config(false)
	

# ===========================
# Funciones de botones
# ===========================

func _on_settings_pressed():
	mostrar_Config(true)

func _on_cerrar_button_pressed():
	mostrar_Config(false)

func _on_boton_quitar_musica_pressed():
	if musica.playing:
		musica.stop()
		musica_activa = false
	else:
		musica.play()
		musica_activa = true
	_actualizar_icono_musica()

func _on_salir_pressed():
	get_tree().quit()

func _on_boton_inicio_pressed():
	GlobalState.set_nodoActual(raiz)
	get_tree().change_scene_to_file(GlobalState.Loader)
	print("Oprime boton inicio")
	
# ===========================
# Función de icono de música
# ===========================
func _actualizar_icono_musica():
	if musica_activa:
		boton_quitar_musica.texture_normal = icono_sonido
	else:
		boton_quitar_musica.texture_normal = icono_mute

func mostrar_Config(value: bool):
	_actualizar_icono_musica()
	fondo.visible = not value
	boton_inicio.visible = not value
	boton_salir.visible = not value
	boton_config.visible = not value
	panel.visible = value
	
func mostrar() -> void :
	self.visible = true

func ocultar() -> void:
	self.visible = false
