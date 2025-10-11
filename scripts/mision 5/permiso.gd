class_name Permiso extends CheckButton

var permiso: String 
var isActive := false
var user: User


func _on_pressed() -> void:
	isActive = not isActive
	user.changePermisos(permiso, isActive)

func mostrar_panel():# Método público para mostrar el panel
	self.visible = true
	print("Panel mostrado desde global")
		# Opcional: Si es PopupPanel, usa panel.show() o panel.popup_centered()
	
	# Opcional: Lógica adicional, como posicionar el panel o animarlo

func actualizar_info(use: User, permis: String, active: bool) -> void:
	self.isActive = active
	self.button_pressed = isActive
	self.user = use
	self.permiso = permis
	self.text = permiso

func ocultar_panel():
	self.visible = false
