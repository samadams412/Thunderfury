shader_type canvas_item;

// This links the shader to the palette texture in the Inspector
uniform sampler2D palette : filter_nearest;

void fragment() {
    // 1. Get the color (grayscale value) of the current pixel from your dirt image
    vec4 grayscale_pixel = texture(TEXTURE, UV);
    
    // 2. Sample the terracotta palette using the red channel (0.0 to 1.0) as the X coordinate
    // Because the image is grayscale, .r, .g, and .b are all the same value.
    vec4 new_color = texture(palette, vec2(grayscale_pixel.r, 0.0));
    
    // 3. Set the final pixel color, but keep the original transparency (alpha)
    COLOR = vec4(new_color.rgb, grayscale_pixel.a);
}