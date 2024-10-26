// Shadertoy code
///// https://www.shadertoy.com/view/4XBfW3 /////

const float Zoom = 1.0f;

// Change this to how many ever you want
float Positions[] = float[](Zoom*0.3, Zoom*0.7f, Zoom*0.5f );
float Phases[] = float[](0.0,0.0);
int Count = 3;

float ScreenPosition = 0.3f;
float Lambda = 0.00625; // For red light, can change it to anything

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec2 R = iResolution.xy;
    vec2 uv = (2.0 * fragCoord - R) / min(R.x, R.y);
    uv = uv * 0.5f + 0.5f; uv *= Zoom;
    float PhaseShift = -8.*iTime+(3.14159/2.);  
    float Amplitude = 0.0f;
    float B = 0.;
    float FlatAmplitude = sin(PhaseShift + uv.x / Lambda);
    for (int i = 0; i < Count; i++) {
        Amplitude += sin(PhaseShift + distance(uv, vec2(ScreenPosition,Positions[i]))/Lambda);
        B = max(B, pow(min(smoothstep(0., 1., abs(uv.x - ScreenPosition - 0.05f) * 32.) / smoothstep(0., 1., abs(abs(uv.y-(Positions[i])) ) * 32.), 1.),32.));
    }
    
    Amplitude = mix(FlatAmplitude, Amplitude, smoothstep(0., 1., clamp(uv.x -0.01-ScreenPosition, 0.0, 1.0) * 15.));
    Amplitude /= float(mix(1., float(Count), smoothstep(0., 1., clamp(uv.x -0.01-ScreenPosition, 0.0, 1.0) * 15.)));
    Amplitude = Amplitude * 0.5f + 0.5f;
    Amplitude = pow(Amplitude, 2.0f);  Amplitude *= B;
    fragColor = vec4( mix(vec3(0.,0.,0.), vec3(1.,1.,1.), Amplitude), 1.0);
}