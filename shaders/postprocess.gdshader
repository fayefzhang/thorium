shader_type canvas_item;

uniform sampler2D iChannel0: hint_screen_texture, filter_linear_mipmap;
uniform float iTime;

float rand(vec2 uv) {
    return fract(sin(dot(uv.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Worley noise function
float worleyNoise(vec2 uv) {
    vec2 p = floor(uv);
    vec2 f = fract(uv);

    float minDist = 1.0;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = vec2(rand(p + neighbor)); // random point in the grid
            vec2 diff = neighbor + point - f;
            float dist = length(diff);
            minDist = min(minDist, dist);
        }
    }
    return minDist;
}

void fragment() {
    // Get the resolution from the texture size
    vec2 iResolution = vec2(textureSize(iChannel0, 0));

    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = FRAGCOORD.xy / iResolution.xy;

    // Time-dependent values
    float secs = TIME;
    float shakeAmount = 0.0005;
    float shakeX = .5 * sin(iTime * 2.0) * shakeAmount;
    float shakeY = .5 * cos(iTime * sin(iTime * .01)) * shakeAmount;
    uv += vec2(shakeX, shakeY);

    // Generate random value based on UV
    float random = rand(uv);

    // Worley noise distortion
    float noise = 0.1 * worleyNoise(uv * 1.5 * sin(secs) + random);
    uv += noise * 0.02;

    // Warping the UV coordinates
    vec2 warpedUv = uv;
    float moving = sin(uv.y - secs);

    if(moving > .70 && moving < .80){
        //warpedUv.y = tan(warpedUv.y * 200.0) + 1.0;
    }

    // Color offsets
    vec2 offset1 = vec2(-0.025, 0.025 * sin(secs));
    vec2 offset2 = vec2(0.0, 0.0);
    vec2 offset3 = vec2(-0.015, -0.025 * sin(secs));

    // Sample the texture with offsets
    float r = texture(iChannel0, warpedUv + offset1/5.0).r;
    float g = texture(iChannel0, warpedUv + offset3/5.0).g;
    float b = texture(iChannel0, warpedUv + offset2/5.0).b;
	// Combine channels
    vec3 col = vec3(r, g, b);

    // Output final color
    COLOR = vec4(col, 1.0);
}