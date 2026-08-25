// -- SSao --

#define WALL_AO_ALPHA 80	//! Alpha of AO directly attached to walls.
#define WALL_SECONDARY_AO_ALPHA 80	//! Alpha of wall-AO being copied by ZM.
#define Z_AO_ALPHA 120	//! Alpha of Z-hole depth AO.
#define Z_AO_SECONDARY_ALPHA 60	//! Alpha of Z-hole depth AO being copied by ZM.

#define AO_UPDATE_NONE 0
#define AO_UPDATE_OVERLAY 1
#define AO_UPDATE_REBUILD 2

// If ao_neighbors equals this, no AO shadows are present.
#define AO_ALL_NEIGHBORS 1910

// If defined, integrate with the lighting engine and use its opacity value. Otherwise a simple turf opacity check is used. This may cause visual artifacts with opaque non-square movables.
//#define AO_USE_LIGHTING_OPACITY

#ifdef AO_USE_LIGHTING_OPACITY
#define AO_TURF_CHECK(T) (!T.has_opaque_atom || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.has_opaque_atom)
#else
#define AO_TURF_CHECK(T) (!T.density || !T.opacity || !T.permit_ao)
#define AO_SELF_CHECK(T) (!T.density && !T.opacity)
#endif

#define AO_Z_SELF_CHECK(T) ((T.z_flags & (ZM_MIMIC_BELOW | ZM_MIMIC_NO_ZAO)) == ZM_MIMIC_BELOW)
