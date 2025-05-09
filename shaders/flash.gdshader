shader_type canvas_item;

uniform bool isDeath = false;
uniform bool isAttacking = false;
uniform vec4 flash_color : source_color;
uniform float flash_value : hint_range(0.0, 1.0, 0.1);
uniform float alphaValue : hint_range(0.0, 1.0, 0.1);

void fragment(){
	vec4 texture_color = texture(TEXTURE, UV);

	if (isDeath) {
		COLOR = texture_color;
		COLOR.a *= alphaValue;
	} else if (isAttacking){
		COLOR = mix(texture_color, vec4(0.80, 0.00, 0.00, 1.0), 0.7);
		COLOR.a = texture_color.a;
	} else {
		COLOR = mix(texture_color, flash_color, flash_value);
		COLOR.a = texture_color.a;
	}
}
