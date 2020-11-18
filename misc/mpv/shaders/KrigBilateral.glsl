// KrigBilateral by Shiandow
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 3.0 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with this library.

//!HOOK CHROMA
//!BIND HOOKED
//!BIND LUMA
//!SAVE LOWRES_Y
//!WIDTH LUMA.w
//!WHEN CHROMA.w LUMA.w <
//!DESC KrigBilateral Downscaling Y pass 1

#define offset      vec2(0,0)

#define axis 1

#define Kernel(x)   dot(vec3(0.42659, -0.49656, 0.076849), cos(vec3(0, 1, 2) * acos(-1.) * (x + 1.)))

vec4 hook() {
    // Calculate bounds
    float low  = ceil((LUMA_pos - CHROMA_pt) * LUMA_size - offset - 0.5)[axis];
    float high = floor((LUMA_pos + CHROMA_pt) * LUMA_size - offset - 0.5)[axis];

    float W = 0.0;
    vec4 avg = vec4(0);
    vec2 pos = LUMA_pos;

    for (float k = low; k <= high; k++) {
        pos[axis] = LUMA_pt[axis] * (k - offset[axis] + 0.5);
        float rel = (pos[axis] - LUMA_pos[axis])*CHROMA_size[axis];
        float w = Kernel(rel);

        vec4 y = textureGrad(LUMA_raw, pos, vec2(0.0), vec2(0.0)).xxxx * LUMA_mul;
        y.y *= y.y;
        avg += w * y;
        W += w;
    }
    avg /= W;
    avg.y = abs(avg.y - pow(avg.x, 2.0));
    return avg;
}

//!HOOK CHROMA
//!BIND HOOKED
//!BIND LOWRES_Y
//!SAVE LOWRES_Y
//!WHEN CHROMA.w LUMA.w <
//!DESC KrigBilateral Downscaling Y pass 2

#define offset      vec2(0,0)

#define axis 0

#define Kernel(x)   dot(vec3(0.42659, -0.49656, 0.076849), cos(vec3(0, 1, 2) * acos(-1.) * (x + 1.)))

vec4 hook() {
    // Calculate bounds
    float low  = ceil((LOWRES_Y_pos - CHROMA_pt) * LOWRES_Y_size - offset - 0.5)[axis];
    float high = floor((LOWRES_Y_pos + CHROMA_pt) * LOWRES_Y_size - offset - 0.5)[axis];

    float W = 0.0;
    vec4 avg = vec4(0);
    vec2 pos = LOWRES_Y_pos;

    for (float k = low; k <= high; k++) {
        pos[axis] = LOWRES_Y_pt[axis] * (k - offset[axis] + 0.5);
        float rel = (pos[axis] - LOWRES_Y_pos[axis])*CHROMA_size[axis];
        float w = Kernel(rel);

        vec4 y = textureGrad(LOWRES_Y_raw, pos, vec2(0.0), vec2(0.0)).xxxx * LOWRES_Y_mul;
        y.y *= y.y;
        avg += w * y;
        W += w;
    }
    avg /= W;
    avg.y = abs(avg.y - pow(avg.x, 2.0)) + LOWRES_Y_texOff(0).y;
    return avg;
}

//!HOOK CHROMA
//!BIND HOOKED
//!BIND LUMA
//!BIND LOWRES_Y
//!WIDTH LUMA.w
//!HEIGHT LUMA.h
//!WHEN CHROMA.w LUMA.w <
//!OFFSET ALIGN
//!DESC KrigBilateral Upscaling UV

// -- Convenience --
#define sqr(x)   dot(x,x)
#define bitnoise 1.0/(2.0*255.0)
#define noise    0.05//5.0*bitnoise
#define chromaOffset vec2(0.0, 0.0)

// -- Window Size --
#define taps 3
#define even (float(taps) - 2.0 * floor(float(taps) / 2.0) == 0.0)
#define minX int(1.0-ceil(float(taps)/2.0))
#define maxX int(floor(float(taps)/2.0))

#define Kernel(x) (cos(acos(-1.0)*(x)/float(taps))) // Hann kernel

// -- Input processing --
#define GetY(coord)  LOWRES_Y_tex(LOWRES_Y_pt*(pos+coord+vec2(0.5))).xy
#define GetUV(coord) CHROMA_tex(CHROMA_pt*(pos+coord+vec2(0.5))).xy

#define N (taps*taps - 1)

