//-----------------------------------------------------------------------------
// Lo-Fi CRT Shader v2 for Ghostty
//-----------------------------------------------------------------------------
//
// An authentic retro-aesthetic CRT shader with PC monitor style RGB phosphors.
//
// USAGE:
//   Add to your Ghostty config (~/.config/ghostty/config):
//     custom-shader = ~/.config/ghostty/shaders/lofi-crt.glsl
//
//   Suggested Ghostty config for best results:
//     background = 000800
//     background-blur = 50
//     background-opacity = 0.8
//
// FEATURES:
//   - CRT screen curvature (barrel distortion) with ultra-wide monitor support
//   - 3D beveled frame with configurable width and lighting
//   - Shadow mask RGB phosphor dots
//   - Optional horizontal scanlines
//   - Subtle glow/bloom effect on bright pixels
//   - Glass flare reflection
//   - Moving car light reflections (ambient effect)
//   - Background darkening for better contrast
//
// CUSTOMIZATION:
//   All parameters are defined as constants at the top of the file.
//   Adjust values to taste - each parameter has inline documentation.
//
//   Key parameters to tweak first:
//   - WARP: Screen curvature amount (0 = flat, higher = more curved)
//   - FRAME_WIDTH: Bezel thickness (independent of warp)
//   - MASK_SIZE: RGB phosphor dot size (0.5 = fine, 1.0 = visible, 2.0+ = chunky)
//   - MASK_INTENSITY: Phosphor effect strength (0 = off, 1 = full)
//   - HIDPI_SCALE: Set to 2.0 for Retina displays
//   - GLOW_INTENSITY: Bloom effect strength
//   - FLARE_INTENSITY: Glass reflection brightness (0 = off)
//
// CREDITS:
//   Based on "bettercrt" shader:
//   - Original: https://www.shadertoy.com/view/WsVSzV (CC BY NC SA 3.0)
//
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Feature Switches (comment out to disable completely)
//-----------------------------------------------------------------------------

#define ENABLE_WARP              // CRT screen curvature (aspect-ratio aware)
#define ENABLE_FRAME             // 3D beveled frame (configurable width)
#define ENABLE_GLOW              // Bloom/glow effect
//#define ENABLE_SCANLINES       // Horizontal scan lines
#define ENABLE_DOT_MATRIX        // Shadow mask RGB phosphor dots (PC CRT style)
#define ENABLE_GLASS_FLARE       // Static glass reflection
#define ENABLE_CAR_LIGHTS        // Moving car light reflections
#define ENABLE_BG_DARKEN         // Background darkening

//-----------------------------------------------------------------------------
// Customizable Parameters
//-----------------------------------------------------------------------------

// CRT Screen Settings
const float WARP = 0.28;                  // Screen curvature (0 = flat, 1+ = very curved)
const float BORDER = 0.02;               // Frame border thickness
const float FRAME_TRANSPARENCY = 1;    // Frame opacity (0 = invisible, 1 = solid)
const float SCREEN_TRANSPARENCY = 1;   // Screen opacity

// Background Darkening
const float BACKGROUND_DARKEN = 0.85;      // Darken background (1.0 = none, 0 = black)
const float DARKEN_THRESHOLD = 0.25;      // Brightness threshold for darkening

// Glow/Bloom Settings
const float GLOW_THRESHOLD = 0.008;        // Min brightness to emit glow
const float GLOW_INTENSITY = 1.1;        // Glow strength
const float BRIGHT_BOOST = 1.8;          // Brightness multiplier for bright pixels

// Scanline Settings
const float SCANLINE_INTENSITY = 0.38;    // Scanline darkness (0 = off)
const float SCANLINE_DENSITY = 1.3;      // Scanline thickness

// Shadow Mask RGB Phosphor Settings
const float MASK_INTENSITY = 0.5;        // Phosphor effect strength (0 = off, 1 = full)
const float MASK_SIZE = 0.35;            // RGB dot size (0.5 = fine, 1.0 = visible, 2.0+ = chunky retro)

// HiDPI/Retina Settings
const float HIDPI_SCALE = 1.0;            // 1.0 = normal, 2.0 = Retina/HiDPI displays

// Frame 3D Effect Settings
const float FRAME_WIDTH = 0.005;           // Frame width independent of warp (0 = warp-only, 0.05 = thick)
const float FRAME_HIGHLIGHT = 0.88;       // Bevel highlight brightness
const float FRAME_SHADOW = 1.38;          // Bevel shadow darkness
const vec3 FRAME_COLOR = vec3(0.0, 0.0, 0.0);  // Base frame color (dark gray)

// Glass Flare Settings
const float FLARE_INTENSITY = 0.35;       // Flare brightness (0 = off)
const float FLARE_WIDTH = 0.58;           // Flare band width
const float FLARE_POSITION = 0.18;        // Flare position on diagonal (0-1)
const float FLARE_ANGLE = 1.0;            // Flare angle (1.0 = 45 degrees)

