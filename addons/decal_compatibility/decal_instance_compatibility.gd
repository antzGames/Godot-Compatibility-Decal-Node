@tool
extends MultiMeshInstance3D
class_name DecalInstanceCompatibility
## Allows simple instanced Decals using the Compatibility renderer,
## extending the [MultiMeshInstance3D] node.
##
## This node allows thousands of decals to be draw with one draw call.[br][br]
## Remember to call [method reset_all_instances] or [method reset_instance] after
## fading instances.[br][br]
## By [b]Antz[/b] (AntzGames)
## @tutorial(Compatibility Decal Node Plugin for Godot 4.4+ by AntzGames): https://youtu.be/8XnH3mT1C-c
## @tutorial(Godot Decal Node for the Compatibility Renderer by AntzGames): https://youtu.be/8_vL1B_J56I

var _rollover_value : float = ProjectSettings.get_setting("rendering/limits/time/time_rollover_secs")

## The size of the [BoxMesh] that will be used to draw the decal.
@export var size: Vector3 = Vector3(2,2,2):
	set(value):
		if not multimesh:
			_create_multimesh()
		size = value
		_update_shader()

## The maximum number of instances to be displayed.[br]
## This will create the buffers for instances and custom_data.
@export var instance_count: int = 0:
	set(value):
		if not multimesh:
			_create_multimesh()
		instance_count = value
		multimesh.instance_count = instance_count
		reset_all_instances()

@export_group("Albedo")
## The [Texture2D] to be displayed as a Decal.
@export var texture: Texture2D:
	set(value):
		if not multimesh:
			_create_multimesh()
		texture = value
		multimesh.mesh.material.set_shader_parameter("albedo", texture)
		update_configuration_warnings()

## Colorize your Decal.  You can also modify the alpha channel.
@export var modulate: Color = Color.WHITE:
	set(value):
		if not multimesh:
			_create_multimesh()
		modulate = value
		multimesh.mesh.material.set_shader_parameter("modulate", modulate)
## The strength of the mixing between the decal's albedo and the underlying geometry's material albedo.
@export_range(0,1,0.1) var albedo_mix: float = 1.0:
	set(value):
		if not multimesh:
			_create_multimesh()
		albedo_mix = value
		multimesh.mesh.material.set_shader_parameter("albedo_mix", albedo_mix)

@export_group("FlipBook")
## Enable/Disable flipbook animation
@export var is_flipbook: bool = false:
	set(value):
		if not multimesh:
			_create_multimesh()
		is_flipbook = value
		multimesh.mesh.material.set_shader_parameter("is_flipbook", is_flipbook)
## Enable/Disable one shot animation, will always play last frame after animation completion
@export var is_one_shot: bool = false:
	set(value):
		if not multimesh:
			_create_multimesh()
		is_one_shot = value
		multimesh.mesh.material.set_shader_parameter("is_one_shot", is_one_shot)
@export var x_frames: int = 1:
	set(value):
		if not multimesh:
			_create_multimesh()
		x_frames = value
		multimesh.mesh.material.set_shader_parameter("x_frames", x_frames)
@export var y_frames: int = 1:
	set(value):
		if not multimesh:
			_create_multimesh()
		y_frames = value
		multimesh.mesh.material.set_shader_parameter("y_frames", y_frames)
@export_range(1.0,60.0, 0.1) var flipbook_speed: float = 12.0:
	set(value):
		if not multimesh:
			_create_multimesh()
		flipbook_speed = value
		multimesh.mesh.material.set_shader_parameter("flipbook_speed", flipbook_speed)

@export_group("Vertical Fade")
## Enable/disable fading.
@export var enable_fade: bool = false:
	set(value):
		if not multimesh:
			_create_multimesh()
		enable_fade = value
		multimesh.mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
## Range between 0..1
@export_range(0,1,0.01) var fade_start: float = 0.3:
	set(value):
		if not multimesh:
			_create_multimesh()
		fade_start = value
		multimesh.mesh.material.set_shader_parameter("fade_start", fade_start)
## Range between 0..1
@export_range(0,1,0.01) var fade_end: float = 0.7:
	set(value):
		if not multimesh:
			_create_multimesh()
		fade_end = value
		multimesh.mesh.material.set_shader_parameter("fade_end", fade_end)
