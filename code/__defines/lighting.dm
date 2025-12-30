#define LIGHTING_INTERVAL       1     // Frequency, in 1/10ths of a second, of the lighting process.

#define LIGHTING_HEIGHT         1 // height off the ground of light sources on the pseudo-z-axis, you should probably leave this alone
#define LIGHTING_Z_FACTOR       10 // Z diff is multiplied by this and LIGHTING_HEIGHT to get the final height of a light source. Affects how much darker A Z light gets with each level transitioned.
#define LIGHTING_ROUND_VALUE    (1 / 200) //Value used to round lumcounts, values smaller than 1/255 don't matter (if they do, thanks sinking points), greater values will make lighting less precise, but in turn increase performance, VERY SLIGHTLY.

#define LIGHTING_ICON 'icons/effects/lighting_overlay.dmi' // icon used for lighting shading effects
#define LIGHTING_BASE_ICON_STATE "matrix"	// icon_state used for normal color-matrix based lighting overlays.
#define LIGHTING_STATION_ICON_STATE "tubedefault"	// icon_state used for lighting overlays that are just displaying standard station lighting.
#define LIGHTING_DARKNESS_ICON_STATE "black"	// icon_state used for lighting overlays with no luminosity.
#define LIGHTING_TRANSPARENT_ICON_STATE "blank"

// This is purely used as a threshold for 'is this turf probably dark' to avoid floating point nonsense.
#define LIGHTING_SOFT_THRESHOLD 0.001
#define LIGHTING_BLOCKED_FACTOR 0.5	// How much the range of a directional light will be reduced while facing a wall.

// If defined, instant updates will be used whenever server load permits. Otherwise queued updates are always used.
#define USE_INTELLIGENT_LIGHTING_UPDATES

// mostly identical to below, but doesn't make sure T is valid first. Should only be used by lighting code.
#define TURF_IS_DYNAMICALLY_LIT_UNSAFE(T) ((T:dynamic_lighting && T:loc:dynamic_lighting))
#define TURF_IS_DYNAMICALLY_LIT(T) (isturf(T) && TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))

// Note: this does not imply the above, a turf can have ambient light without being dynamically lit.
#define TURF_IS_AMBIENT_LIT_UNSAFE(T) (T:ambient_active)
#define TURF_IS_AMBIENT_LIT(T) (isturf(T) && TURF_IS_AMBIENT_LIT_UNSAFE(T))

// If I were you I'd leave this alone.
#define LIGHTING_BASE_MATRIX \
	list            \
	(               \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		1, 1, 1, 0, \
		0, 0, 0, 1  \
	)               \

// Helpers so we can (more easily) control the colour matrices.
#define CL_MATRIX_RR 1
#define CL_MATRIX_RG 2
#define CL_MATRIX_RB 3
#define CL_MATRIX_RA 4
#define CL_MATRIX_GR 5
#define CL_MATRIX_GG 6
#define CL_MATRIX_GB 7
#define CL_MATRIX_GA 8
#define CL_MATRIX_BR 9
#define CL_MATRIX_BG 10
#define CL_MATRIX_BB 11
#define CL_MATRIX_BA 12
#define CL_MATRIX_AR 13
#define CL_MATRIX_AG 14
#define CL_MATRIX_AB 15
#define CL_MATRIX_AA 16
#define CL_MATRIX_CR 17
#define CL_MATRIX_CG 18
#define CL_MATRIX_CB 19
#define CL_MATRIX_CA 20

// Higher numbers override lower.
#define LIGHTING_NO_UPDATE 0
#define LIGHTING_VIS_UPDATE 1
#define LIGHTING_CHECK_UPDATE 2
#define LIGHTING_FORCE_UPDATE 3

// This color of overlay is very common - most of the station is this color when lit fully.
// Tube lights are a bluish-white, so we can't just assume 1-1-1 is full-illumination.
// -- If you want to change these, find them *by checking in-game*, just converting tubes' RGB color into floats will not work!
#define LIGHTING_DEFAULT_TUBE_R 0.96
#define LIGHTING_DEFAULT_TUBE_G 1
#define LIGHTING_DEFAULT_TUBE_B 1

// Some angle presets for directional lighting.
#define LIGHT_OMNI null
#define LIGHT_SEMI 180
#define LIGHT_WIDE 90
#define LIGHT_NARROW 45
