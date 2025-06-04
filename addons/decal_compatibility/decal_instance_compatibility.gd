@tool
extends MultiMeshInstance3D
class_name DecalInstanceCompatibility

@export var size: Vector3 = Vector3(2,2,2):
	set(value):
		if not multimesh:
			create_multimesh()
		size = value
		update_shader()

@export var instance_count: int = 0:
	set(value):
		if not multimesh:
			create_multimesh()
		instance_count = value
		multimesh.instance_count = instance_count

@export_group("Albedo")
@export var texture: Texture2D:
	set(value):
		if not multimesh:
			create_multimesh()
		texture = value
		multimesh.mesh.material.set_shader_parameter("albedo", texture)
		update_configuration_warnings()
#@export var normal: Texture2D:
	#set(value):
		#normal = value
		#multimesh.mesh.material.set_shader_parameter("normal", normal)
#@export var orm: Texture2D:
	#set(value):
		#orm = value
		#multimesh.mesh.material.set_shader_parameter("roughness", orm)
#@export var emission: Texture2D:
	#set(value):
		#emission = value
		#multimesh.mesh.material.set_shader_parameter("emission", emission)

#@export_group("Albedo")
#@export_range(0,16,0.01) var emission_energy: float = 1.0
@export var modulate: Color = Color.WHITE:
	set(value):
		if not multimesh:
			create_multimesh()
		modulate = value
		multimesh.mesh.material.set_shader_parameter("modulate", modulate)
@export_range(0,1,0.1) var albedo_mix: float = 1.0:
	set(value):
		if not multimesh:
			create_multimesh()
		albedo_mix = value
		multimesh.mesh.material.set_shader_parameter("albedo_mix", albedo_mix)

@export_group("Vertical Fade")
@export var enable_fade: bool = true:
	set(value):
		if not multimesh:
			create_multimesh()
		enable_fade = value
		multimesh.mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
@export_range(0,1,0.01) var fade_start: float = 0.3:
	set(value):
		if not multimesh:
			create_multimesh()
		fade_start = value
		multimesh.mesh.material.set_shader_parameter("fade_start", fade_start)
@export_range(0,1,0.01) var fade_end: float = 0.7:
	set(value):
		if not multimesh:
			create_multimesh()
		fade_end = value
		multimesh.mesh.material.set_shader_parameter("fade_end", fade_end)
@export_range(0.01,5,0.01) var fade_power: float = 1.0:
	set(value):
		if not multimesh:
			create_multimesh()
		fade_power = value
		multimesh.mesh.material.set_shader_parameter("fade_power", fade_power)

func create_multimesh():
	multimesh = MultiMesh.new()
	multimesh.instance_count = 0
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_custom_data = true
	#multimesh.use_colors = true
	multimesh.mesh = BoxMesh.new()
	multimesh.mesh.material = ShaderMaterial.new()
	multimesh.mesh.material.shader = preload("res://addons/decal_compatibility/decal_instance.gdshader")
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	update_shader()

func update_shader():
	multimesh.instance_count = instance_count
	multimesh.mesh.size.x = size.x
	multimesh.mesh.size.y = size.y
	multimesh.mesh.size.z = size.z
	multimesh.mesh.material.set_shader_parameter("scale_mod", Vector3(1/size.x,1/size.y,1/size.z))
	multimesh.mesh.material.set_shader_parameter("cube_half_size", Vector3(size.x/2,size.y/2,size.z/2))
	multimesh.mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
	

# @tool methods

func _get_configuration_warnings(): # display the warning on the scene dock
	var warnings = []
	if !texture:
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
	elif property.name.begins_with("multimesh"):
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