## Range between 0..5
@export_range(0.01,5,0.01) var fade_power: float = 1.0:
	set(value):
		if not multimesh:
			_create_multimesh()
		fade_power = value
		multimesh.mesh.material.set_shader_parameter("fade_power", fade_power)

func _create_multimesh():
	multimesh = MultiMesh.new()
	multimesh.instance_count = 0
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.use_custom_data = true
	#multimesh.use_colors = true
	multimesh.mesh = BoxMesh.new()
	multimesh.mesh.material = ShaderMaterial.new()
	multimesh.mesh.material.shader = preload("res://addons/decal_compatibility/decal_instance.gdshader")
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	_update_shader()

func _update_shader():
	multimesh.instance_count = instance_count
	multimesh.mesh.size.x = size.x
	multimesh.mesh.size.y = size.y
	multimesh.mesh.size.z = size.z
	multimesh.mesh.material.set_shader_parameter("scale_mod", Vector3(1/size.x,1/size.y,1/size.z))
	multimesh.mesh.material.set_shader_parameter("cube_half_size", Vector3(size.x/2,size.y/2,size.z/2))
	multimesh.mesh.material.set_shader_parameter("enable_y_fade", enable_fade)
	

# instance methods

## Resets the custom_data.a (alpha) for all instances.
func reset_all_instances():
	for instance in multimesh.instance_count:
		reset_instance(instance)

## Resets the custom_data.a (alpha) for a specific instance.[br][br]
## [param instance_id] is the specific instance to reset.
func reset_instance(instance_id: int):
	var custom_data: Color = multimesh.get_instance_custom_data(instance_id)
	custom_data.r = get_current_timestamp()
	custom_data.a = 1.0
	multimesh.set_instance_custom_data(instance_id, custom_data)

## Fade out a specific instance.[br][br]
## [param instance_id] is the specific instance to fade.[br]
## [param fade_out_time] the duration of the fade.[br]
## [param start_delay] is the delay before fade starts.
func fade_out_instance(instance_id: int, fade_out_time: float = 1.0, start_delay: float = 0.0):
	if fade_out_time < 0: return
	if instance_id >= multimesh.instance_count: return
	
	var custom_data: Color = multimesh.get_instance_custom_data(instance_id)
	if custom_data.a <= 0: return
	
	var fade_tween = create_tween()
	fade_tween.tween_method(
		_do_tween_fade.bind(instance_id),
		multimesh.get_instance_custom_data(instance_id).a,
		0,
		fade_out_time).set_delay(start_delay)

## Fade in a specific instance.[br][br]
## [param instance_id] is the specific instance to fade in.[br]
## [param fade_out_time] the duration of the fade.[br]
## [param start_delay] is the delay before fade starts.
func fade_in_instance(instance_id: int, fade_in_time: float = 1.0, start_delay: float = 0.0):
	if fade_in_time < 0: return
	if instance_id >= multimesh.instance_count: return

	var custom_data: Color = multimesh.get_instance_custom_data(instance_id)
	if custom_data.a >= 1: return
	
	var fade_tween = create_tween()
	fade_tween.tween_method(
		_do_tween_fade.bind(instance_id),
		multimesh.get_instance_custom_data(instance_id).a,
		1,
		fade_in_time).set_delay(start_delay)

func _do_tween_fade(value: float, id: int):
	var custom_data: Color = multimesh.get_instance_custom_data(id)
	custom_data.a = value
	multimesh.set_instance_custom_data(id, custom_data)
	
# @tool methods

func _get_configuration_warnings(): # display the warning on the scene dock
	var warnings = []
	if !texture:
		warnings.push_back('No Albedo texture set.')
	if !RenderingServer.get_current_rendering_method().begins_with("gl_"):
		warnings.push_back('Recommend you use Godots built in Decal Node')
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
	elif property.name.begins_with("multimesh"):
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

## Restarts the one shot animation for a specific instance_id.[br][br]
## Only valid if [is_one_shot] is true
func reset_one_shot(instance_id: int):
	if !is_one_shot: return
	
	var custom_data: Color = multimesh.get_instance_custom_data(instance_id)
	custom_data.r = get_current_timestamp()
	multimesh.set_instance_custom_data(instance_id, custom_data)

func get_current_timestamp() -> float:
	return fmod((float(Time.get_ticks_msec()) / 1000.0), _rollover_value) - 0.5