// Car Light Reflection Settings
const float CAR_LIGHT_INTENSITY = 0;   // Light spot brightness (0 = off)
const float CAR_LIGHT_SPEED = 0.88;       // Base speed multiplier
const float CAR_LIGHT_SIZE = 0.05;        // Size of light spots
const float CAR_LIGHT_SOFTNESS = 0.5;     // Spot edge softness (higher = softer)
const float CAR_LIGHT_SPEED_VAR = 1.;    // Speed variation between lights (0 = same speed, 1 = very different)

//-----------------------------------------------------------------------------
// Helper Functions
//-----------------------------------------------------------------------------

float getLuminance(vec3 c) {
    return dot(c, vec3(0.299, 0.587, 0.114));
}

//-----------------------------------------------------------------------------
// Bloom Sample Points (4 samples - cross pattern for performance)
//-----------------------------------------------------------------------------

#ifdef ENABLE_GLOW
const vec2[4] bloomSamples = vec2[4](
    vec2( 1.0,  0.0),
    vec2(-1.0,  0.0),
    vec2( 0.0,  1.0),
    vec2( 0.0, -1.0)
);
#endif

//-----------------------------------------------------------------------------
// Main Shader
//-----------------------------------------------------------------------------

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;

    // Aspect ratio for ultra-wide compensation
    float aspect = iResolution.x / iResolution.y;

    // Scale down to create border (only when FRAME is enabled)
#ifdef ENABLE_FRAME
    float totalBorder = BORDER + FRAME_WIDTH;
    // Compensate for aspect ratio so frame width looks uniform
    vec2 borderScale = vec2(totalBorder / aspect, totalBorder);
    uv = (uv - 0.5) / (1.0 - borderScale * 2.0) + 0.5;
#endif

#ifdef ENABLE_WARP
    // Apply CRT curvature warp with aspect ratio compensation
    vec2 dc = abs(0.5 - uv);
    dc *= dc;
    // Normalize warp strength by aspect ratio for uniform curvature
    float warpX = 0.3 * WARP / aspect;
    float warpY = 0.4 * WARP;
    uv.x -= 0.5; uv.x *= 1.0 + (dc.y * warpX); uv.x += 0.5;
    uv.y -= 0.5; uv.y *= 1.0 + (dc.x * warpY); uv.y += 0.5;
#endif

    // Anti-aliased edge calculation
    vec2 edgeWidth = fwidth(uv) * 2.0;
    float edgeX = smoothstep(0.0, edgeWidth.x, uv.x) * smoothstep(0.0, edgeWidth.x, 1.0 - uv.x);
    float edgeY = smoothstep(0.0, edgeWidth.y, uv.y) * smoothstep(0.0, edgeWidth.y, 1.0 - uv.y);
    float edge = edgeX * edgeY;

    // Render 3D frame if outside screen area
    if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
#ifdef ENABLE_FRAME
        float distLeft = max(0.0, -uv.x);
        float distRight = max(0.0, uv.x - 1.0);
        float distTop = max(0.0, uv.y - 1.0);
        float distBottom = max(0.0, -uv.y);

        // Bevel lighting (light source from bottom-left)
        float highlight = (distTop + distLeft) * FRAME_HIGHLIGHT;
        float shadow = (distBottom + distRight) * FRAME_SHADOW;
        float bevel = highlight - shadow;

        vec3 frameCol = FRAME_COLOR + bevel;
        fragColor = vec4(frameCol, FRAME_TRANSPARENCY);
#else
        fragColor = vec4(0.0, 0.0, 0.0, 0.0);
#endif
        return;
    }

    // Sample texture
    vec3 col = texture(iChannel0, uv).rgb;

    // Calculate luminance once
    float luminance = getLuminance(col);

#ifdef ENABLE_BG_DARKEN
    // Darken background while keeping text bright
    float darkenFactor = smoothstep(0.0, DARKEN_THRESHOLD, luminance);
    col = mix(col * BACKGROUND_DARKEN, col, darkenFactor);
#endif

    // Apply glow effect
    vec3 processedColor = col;

#ifdef ENABLE_GLOW
    if (luminance > GLOW_THRESHOLD) {
        processedColor *= BRIGHT_BOOST;
    } else {
        vec2 stepSize = vec2(2.0) / iResolution.xy;
        vec3 glow = vec3(0.0);
        for (int i = 0; i < 4; i++) {
            vec3 sampleCol = texture(iChannel0, uv + bloomSamples[i] * stepSize).rgb;
            float sampleLum = getLuminance(sampleCol);
            if (sampleLum > GLOW_THRESHOLD) {
                glow += sampleCol * 0.25 * GLOW_INTENSITY;
            }
        }
        processedColor += glow;
    }
#endif

    vec3 finalColor = processedColor;

