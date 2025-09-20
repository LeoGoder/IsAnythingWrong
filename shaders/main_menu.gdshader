shader_type canvas_item;

// Cette variable nous permet de contrôler l'intensité du flou depuis l'inspecteur
uniform float blur_amount : hint_range(0.0, 5.0) = 3.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // SCREEN_TEXTURE est un échantillon de ce qui est rendu derrière ce nœud
    vec4 screen_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur_amount);

    // On applique le résultat à la couleur de notre ColorRect
    // Le alpha reste géré par la couleur du ColorRect
    COLOR.rgb = screen_color.rgb;
}