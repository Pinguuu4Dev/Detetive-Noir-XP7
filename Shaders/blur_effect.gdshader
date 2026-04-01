shader_type canvas_item;
uniform sampler2D screen_tex: hint_screen_texture, filter_linear_mipmap;

/** Quão [b]forte[/b] é o efeito de [i]blur[/i] */
uniform float level_of_detail: hint_range(0.0, 5) = 0.0;

// Todo pixel que o material está modificando
void fragment() {
	vec4 color = texture(screen_tex, SCREEN_UV, level_of_detail); // Faz os calcúlos para fazer o efeito de blur
	COLOR = color; // Troca a cor do material para ter o efeito de blur
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