#ifdef ENABLE_DOT_MATRIX
    // CRT shadow mask style - RGB dots in triangular/staggered pattern
    // MASK_SIZE: 0.5 = fine/subtle, 1.0 = visible, 2.0+ = chunky retro
    float scale = max(0.3, MASK_SIZE) * 3.0 / HIDPI_SCALE;
    vec2 pixelCoord = fragCoord / scale;

    // Cell coordinates - each cell contains one RGB triad
    float cellW = 3.0;   // Width of one RGB triad
    float cellH = 1.8;   // Height (staggered rows)

    // Determine which row we're in and apply horizontal offset for staggering
    int row = int(floor(pixelCoord.y / cellH));
    float offsetX = (mod(float(row), 2.0) == 1.0) ? cellW * 0.5 : 0.0;

    // Position within the cell
    float cellX = mod(pixelCoord.x + offsetX, cellW);
    float cellY = mod(pixelCoord.y, cellH);

    // Center of each RGB dot within the cell
    vec2 redCenter = vec2(0.5, 0.9);
    vec2 greenCenter = vec2(1.5, 0.9);
    vec2 blueCenter = vec2(2.5, 0.9);

    // Distance from each phosphor dot center
    float dotRadius = 0.5;
    float distR = length(vec2(cellX, cellY) - redCenter);
    float distG = length(vec2(cellX, cellY) - greenCenter);
    float distB = length(vec2(cellX, cellY) - blueCenter);

    // Soft circular dots with proper anti-aliasing
    float softness = 0.2;
    float dotR = smoothstep(dotRadius + softness, dotRadius - softness, distR);
    float dotG = smoothstep(dotRadius + softness, dotRadius - softness, distG);
    float dotB = smoothstep(dotRadius + softness, dotRadius - softness, distB);

    // RGB phosphor mask
    vec3 phosphorMask = vec3(dotR, dotG, dotB);

    // Blend: at 0 intensity = original, at 1 intensity = full phosphor effect
    vec3 maskedColor = finalColor * (phosphorMask * 0.9 + 0.1);
    finalColor = mix(finalColor, maskedColor, MASK_INTENSITY);
#endif

    finalColor = mix(vec3(0.0), finalColor, edge);

#ifdef ENABLE_SCANLINES
    // Apply warped scanlines
    vec2 warpedCoord2 = uv * iResolution.xy;
    float scanlineFreq = warpedCoord2.y / HIDPI_SCALE;
    float scanline = abs(sin(scanlineFreq) * SCANLINE_DENSITY * SCANLINE_INTENSITY);
    finalColor = mix(finalColor, vec3(0.0), scanline);
#endif

#ifdef ENABLE_GLASS_FLARE
    // Apply glass flare
    float diag = (1.0 - uv.x) * FLARE_ANGLE + uv.y;
    float flareCenter = FLARE_POSITION * (1.0 + FLARE_ANGLE);
    float flareDist = abs(diag - flareCenter);
    float flare = smoothstep(FLARE_WIDTH, 0.0, flareDist) * FLARE_INTENSITY;

    float flareFade = edge * smoothstep(0.0, 0.3, 1.0 - uv.x) * smoothstep(0.0, 0.3, uv.y);
    flare *= flareFade;

    finalColor += vec3(flare);
#endif

#ifdef ENABLE_CAR_LIGHTS
    // Apply car light reflections (moving light spots)
    float time = iTime * CAR_LIGHT_SPEED;

    // Create multiple light spots at different positions and speeds
    for (int i = 0; i < 4; i++) {
        float fi = float(i);
        float phase = fi * 1.57 + fi * fi * 0.3;  // Staggered timing

        // Each spot has different speed (using prime-like multipliers for less repetitive patterns)
        float speedMult[4] = float[4](1.0, 0.6, 1.4, 0.85);
        float speed = 0.3 * (1.0 + (speedMult[i] - 1.0) * CAR_LIGHT_SPEED_VAR);
        float t = fract(time * speed + phase);

        // Spot moves diagonally across screen (right-to-left, with slight vertical movement)
        float spotX = 1.3 - t * 1.8;
        float spotY = 0.3 + fi * 0.18 + sin(t * 3.14159) * 0.1;

        // Distance from spot center (circular)
        vec2 spotCenter = vec2(spotX, spotY);
        float dist = length(uv - spotCenter);

        // Soft circular spot with gaussian falloff
        float spot = exp(-dist * dist * CAR_LIGHT_SOFTNESS / (CAR_LIGHT_SIZE * CAR_LIGHT_SIZE));

        // Fade in/out at screen edges
        float edgeFade = smoothstep(0.0, 0.25, t) * smoothstep(1.0, 0.75, t);

        // Warm headlight colors (white to amber)
        vec3 lightColor = vec3(1.0, 0.92 - fi * 0.04, 0.8 - fi * 0.08);

        finalColor += lightColor * spot * edgeFade * CAR_LIGHT_INTENSITY * edge;
    }
#endif

    fragColor = vec4(finalColor, SCREEN_TRANSPARENCY);
}
