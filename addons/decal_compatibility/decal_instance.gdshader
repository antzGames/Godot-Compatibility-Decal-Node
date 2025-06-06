/*

Based on Lelu's decal shader: https://godotshaders.com/shader/decal-shader-similar-to-forward-decal-but-for-compatibility-mobile/
which is based these two shaders:

TwistedTwigleg decal example shader: https://godotshaders.com/shader/decal-example/
OlisUnfinishedProjects Decal shader: https://godotshaders.com/shader/decal-shader-4-0-port/

Plumbing for normal, orm, emission textures commented out

*/

shader_type spatial;
//render_mode world_vertex_coords, blend_mix, depth_test_disabled, depth_draw_opaque, cull_front, diffuse_lambert, specular_schlick_ggx;
render_mode unshaded, cull_front, depth_test_disabled; // Hack

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture ,filter_linear_mipmap;

uniform sampler2D albedo : source_color, hint_default_transparent, repeat_disable, filter_linear_mipmap_anisotropic;
//uniform sampler2D normal : source_color, hint_normal, repeat_disable, filter_linear_mipmap_anisotropic;
//uniform sampler2D orm : source_color, hint_default_white, repeat_disable, filter_linear_mipmap_anisotropic;
//uniform sampler2D emission : source_color, hint_default_black, repeat_disable, filter_linear_mipmap_anisotropic;

// Albedo modulate and mix
uniform vec4 modulate : source_color = vec4(1.0,1.0,1.0,1.0);
uniform float albedo_mix : hint_range(0.0, 1.0, 0.1) = 1.0;

//uniform float emission_energy : hint_range(0.0, 30, 0.1) = 1.0;
//uniform vec4 modulate_emission : source_color = vec4(1.0,1.0,1.0,1.0);

uniform vec3 scale_mod = vec3(0);
uniform vec3 cube_half_size = vec3(0);

varying mat4 INV_MODEL_MATRIX;
varying flat vec4 custom_data;

// Y-axis fade controls
uniform bool enable_y_fade = true; // Toggle for fade effect
uniform float fade_start = 0.3; // Where fading begins (0-1)
uniform float fade_end = 0.7;   // Where fading ends (0-1)
uniform float fade_power = 1.0; // Curve sharpness

void vertex(){
	INV_MODEL_MATRIX = inverse(MODEL_MATRIX);
	custom_data = INSTANCE_CUSTOM;
}

// Credit: https://stackoverflow.com/questions/32227283/getting-world-position-from-depth-buffer-value
vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
	float z = depth * 2.0 - 1.0;
	vec4 clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
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

void fragment() {
	if (custom_data.a < 0.001) discard;

	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, (INV_VIEW_MATRIX));
	vec4 test_pos = (INV_MODEL_MATRIX * vec4(world_pos, 1.0));

	if (abs(test_pos.x) > cube_half_size.x ||
		abs(test_pos.y) > cube_half_size.y ||
		abs(test_pos.z) > cube_half_size.z) {
		discard;
	}

    vec2 NEW_UV = (test_pos.xz * scale_mod.xz) + 0.5;

	//vec3 emission_map = texture(emission, NEW_UV).rgb;
  	//vec3 normal_map = texture(normal, NEW_UV);

	// AO = RED, orm = GREEN, METALLIC = BLUE,
	//float ao_map = texture(orm, NEW_UV).r;
    //float orm_map = texture(orm, NEW_UV).g;
	//float metallic_map = texture(orm, NEW_UV).b;

    // Default fade factor (1.0 means no fade)
    float y_fade = 1.0;

    // Only calculate fade if enabled
    if (enable_y_fade) {
        y_fade = smooth_fade(test_pos.y);
        if (y_fade <= 0.0) {
            discard;
        }
	}

	ALBEDO = texture(albedo, NEW_UV).rgb * modulate.rgb * y_fade;
	ALPHA = texture(albedo, NEW_UV).a * modulate.a * albedo_mix * y_fade * custom_data.a;

	//NORMAL_MAP = normal_map;
	//METALLIC = metallic_map;
	//ROUGHNESS = orm_map;
	//AO = ao_map;
	//EMISSION = emission_map * emission_energy * modulate_emission.rgb * y_fade;
}
