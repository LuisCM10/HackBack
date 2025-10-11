class_name User

var icon: String
var name: String
var rol: String
var permisos = {}
var permisosReales = {}

func _init(iconPath: String, nam: String, ro: String, permiso: Dictionary, permisosReale: Dictionary) -> void:
	self.icon = iconPath
	self.name = nam
	self.rol = ro
	self.permisos = permiso
	self.permisosReales = permisosReale

func changePermisos (key, value: bool) -> void:
	permisosReales[key] = value
	print("Permiso '" + key + "' actualizado exitosamente")


func correctPermisos () -> bool:
	if permisos == null or permisosReales == null:
		return false    
	for x in permisos:
		if not permisosReales.has(x) or permisos[x] != permisosReales[x]:
			return false
	return true
