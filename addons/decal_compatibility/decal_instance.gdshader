/*
Instanced CUSTOM_DATA

custom_data.r = instanced one_shot timestamp
custom_data.g = instanced frame offset [0..(x_frames * y_frames - 1)]
custom_data.b = Not used
custom_data.a = instance alpha of decal: use fade_out_instance(instance_id, fade_out_time, start_delay)

*/

shader_type spatial;
//render_mode world_vertex_coords, blend_mix, depth_test_disabled, depth_draw_opaque, cull_front, diffuse_lambert, specular_schlick_ggx;
render_mode unshaded, cull_disabled, depth_test_disabled; // Hack

stencil_mode read, compare_not_equal, 1;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture ,filter_linear_mipmap;

// Albedo texture, modulate and mix
uniform sampler2D albedo : source_color, hint_default_transparent, repeat_disable, filter_linear;
uniform vec4 modulate : source_color = vec4(1.0,1.0,1.0,1.0);
uniform float albedo_mix : hint_range(0.0, 1.0, 0.1) = 1.0;

uniform vec3 scale_mod = vec3(0);
uniform vec3 cube_half_size = vec3(0);

varying mat4 INV_MODEL_MATRIX;
varying flat vec4 custom_data;

// Y-axis fade controls
uniform bool enable_y_fade = true; // Toggle for fade effect
uniform float fade_start = 0.3; // Where fading begins (0-1)
uniform float fade_end = 0.7;   // Where fading ends (0-1)
uniform float fade_power = 1.0; // Curve sharpness

// Flipbook
uniform bool is_flipbook = false;
uniform bool is_one_shot = false;
uniform int x_frames = 5;
uniform int y_frames = 5;
uniform float flipbook_speed = 12.0;

void vertex(){
	INV_MODEL_MATRIX = inverse(MODEL_MATRIX);
	custom_data = INSTANCE_CUSTOM;
}

// Credit: https://stackoverflow.com/questions/32227283/getting-world-position-from-depth-buffer-value
vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
	float z = depth * 2.0 - 1.0;
	vec4 clipSpacePosition;
	
	#if CURRENT_RENDERER == RENDERER_COMPATIBILITY
		clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
	#elif CURRENT_RENDERER == RENDERER_MOBILE
		clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, depth, 1.0);
	#else // CURRENT_RENDERER == RENDERER_FORWARD_PLUS
		clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, depth, 1.0);
	#endif
	
	vec4 viewSpacePosition = inverse_proj * clipSpacePosition;
	viewSpacePosition /= viewSpacePosition.w;
	vec4 worldSpacePosition = inverse_view * viewSpacePosition;
	return worldSpacePosition.xyz;
}

float smooth_fade(float y_pos) {
    // Normalize Y position (-0.5 to 0.5) -> (0 to 1)
    float normalized_y = clamp((y_pos + cube_half_size.y) / (2.0 * cube_half_size.y), 0.0, 1.0);

    // Calculate fade factor
    float fade_factor = smoothstep(fade_start, fade_end, normalized_y);
    fade_factor = pow(fade_factor, fade_power);

    return 1.0 - fade_factor;
}

bool checkCameraClippingDecal(mat4 inv_view_matrix, mat4 inv_model_matrix) {
	// Reconstruct camera world position
	vec3 camera_world = (inv_view_matrix * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

	// Transform to decal local space
	vec4 camera_local = inv_model_matrix * vec4(camera_world, 1.0);

	// Detect clip: camera inside decal geometry
	return (abs(camera_local.x) < cube_half_size.x) ||
		(abs(camera_local.y) < cube_half_size.y) ||
		(abs(camera_local.z) < cube_half_size.z);
}

vec2 flipbook(vec2 uv, vec2 size, float progress){
	if (is_one_shot && progress >= size.x * size.y){
		return size;
	}
	
	progress = floor(mod(progress, (size.x * size.y)) );
	vec2 frame_size = vec2(1.0, 1.0) / vec2(size.x, size.y);
	vec2 frame = fract(uv / size) + frame_size;
	
	frame.x += ( (progress / size.x) - frame_size.x * floor(progress/size.x) * size.x ) - frame_size.x;
	frame.y += (frame_size.y * floor(progress/size.x) ) - frame_size.y ;
	
	return frame;
}

void fragment() {
	if (custom_data.a < 0.001) discard;

	bool clipped = checkCameraClippingDecal(INV_VIEW_MATRIX, INV_MODEL_MATRIX);

	// Discard front or back side so you dont get double albedo - also speeds up rendering
	if (!clipped && !FRONT_FACING) { // discard back
		discard;
	} else if (clipped && FRONT_FACING) { // discard front
		discard;
	}

	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, (INV_VIEW_MATRIX));
	vec4 test_pos = (INV_MODEL_MATRIX * vec4(world_pos, 1.0));

	if (abs(test_pos.x) > cube_half_size.x ||
		abs(test_pos.y) > cube_half_size.y ||
		abs(test_pos.z) > cube_half_size.z) {
		discard;
	}

    vec2 NEW_UV = (test_pos.xz * scale_mod.xz) + 0.5;

    // Default fade factor (1.0 means no fade)
    float y_fade = 1.0;

    // Only calculate fade if enabled
    if (enable_y_fade) {
        y_fade = smooth_fade(test_pos.y);
        if (y_fade <= 0.0) {
            discard;
        }
	}

	// Flipbook?
	if (is_flipbook){
		if (is_one_shot) {
			float time_stamp = custom_data.r;
			NEW_UV = flipbook(NEW_UV, vec2(float(x_frames), float(y_frames)), (TIME - time_stamp) * flipbook_speed);
		} else {
			NEW_UV = flipbook(NEW_UV, vec2(float(x_frames), float(y_frames)), (TIME + custom_data.g )* flipbook_speed);
		}
	}

	vec4 _albedo = texture(albedo, NEW_UV);

	ALBEDO = _albedo.rgb * modulate.rgb * y_fade;
	ALPHA = _albedo.a * modulate.a * albedo_mix * y_fade * custom_data.a;
}
