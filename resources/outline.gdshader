shader_type spatial;
render_mode unshaded;

uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;
uniform vec3 outline_color : source_color = vec3(0.0, 0.0, 0.0); // Outline color
uniform float outline_width : hint_range(1.0, 10.0) = 1.0; // Outline width in pixels
uniform bool shadows_enabled = true; // Control whether the outline is applied

float getDepth(vec2 screen_uv, sampler2D depth_texture) {
    return texture(depth_texture, screen_uv).r;
}

void fragment() {
    if (!shadows_enabled) {
        discard; // Skip rendering if shadows are disabled
    }

    vec2 texel_size = outline_width / VIEWPORT_SIZE.xy;

    // Sample depth at the center
    float depth_center = getDepth(SCREEN_UV, DEPTH_TEXTURE);

    // Sample depth at neighboring texels
    float depth_up = getDepth(SCREEN_UV + vec2(0.0, -texel_size.y), DEPTH_TEXTURE);
    float depth_down = getDepth(SCREEN_UV + vec2(0.0, texel_size.y), DEPTH_TEXTURE);
    float depth_left = getDepth(SCREEN_UV + vec2(-texel_size.x, 0.0), DEPTH_TEXTURE);
    float depth_right = getDepth(SCREEN_UV + vec2(texel_size.x, 0.0), DEPTH_TEXTURE);

    // Calculate depth difference, adjusting for distance
    float depth_diff = abs(depth_center - depth_up)
                     + abs(depth_center - depth_down)
                     + abs(depth_center - depth_left)
                     + abs(depth_center - depth_right);

    // Adjust depth_diff based on distance to maintain consistent outline size
    depth_diff *= (1.0 / depth_center); // Inverse depth to compensate for distance

    // Create the outline by mixing the outline color
    if (depth_diff > 0.01) { // This threshold can be adjusted
        ALBEDO = outline_color;
    } else {
        discard; // Don't render anything where there's no outline
    }
}
