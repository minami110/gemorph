shader_type spatial;
render_mode unshaded;

uniform sampler2D albedo: source_color;
varying vec3 WORLD_POS;
varying vec3 WORLD_NORMAL;

vec3 GetTriplanarWeights (vec3 normal) {
	vec3 triW = abs(normal);
	return triW / (triW.x + triW.y + triW.z);
}

void vertex() {
	// Called for every vertex the material is visible on.
	WORLD_POS = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	WORLD_NORMAL = (MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz;
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec3 albedoX = texture(albedo, WORLD_POS.zy).rgb;
	vec3 albedoY = texture(albedo, WORLD_POS.xz).rgb;
	vec3 albedoZ = texture(albedo, WORLD_POS.xy).rgb;
	vec3 triW = GetTriplanarWeights(WORLD_NORMAL);
	ALBEDO = albedoX * triW.x + albedoY * triW.y + albedoZ * triW.z;
}
