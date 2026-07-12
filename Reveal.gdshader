shader_type canvas_item;

uniform float Radial = -1.0;

void fragment() {
	float Rad = length(UV - vec2(0.5)) * 2.0;
	float Value = texture(TEXTURE, UV).r - Rad + Radial;
	if (Value < 0.0) {
		discard;
	}
	COLOR = vec4(vec3(1.0), Value);
}
