shader_type canvas_item;

uniform float vignette_radius = 0.2;
uniform float scanline_strength = 0.2;
uniform float noise_strength = 0.1;
uniform float time_speed = 1.0;
uniform vec4 tint_color = vec4(1.0, 1.0, 1.0, 1.0); // Une couleur pour teinter l'image

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = UV;
    vec4 texture_color = texture(TEXTURE, uv);

    // 1. Lignes de balayage (Scanlines)
    float scanline = sin(uv.y * 300.0) * 0.5 + 0.5;
    scanline = pow(scanline, 1.5) * scanline_strength;
    texture_color.rgb -= vec3(scanline);

    // 2. Bruit analogique (Noise)
    float noise = sin(dot(uv * TIME * time_speed, vec2(12.9898, 78.233))) * 43758.5453;
    noise = fract(noise);
    noise = (noise - 0.5) * noise_strength;
    texture_color.rgb += vec3(noise);

    // 3. Vignette
    vec2 center = vec2(0.5, 0.5);
    float dist = distance(uv, center);
    float vignette = smoothstep(vignette_radius, 1.0, dist);
    texture_color.rgb *= (1.0 - vignette);

    // 4. Couleur verte/noir-blanc
    vec3 grayscale = vec3(dot(texture_color.rgb, vec3(0.299, 0.587, 0.114)));
    vec3 final_color = mix(grayscale, texture_color.rgb, 0.0); // Mettre 0.0 pour du noir et blanc, ou 0.2 pour un léger vert
	final_color *= tint_color.rgb;
    COLOR = vec4(final_color, 0.6);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
