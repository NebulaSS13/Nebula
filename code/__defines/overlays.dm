/// Does this atom currently have managed overlays?
#define HAS_MANAGED_OVERLAYS(atom) (atom.simple_overlays || atom.grouped_overlays)
#define HAS_OVERLAY_GROUP(TGT, NAME) ((NAME) in (TGT):grouped_overlays)
#define GET_OVERLAY_GROUP(TGT, NAME) ((TGT):grouped_overlays?[NAME])
