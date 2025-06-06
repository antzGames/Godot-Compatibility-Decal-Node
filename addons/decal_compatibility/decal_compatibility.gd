@tool
extends MeshInstance3D
class_name DecalCompatibility
## Allows simple Decals using the Compatibility renderer,
## extending the [MeshInstance3D] node.
##
## For instancing support, use the [DecalInstanceCompatibility] node,
## which will allow thousands of decals to be draw with one draw call.[br][br]
## By [b]Antz[/b] (AntzGames)
## @experimental
## @tutorial(Compatibility Decal Node Plugin for Godot 4.4+ by AntzGames): https://youtu.be/8XnH3mT1C-c
## @tutorial(Godot Decal Node for the Compatibility Renderer by AntzGames): https://youtu.be/8_vL1B_J56I

## The size of the [BoxMesh] that will be used to draw the decal.
@export var size: Vector3 = Vector3(2,2,2):
	set(value):
		if not mesh:
			_create_mesh()
		size = value
		_update_shader()

@export_group("Albedo")
## The [Texture2D] to be displayed as a Decal.
@export var texture: Texture2D:
	set(value):
		if not mesh:
			_create_mesh()
		texture = value
		mesh.material.set_shader_parameter("albedo", texture)
		update_configuration_warnings()
#@export var normal: Texture2D:
	#set(value):
		#normal = value
		#mesh.material.set_shader_parameter("normal", normal)
#@export var orm: Texture2D:
	#set(value):
		#orm = value
		#mesh.material.set_shader_parameter("orm", orm)
#@export var emission: Texture2D:
	#set(value):
		#emission = value
		#mesh.material.set_shader_parameter("emission", emission)

#@export_group("Albedo")
#@export_range(0,16,0.01) var emission_energy: float = 1.0:
	#set(value):
		#if not mesh:
			#_create_mesh()
		#emission_energy = value
		#mesh.material.set_shader_parameter("emission_energy", emission_energy)
## Colorize your Decal.  You can also modify the alpha channel.
@export var modulate: Color = Color.WHITE:
	set(value):
		if not mesh:
			_create_mesh()
		modulate = value
		mesh.material.set_shader_parameter("modulate", modulate)
## The strength of the mixing between the decal's albedo and the underlying geometry's material albedo.
@export_range(0,1,0.1) var albedo_mix: float = 1.0:
	set(value):
		if not mesh:
			_create_mesh()
		albedo_mix = value
		mesh.material.set_shader_parameter("albedo_mix", albedo_mix)

@export_group("Vertical Fade")
## Enable/disable fading.
@export var enable_fade: bool = true:
	set(value):
		if not mesh:
			_create_mesh()
		enable_fade = value
		mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
## Range between 0..1
@export_range(0,1,0.01) var fade_start: float = 0.3:
	set(value):
		if not mesh:
			_create_mesh()
		fade_start = value
		mesh.material.set_shader_parameter("fade_start", fade_start)
## Range between 0..1
@export_range(0,1,0.01) var fade_end: float = 0.7:
	set(value):
		if not mesh:
			_create_mesh()
		fade_end = value
		mesh.material.set_shader_parameter("fade_end", fade_end)
		## Range between 0..5
@export_range(0.01,5,0.01) var fade_power: float = 1.0:
	set(value):
		if not mesh:
			_create_mesh()
		fade_power = value
		mesh.material.set_shader_parameter("fade_power", fade_power)

func _create_mesh():
	mesh = BoxMesh.new()
	mesh.material = ShaderMaterial.new()
	mesh.material.shader = preload("res://addons/decal_compatibility/decal.gdshader")
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_update_shader()

func _update_shader():
	mesh.size.x = size.x
	mesh.size.y = size.y
	mesh.size.z = size.z
	mesh.material.set_shader_parameter("scale_mod", Vector3(1/size.x,1/size.y,1/size.z))
	mesh.material.set_shader_parameter("cube_half_size", Vector3(size.x/2,size.y/2,size.z/2))
	mesh.material.set_shader_parameter("enable_y_fade", enable_fade)

# @tool methods
func _get_configuration_warnings(): # display the warning on the scene dock
	var warnings = []
	if !texture:
		warnings.push_back('No Albedo texture set.')
	if !RenderingServer.get_current_rendering_method().begins_with("gl_"):
		warnings.push_back('This node only works with the Compatibility renderer.')
	return warnings
	
func _validate_property(property: Dictionary) -> void:
	if property.name == "albedo":
		update_configuration_warnings()
	elif property.name == "size":
		property.type = TYPE_VECTOR3
		property.usage = PROPERTY_USAGE_DEFAULT
		property.hint = PROPERTY_HINT_RANGE
		property.hint_string= "0.001,1024.0,0.001"
	
	# Comment out any ELIF below to UNHIDE properties you want to see in the inspector
	elif property.name in ["transparency","mesh","skin", "skeleton", "Skeleton", "material_override", "material_overlay", "lod_bias"]:
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
