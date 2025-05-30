@tool
extends MeshInstance3D
class_name DecalCompatibility

@export var size: Vector3 = Vector3(2,2,2):
	set(value):
		if not mesh:
			create_mesh()
		size = value
		update_shader()
		#print(mesh.size)

@export_group("Textures")
@export var albedo: Texture2D:
	set(value):
		if not mesh:
			create_mesh()
		albedo = value
		mesh.material.set_shader_parameter("albedo", albedo)
#@export var normal: Texture2D:
	#set(value):
		#normal = value
		#mesh.material.set_shader_parameter("normal", normal)
#@export var orm: Texture2D:
	#set(value):
		#orm = value
		#mesh.material.set_shader_parameter("roughness", orm)
#@export var emission: Texture2D:
	#set(value):
		#emission = value
		#mesh.material.set_shader_parameter("emission", emission)

@export_group("Parameters")
#@export_range(0,16,0.01) var emission_energy: float = 1.0
@export var modulate: Color = Color.WHITE:
	set(value):
		if not mesh:
			create_mesh()
		modulate = value
		mesh.material.set_shader_parameter("modulate", modulate)
@export_range(0,1,0.1) var albedo_mix: float = 1.0:
	set(value):
		if not mesh:
			create_mesh()
		albedo_mix = value
		mesh.material.set_shader_parameter("albedo_mix", albedo_mix)

@export_group("Vertical Fade")
@export var enable_fade: bool = true:
	set(value):
		if not mesh:
			create_mesh()
		enable_fade = value
		mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
@export_range(0,1,0.01) var fade_start: float = 0.3:
	set(value):
		if not mesh:
			create_mesh()
		fade_start = value
		mesh.material.set_shader_parameter("fade_start", fade_start)
@export_range(0,1,0.01) var fade_end: float = 0.7:
	set(value):
		if not mesh:
			create_mesh()
		fade_end = value
		mesh.material.set_shader_parameter("fade_end", fade_end)
@export_range(0.01,5,0.01) var fade_power: float = 1.0:
	set(value):
		if not mesh:
			create_mesh()
		fade_power = value
		mesh.material.set_shader_parameter("fade_power", fade_power)

func create_mesh():
	mesh = BoxMesh.new()
	mesh.material = ShaderMaterial.new()
	mesh.material.shader = preload("res://addons/decal_compatibility_node/decal.gdshader")
	update_shader()

func update_shader():
	mesh.size.x = size.x
	mesh.size.y = size.y
	mesh.size.z = size.z
	mesh.material.set_shader_parameter("scale_mod", Vector3(1/size.x,1/size.y,1/size.z))
	mesh.material.set_shader_parameter("cube_half_size", Vector3(size.x/2,size.y/2,size.z/2))
	mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
	

# @tool methods

func _get_configuration_warnings(): # display the warning on the scene dock
	var warnings = []
	if !albedo:
		warnings.push_back('No Albedo texture set.')
	return warnings
	
func _validate_property(property: Dictionary) -> void:
	if property.name == "albedo":
		update_configuration_warnings()
	elif property.name == "size":
		property.type = TYPE_VECTOR3
		property.usage = PROPERTY_USAGE_DEFAULT
		property.hint = PROPERTY_HINT_RANGE
		property.hint_string= "0.001,1024.0,0.001"
	elif property.name in ["transparency","mesh","skin", "skeleton", "Skeleton", "material_override", "material_overlay", "lod_bias"]:
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("visibility_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("gi_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("cast_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("extra_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("custom_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("ignore_"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	elif property.name.begins_with("Surface"):
		property.usage = PROPERTY_USAGE_NO_EDITOR
	#else:
		#print(property)
