shader_type canvas_item;

uniform bool isBlocking = false;
uniform float speed = 1.0;
uniform vec4 tint = vec4(1.0, 1.0, 0.2, 1.0);
uniform float span : hint_range(0.1, 1.0) = 0.3;

float luminance(vec4 colour) {
	return 1.0 - sqrt(0.299 * colour.r * colour.r + 0.587 * colour.g * colour.g + 0.114 * colour.b * colour.b);
}

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec4 colour = base;

	if (isBlocking && base.a > 0.0) {
		float target = abs(sin(TIME * PI * speed) * (1.0 + span));
		float lum = luminance(base);
		float diff = abs(lum - target);
		float mx = clamp(1.0 - diff / span, 0.0, 1.0);

		// Invertido: empieza totalmente teñido, luego vuelve al original
		colour = mix(tint, base, mx);
	}

	COLOR = colour;
}