#define M(i,j) Mx[min(i,j)*N + max(i,j) - min(i,j)*(min(i,j)+1)/2]

#define C(i,j) (inversesqrt(1.0 + (X[i].y + X[j].y)/localVar) * exp(-0.5*(sqr(X[i].x - X[j].x)/(localVar + X[i].y + X[j].y) + sqr((coords[i] - coords[j])/radius))) + (X[i].x - y) * (X[j].x - y) / localVar)
#define c(i)   (inversesqrt(1.0 + X[i].y/localVar) * exp(-0.5*(sqr(X[i].x - y)/(localVar + X[i].y) + sqr((coords[i] - offset)/radius))))

vec4 hook() {
    vec2 pos = CHROMA_pos * HOOKED_size - chromaOffset - vec2(0.5);
    vec2 offset = pos - (even ? floor(pos) : round(pos));
    pos -= offset;

    vec2 coords[N+1];
    vec4 X[N+1];
    float y = LUMA_texOff(0).x;
    vec4 total = vec4(0);

    coords[0] = vec2(-1,-1); coords[1] = vec2(-1, 0); coords[2] = vec2(-1, 1);
    coords[3] = vec2( 0,-1); coords[4] = vec2( 0, 1); coords[5] = vec2( 1,-1);
    coords[6] = vec2( 1, 0); coords[7] = vec2( 1, 1); coords[8] = vec2( 0, 0);

    for (int i=0; i<N+1; i++) {
        X[i] = vec4(GetY(coords[i]), GetUV(coords[i]));
        vec2 w = clamp(1.5 - abs(coords[i] - offset), 0.0, 1.0);
        total += w.x*w.y*vec4(X[i].x, pow(X[i].x, 2.0), X[i].y, 1.0);
    }
    total.xyz /= total.w;
    float localVar = sqr(noise) + abs(total.y - pow(total.x, 2.0)) + total.z;
    float radius = 1.0;

    float Mx[N*(N+1)/2];
    float b[N];
    vec4 interp = X[N];

    b[0] = c(0) - c(N) - C(0,N) + C(N,N); M(0, 0) = C(0,0) - C(0,N) - C(0,N) + C(N,N); M(0, 1) = C(0,1) - C(1,N) - C(0,N) + C(N,N); M(0, 2) = C(0,2) - C(2,N) - C(0,N) + C(N,N); M(0, 3) = C(0,3) - C(3,N) - C(0,N) + C(N,N); M(0, 4) = C(0,4) - C(4,N) - C(0,N) + C(N,N); M(0, 5) = C(0,5) - C(5,N) - C(0,N) + C(N,N); M(0, 6) = C(0,6) - C(6,N) - C(0,N) + C(N,N); M(0, 7) = C(0,7) - C(7,N) - C(0,N) + C(N,N);
    b[1] = c(1) - c(N) - C(1,N) + C(N,N); M(1, 1) = C(1,1) - C(1,N) - C(1,N) + C(N,N); M(1, 2) = C(1,2) - C(2,N) - C(1,N) + C(N,N); M(1, 3) = C(1,3) - C(3,N) - C(1,N) + C(N,N); M(1, 4) = C(1,4) - C(4,N) - C(1,N) + C(N,N); M(1, 5) = C(1,5) - C(5,N) - C(1,N) + C(N,N); M(1, 6) = C(1,6) - C(6,N) - C(1,N) + C(N,N); M(1, 7) = C(1,7) - C(7,N) - C(1,N) + C(N,N);
    b[2] = c(2) - c(N) - C(2,N) + C(N,N); M(2, 2) = C(2,2) - C(2,N) - C(2,N) + C(N,N); M(2, 3) = C(2,3) - C(3,N) - C(2,N) + C(N,N); M(2, 4) = C(2,4) - C(4,N) - C(2,N) + C(N,N); M(2, 5) = C(2,5) - C(5,N) - C(2,N) + C(N,N); M(2, 6) = C(2,6) - C(6,N) - C(2,N) + C(N,N); M(2, 7) = C(2,7) - C(7,N) - C(2,N) + C(N,N);
    b[3] = c(3) - c(N) - C(3,N) + C(N,N); M(3, 3) = C(3,3) - C(3,N) - C(3,N) + C(N,N); M(3, 4) = C(3,4) - C(4,N) - C(3,N) + C(N,N); M(3, 5) = C(3,5) - C(5,N) - C(3,N) + C(N,N); M(3, 6) = C(3,6) - C(6,N) - C(3,N) + C(N,N); M(3, 7) = C(3,7) - C(7,N) - C(3,N) + C(N,N);
    b[4] = c(4) - c(N) - C(4,N) + C(N,N); M(4, 4) = C(4,4) - C(4,N) - C(4,N) + C(N,N); M(4, 5) = C(4,5) - C(5,N) - C(4,N) + C(N,N); M(4, 6) = C(4,6) - C(6,N) - C(4,N) + C(N,N); M(4, 7) = C(4,7) - C(7,N) - C(4,N) + C(N,N);
    b[5] = c(5) - c(N) - C(5,N) + C(N,N); M(5, 5) = C(5,5) - C(5,N) - C(5,N) + C(N,N); M(5, 6) = C(5,6) - C(6,N) - C(5,N) + C(N,N); M(5, 7) = C(5,7) - C(7,N) - C(5,N) + C(N,N);
    b[6] = c(6) - c(N) - C(6,N) + C(N,N); M(6, 6) = C(6,6) - C(6,N) - C(6,N) + C(N,N); M(6, 7) = C(6,7) - C(7,N) - C(6,N) + C(N,N);
    b[7] = c(7) - c(N) - C(7,N) + C(N,N); M(7, 7) = C(7,7) - C(7,N) - C(7,N) + C(N,N);

    b[1] -= b[0] * M(1, 0) / M(0, 0); M(1, 1) -= M(0, 1) * M(1, 0) / M(0, 0); M(1, 2) -= M(0, 2) * M(1, 0) / M(0, 0); M(1, 3) -= M(0, 3) * M(1, 0) / M(0, 0); M(1, 4) -= M(0, 4) * M(1, 0) / M(0, 0); M(1, 5) -= M(0, 5) * M(1, 0) / M(0, 0); M(1, 6) -= M(0, 6) * M(1, 0) / M(0, 0); M(1, 7) -= M(0, 7) * M(1, 0) / M(0, 0);
    b[2] -= b[0] * M(2, 0) / M(0, 0); M(2, 2) -= M(0, 2) * M(2, 0) / M(0, 0); M(2, 3) -= M(0, 3) * M(2, 0) / M(0, 0); M(2, 4) -= M(0, 4) * M(2, 0) / M(0, 0); M(2, 5) -= M(0, 5) * M(2, 0) / M(0, 0); M(2, 6) -= M(0, 6) * M(2, 0) / M(0, 0); M(2, 7) -= M(0, 7) * M(2, 0) / M(0, 0);
    b[3] -= b[0] * M(3, 0) / M(0, 0); M(3, 3) -= M(0, 3) * M(3, 0) / M(0, 0); M(3, 4) -= M(0, 4) * M(3, 0) / M(0, 0); M(3, 5) -= M(0, 5) * M(3, 0) / M(0, 0); M(3, 6) -= M(0, 6) * M(3, 0) / M(0, 0); M(3, 7) -= M(0, 7) * M(3, 0) / M(0, 0);
    b[4] -= b[0] * M(4, 0) / M(0, 0); M(4, 4) -= M(0, 4) * M(4, 0) / M(0, 0); M(4, 5) -= M(0, 5) * M(4, 0) / M(0, 0); M(4, 6) -= M(0, 6) * M(4, 0) / M(0, 0); M(4, 7) -= M(0, 7) * M(4, 0) / M(0, 0);
    b[5] -= b[0] * M(5, 0) / M(0, 0); M(5, 5) -= M(0, 5) * M(5, 0) / M(0, 0); M(5, 6) -= M(0, 6) * M(5, 0) / M(0, 0); M(5, 7) -= M(0, 7) * M(5, 0) / M(0, 0);
    b[6] -= b[0] * M(6, 0) / M(0, 0); M(6, 6) -= M(0, 6) * M(6, 0) / M(0, 0); M(6, 7) -= M(0, 7) * M(6, 0) / M(0, 0);
    b[7] -= b[0] * M(7, 0) / M(0, 0); M(7, 7) -= M(0, 7) * M(7, 0) / M(0, 0);

    b[2] -= b[1] * M(2, 1) / M(1, 1); M(2, 2) -= M(1, 2) * M(2, 1) / M(1, 1); M(2, 3) -= M(1, 3) * M(2, 1) / M(1, 1); M(2, 4) -= M(1, 4) * M(2, 1) / M(1, 1); M(2, 5) -= M(1, 5) * M(2, 1) / M(1, 1); M(2, 6) -= M(1, 6) * M(2, 1) / M(1, 1); M(2, 7) -= M(1, 7) * M(2, 1) / M(1, 1);
    b[3] -= b[1] * M(3, 1) / M(1, 1); M(3, 3) -= M(1, 3) * M(3, 1) / M(1, 1); M(3, 4) -= M(1, 4) * M(3, 1) / M(1, 1); M(3, 5) -= M(1, 5) * M(3, 1) / M(1, 1); M(3, 6) -= M(1, 6) * M(3, 1) / M(1, 1); M(3, 7) -= M(1, 7) * M(3, 1) / M(1, 1);
    b[4] -= b[1] * M(4, 1) / M(1, 1); M(4, 4) -= M(1, 4) * M(4, 1) / M(1, 1); M(4, 5) -= M(1, 5) * M(4, 1) / M(1, 1); M(4, 6) -= M(1, 6) * M(4, 1) / M(1, 1); M(4, 7) -= M(1, 7) * M(4, 1) / M(1, 1);
    b[5] -= b[1] * M(5, 1) / M(1, 1); M(5, 5) -= M(1, 5) * M(5, 1) / M(1, 1); M(5, 6) -= M(1, 6) * M(5, 1) / M(1, 1); M(5, 7) -= M(1, 7) * M(5, 1) / M(1, 1);
    b[6] -= b[1] * M(6, 1) / M(1, 1); M(6, 6) -= M(1, 6) * M(6, 1) / M(1, 1); M(6, 7) -= M(1, 7) * M(6, 1) / M(1, 1);
    b[7] -= b[1] * M(7, 1) / M(1, 1); M(7, 7) -= M(1, 7) * M(7, 1) / M(1, 1);

    b[3] -= b[2] * M(3, 2) / M(2, 2); M(3, 3) -= M(2, 3) * M(3, 2) / M(2, 2); M(3, 4) -= M(2, 4) * M(3, 2) / M(2, 2); M(3, 5) -= M(2, 5) * M(3, 2) / M(2, 2); M(3, 6) -= M(2, 6) * M(3, 2) / M(2, 2); M(3, 7) -= M(2, 7) * M(3, 2) / M(2, 2);
    b[4] -= b[2] * M(4, 2) / M(2, 2); M(4, 4) -= M(2, 4) * M(4, 2) / M(2, 2); M(4, 5) -= M(2, 5) * M(4, 2) / M(2, 2); M(4, 6) -= M(2, 6) * M(4, 2) / M(2, 2); M(4, 7) -= M(2, 7) * M(4, 2) / M(2, 2);
    b[5] -= b[2] * M(5, 2) / M(2, 2); M(5, 5) -= M(2, 5) * M(5, 2) / M(2, 2); M(5, 6) -= M(2, 6) * M(5, 2) / M(2, 2); M(5, 7) -= M(2, 7) * M(5, 2) / M(2, 2);
    b[6] -= b[2] * M(6, 2) / M(2, 2); M(6, 6) -= M(2, 6) * M(6, 2) / M(2, 2); M(6, 7) -= M(2, 7) * M(6, 2) / M(2, 2);
    b[7] -= b[2] * M(7, 2) / M(2, 2); M(7, 7) -= M(2, 7) * M(7, 2) / M(2, 2);

    b[4] -= b[3] * M(4, 3) / M(3, 3); M(4, 4) -= M(3, 4) * M(4, 3) / M(3, 3); M(4, 5) -= M(3, 5) * M(4, 3) / M(3, 3); M(4, 6) -= M(3, 6) * M(4, 3) / M(3, 3); M(4, 7) -= M(3, 7) * M(4, 3) / M(3, 3);
    b[5] -= b[3] * M(5, 3) / M(3, 3); M(5, 5) -= M(3, 5) * M(5, 3) / M(3, 3); M(5, 6) -= M(3, 6) * M(5, 3) / M(3, 3); M(5, 7) -= M(3, 7) * M(5, 3) / M(3, 3);
    b[6] -= b[3] * M(6, 3) / M(3, 3); M(6, 6) -= M(3, 6) * M(6, 3) / M(3, 3); M(6, 7) -= M(3, 7) * M(6, 3) / M(3, 3);
    b[7] -= b[3] * M(7, 3) / M(3, 3); M(7, 7) -= M(3, 7) * M(7, 3) / M(3, 3);

    b[5] -= b[4] * M(5, 4) / M(4, 4); M(5, 5) -= M(4, 5) * M(5, 4) / M(4, 4); M(5, 6) -= M(4, 6) * M(5, 4) / M(4, 4); M(5, 7) -= M(4, 7) * M(5, 4) / M(4, 4);
    b[6] -= b[4] * M(6, 4) / M(4, 4); M(6, 6) -= M(4, 6) * M(6, 4) / M(4, 4); M(6, 7) -= M(4, 7) * M(6, 4) / M(4, 4);
    b[7] -= b[4] * M(7, 4) / M(4, 4); M(7, 7) -= M(4, 7) * M(7, 4) / M(4, 4);

    b[6] -= b[5] * M(6, 5) / M(5, 5); M(6, 6) -= M(5, 6) * M(6, 5) / M(5, 5); M(6, 7) -= M(5, 7) * M(6, 5) / M(5, 5);
    b[7] -= b[5] * M(7, 5) / M(5, 5); M(7, 7) -= M(5, 7) * M(7, 5) / M(5, 5);

    b[7] -= b[6] * M(7, 6) / M(6, 6); M(7, 7) -= M(6, 7) * M(7, 6) / M(6, 6);

    b[N-1-0] /= M(N-1-0, N-1-0);
    interp += b[N-1-0] * (X[N-1-0] - X[N]);

    b[N-1-1] -= M(N-1-1, 7) * b[7]; b[N-1-1] /= M(N-1-1, N-1-1);
    interp += b[N-1-1] * (X[N-1-1] - X[N]);

    b[N-1-2] -= M(N-1-2, 6) * b[6]; b[N-1-2] -= M(N-1-2, 7) * b[7]; b[N-1-2] /= M(N-1-2, N-1-2);
    interp += b[N-1-2] * (X[N-1-2] - X[N]);

    b[N-1-3] -= M(N-1-3, 5) * b[5]; b[N-1-3] -= M(N-1-3, 6) * b[6]; b[N-1-3] -= M(N-1-3, 7) * b[7]; b[N-1-3] /= M(N-1-3, N-1-3);
    interp += b[N-1-3] * (X[N-1-3] - X[N]);

    b[N-1-4] -= M(N-1-4, 4) * b[4]; b[N-1-4] -= M(N-1-4, 5) * b[5]; b[N-1-4] -= M(N-1-4, 6) * b[6]; b[N-1-4] -= M(N-1-4, 7) * b[7]; b[N-1-4] /= M(N-1-4, N-1-4);
    interp += b[N-1-4] * (X[N-1-4] - X[N]);

    b[N-1-5] -= M(N-1-5, 3) * b[3]; b[N-1-5] -= M(N-1-5, 4) * b[4]; b[N-1-5] -= M(N-1-5, 5) * b[5]; b[N-1-5] -= M(N-1-5, 6) * b[6]; b[N-1-5] -= M(N-1-5, 7) * b[7]; b[N-1-5] /= M(N-1-5, N-1-5);
    interp += b[N-1-5] * (X[N-1-5] - X[N]);

    b[N-1-6] -= M(N-1-6, 2) * b[2]; b[N-1-6] -= M(N-1-6, 3) * b[3]; b[N-1-6] -= M(N-1-6, 4) * b[4]; b[N-1-6] -= M(N-1-6, 5) * b[5]; b[N-1-6] -= M(N-1-6, 6) * b[6]; b[N-1-6] -= M(N-1-6, 7) * b[7]; b[N-1-6] /= M(N-1-6, N-1-6);
    interp += b[N-1-6] * (X[N-1-6] - X[N]);

    b[N-1-7] -= M(N-1-7, 1) * b[1]; b[N-1-7] -= M(N-1-7, 2) * b[2]; b[N-1-7] -= M(N-1-7, 3) * b[3]; b[N-1-7] -= M(N-1-7, 4) * b[4]; b[N-1-7] -= M(N-1-7, 5) * b[5]; b[N-1-7] -= M(N-1-7, 6) * b[6]; b[N-1-7] -= M(N-1-7, 7) * b[7]; b[N-1-7] /= M(N-1-7, N-1-7);
    interp += b[N-1-7] * (X[N-1-7] - X[N]);

    return interp.zwxx;
}
