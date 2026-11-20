/// If enabled, attmept to fold single-group overlay groups into the parent atom. This avoids the alist, but makes overlay operations take a bit more CPU time. These are very common, so this should be a net win.
#define OVR_ENABLE_MONAD_COMPRESSION

#ifdef OVR_ENABLE_MONAD_COMPRESSION

/// Does this atom currently have managed overlays?
#define HAS_MANAGED_OVERLAYS(atom) (atom.simple_overlays || atom.grouped_overlays || atom.grouped_overlays_monad_id)
/// Does this atom have an overlay group of this name?
#define HAS_OVERLAY_GROUP(TGT, NAME) ( ((TGT)?:grouped_overlays_monad_id == (NAME)) || ((NAME) in (TGT):grouped_overlays) )
/// Get the overlay group value of this name, if it exists. May be a single value or a list. Does not copy!
#define GET_OVERLAY_GROUP(TGT, NAME) ( ((TGT)?:grouped_overlays_monad_id == (NAME)) ? ((TGT).grouped_overlays_monad_list) : ((TGT):grouped_overlays?[NAME]) )

#else

/// Does this atom currently have managed overlays?
#define HAS_MANAGED_OVERLAYS(atom) (atom.simple_overlays || atom.grouped_overlays)
/// Does this atom have an overlay group of this name?
#define HAS_OVERLAY_GROUP(TGT, NAME) ((NAME) in (TGT):grouped_overlays)
/// Get the overlay group value of this name, if it exists. May be a single value or a list. Does not copy!
#define GET_OVERLAY_GROUP(TGT, NAME) ((TGT):grouped_overlays?[NAME])

#endif

// Overlay group IDs.

#define OVRGR_AO_REG "AO"	//! Standard turf AO.
#define OVRGR_AO_Z "Z-AO"	//! Z-AO for Z-Mimic depth cues.
#define OVRGR_AO_MID "AO Z-Midspan"	//! Z-Mimic false AO for deep holes.
