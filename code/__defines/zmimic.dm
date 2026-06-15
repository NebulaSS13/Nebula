/// Enable extra ZM debug logs -- these are useful for diagnosing layering issues, but they're potentially expensive.
// #define ZM_ENH_DEBUG

#ifdef ZM_ENH_DEBUG

#define ZM_DEBUG_LOG(X...) log_debug(X)

#else

#define ZM_DEBUG_LOG(X...)

#endif

// end ZM debug

#define ZM_DESTRUCTION_TIMER(TARGET, REASON) addtimer(CALLBACK(TARGET, TYPE_PROC_REF(/atom/movable/openspace/mimic, timeout), __FILE__, __LINE__, REASON), 10 SECONDS, TIMER_STOPPABLE)

#define TURF_IS_MIMIC(T) (isturf(T) && (T:z_flags & ZM_MIMIC_BELOW))	//! Is this a full Z-turf?
#define TURF_IS_MIMIC_BOUNDARY(T) (isturf(T) && (T:z_flags & ZM_BOUNDARY))
#define TURF_IS_MIMICKING(T) (isturf(T) && (T:z_flags & (ZM_MIMIC_BELOW | ZM_BOUNDARY)))	//! Is this turf participating in Z-mimic?
#define CHECK_OO_EXISTENCE(OO) if (OO && !MOVABLE_IS_ON_ZTURF(OO) && !OO.destruction_timer) { OO.destruction_timer = ZM_DESTRUCTION_TIMER(OO, "COE"); }
#define UPDATE_OO_IF_PRESENT CHECK_OO_EXISTENCE(bound_overlay); if (bound_overlay) { update_above(); }
#define ZM_DIFF_HIDE_STATE(CALC, FLAG, TARGET) (CALC) ? (TARGET.hidden | FLAG) : (TARGET.hidden & ~FLAG)

// I do not apologize.

// These aren't intended to be used anywhere else, they just can't be undef'd because DM is dum.
// M: origin movable; TREF: origin loc; VTR: variable to read; F: flag to test
#define ZM_INTERNAL_SCAN_LOOKAHEAD(M,TREF,VTR,F) ((get_step(TREF, M:dir)?:VTR & F) || (get_step(TREF, turn(M:dir, 180))?:VTR & F))
#define ZM_INTERNAL_SCAN_LOOKBESIDE(M,TREF,VTR,F) ((get_step(TREF, turn(M:dir, 90))?:VTR & F) || (get_step(TREF, turn(M:dir, -90))?:VTR & F))

/// Is this movable visible from a turf that is mimicking below? Note: this does not necessarily mean *directly* below.
#define MOVABLE_IS_BELOW_ZTURF(M) (\
	isturf(M:loc) && (TURF_IS_MIMICKING(M:loc:above) \
	|| ((M:z_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, M, above?:z_flags, (ZM_MIMIC_BELOW | ZM_BOUNDARY)))  \
	|| ((M:z_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, M, above?:z_flags, (ZM_MIMIC_BELOW | ZM_BOUNDARY)))) \
)

/// Is this movable located on a turf that is mimicking below? Note: this does not necessarily mean *directly* on.
#define MOVABLE_IS_ON_ZTURF(M) (\
	(TURF_IS_MIMICKING(M:loc) \
	|| ((M:z_flags & ZMM_LOOKAHEAD) && ZM_INTERNAL_SCAN_LOOKAHEAD(M, M, z_flags, (ZM_MIMIC_BELOW | ZM_BOUNDARY))) \
	|| ((M:z_flags & ZMM_LOOKBESIDE) && ZM_INTERNAL_SCAN_LOOKBESIDE(M, M, z_flags, (ZM_MIMIC_BELOW | ZM_BOUNDARY)))) \
)

/* Don't copy:
	- (q)deleted objects
	- Explicitly ignored objects
	- Always-invisible atoms
*/
#define MOVABLE_SHALL_MIMIC(AM) (!QDELETED(AM) && !(AM.z_flags & ZMM_IGNORE) && AM.invisibility != INVISIBILITY_ABSTRACT)

