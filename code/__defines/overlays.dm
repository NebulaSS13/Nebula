/// Does this atom currently have managed overlays?
#define HAS_MANAGED_OVERLAYS(atom) (atom.simple_overlays || atom.grouped_overlays)
#define HAS_OVERLAY_GROUP(TGT, NAME) ((NAME) in (TGT):grouped_overlays)
#define GET_OVERLAY_GROUP(TGT, NAME) ((TGT):grouped_overlays?[NAME])

// Overlay group IDs.

#define OVRGR_AO_REG "AO"	//! Standard turf AO.
#define OVRGR_AO_Z "Z-AO"	//! Z-AO for Z-Mimic depth cues.
#define OVRGR_AO_MID "AO Z-Midspan"	//! Z-Mimic false AO for deep holes.