// Turf MZ flags.
#define ZM_MIMIC_BELOW     1	//! If this turf should mimic the turf on the Z below.
#define ZM_MIMIC_OVERWRITE 2	//! If this turf is Z-mimicking, overwrite the turf's appearance instead of using a movable. This is faster, but means the turf cannot have its own appearance (say, edges or a translucent sprite).
#define ZM_ALLOW_LIGHTING  4	//! If this turf should permit passage of lighting.
#define ZM_ALLOW_ATMOS     8	//! If this turf permits passage of air.
#define ZM_MIMIC_NO_AO    16	//! If the turf shouldn't apply regular turf AO and only do Z-mimic AO.
#define ZM_NO_OCCLUDE     32	//! Don't occlude below atoms if we're a non-mimic z-turf.
#define ZM_OVERRIDE       64	//! Copy only z_appearance or baseturf and bail, do not attempt to copy movables. This is significantly cheaper and allows you to override the mimic, but results in movables not being visible. This also terminates the Z-stack for purposes of ZM invariants.
#define ZM_NO_SHADOW     128	//! If this turf is being copied, don't darken the shadower.
#define ZM_BOUNDARY      256	//! Internal use. Partially mimic the turf: allow creation of movables, but do not copy the actual turf. Movables are hidden from rightclick.
#define ZM_HIDE_ATOMS    512	//! If this turf is considered opaque to mouse clicks, also hide below mimics from the right-click menu. This makes it harder to examine atoms below, however.

// Convenience flags.
#define ZM_MIMIC_DEFAULTS (ZM_MIMIC_BELOW|ZM_ALLOW_LIGHTING)	//! Common defaults for zturfs.
#define ZMM_WIDE_LOAD (ZMM_LOOKAHEAD | ZMM_LOOKBESIDE)	//! Atom is big and needs to scan one extra turf in both X and Y. This only extends the range by one turf. Cheap, but not free.

/// Preset: you're creating a hole in the ground. No icon, nothing to cast shadows on. Just a hole.
#define ZM_MIMIC_PRESET_HOLE (ZM_MIMIC_DEFAULTS | ZM_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS)
/// Preset: you're creating a hole in the ground with a border. This turf has an icon, but you want to be able to click things in the hole like with a regular Z-hole.
#define ZM_MIMIC_PRESET_HOLE_WITH_BORDER (ZM_MIMIC_DEFAULTS | ZM_NO_OCCLUDE | ZM_ALLOW_ATMOS)
/// Preset: you're creating a turf with translucent accents (like glass flooring). This will block clicks even where alpha on the icon is 0, add MIMIC_NO_OCCLUDE if this is unwanted.
#define ZM_MIMIC_PRESET_TRANSLUCENT_TURF (ZM_MIMIC_DEFAULTS)

/// Flags that require layering resets when a movable moves between turfs with different values for.
#define ZM_STATEFUL_MIMIC_FLAGS (0)
/// Flags that persist across changeturf.
#define ZM_INFECTIOUS_MIMIC_FLAGS (ZM_BOUNDARY|ZM_OVERRIDE)	// Hopefully I don't regret making OVERRIDE sticky.

// ZM hide state flags for simplicity of logic.
#define ZM_HIDE_BOUNDARY 1	//! This mimic is being hidden by its parent being a boundary.
#define ZM_HIDE_NONMIMIC 2	//! This mimic is being hidden by its parent not being a mimic.
#define ZM_HIDE_OPAQUE   4	//! This mimic is being hidden by its parent having mouse_opacity set with MIMIC_HIDE_ATOMS active.

// For debug purposes, should contain the above defines in ascending order.
var/list/mimic_defines = list(
	"ZM_MIMIC_BELOW",
	"ZM_MIMIC_OVERWRITE",
	"ZM_ALLOW_LIGHTING",
	"ZM_ALLOW_ATMOS",
	"ZM_MIMIC_NO_AO",
	"ZM_NO_OCCLUDE",
	"ZM_OVERRIDE",
	"ZM_NO_SHADOW",
	"ZM_BOUNDARY",
	"ZM_HIDE_ATOMS"
)

// Movable flags.
#define ZMM_IGNORE        BITFLAG(0)	//! Do not copy this movable.
#define ZMM_MANGLE_PLANES BITFLAG(1)	//! Check this movable's overlays/underlays for explicit plane use and mangle for compatibility with Z-Mimic. If you're using emissive overlays, you probably should be using this flag. Expensive, only use if necessary.
#define ZMM_LOOKAHEAD     BITFLAG(2)	//! Look one turf ahead and one turf back when considering z-turfs that might be seeing this atom. Cheap, but not free.
#define ZMM_LOOKBESIDE    BITFLAG(3)	//! Look one turf beside (left/right) when considering z-turfs that might be seeing this atom. Cheap, but not free.
