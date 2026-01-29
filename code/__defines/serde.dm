#define SERDE_HINT_FINISHED 1
#define SERDE_HINT_POSTINIT 2

#define SERDE_REAGENT_LIST "_reagent_list"
#define SERDE_REAGENT_VOLUME "_reagent_volume"

#define SERIALIZE_VALUE(V, T, VAL) .[nameof(T::V)] = VAL;
#define SERIALIZE(V, T) SERIALIZE_VALUE(V, T, V)
#define SERIALIZE_IF_MODIFIED(V, T) if(V != initial(V)) { SERIALIZE_VALUE(V, T, V) }
#define SERIALIZE_TYPE_IF_MODIFIED(V, T) if(V != initial(V)) { SERIALIZE_VALUE(V, T, "[V]") }
#define SERIALIZE_DECL_IF_MODIFIED(V, T) if((isnull(V) && !isnull(initial(V))) || ((istext(V) || istype(V, /decl) || ispath(V, /decl)) && !DECLS_ARE_EQUIVALENT(V, initial(V)))) { var/decl/__D = RESOLVE_TO_DECL(V); SERIALIZE_VALUE(V, T, __D?.uid) }
#define SERIALIZE_DECL_LIST(V, T) if(islist(V)) { var/list/__decl_uids = list(); for(var/decl/__decl in V) { __decl_uids += __decl.uid }; SERIALIZE_VALUE(V, T, __decl_uids) }
#define SERIALIZE_REAGENTS(V, T, I) if(istype(V, /datum/reagents)) {                                                       \
	.[I + SERDE_REAGENT_VOLUME] = UNLINT(V.maximum_volume);                                                                \
	if(UNLINT(V.total_volume)) {                                                                                           \
		var/list/__compiled_reagents = list();                                                                             \
		for(var/decl/material/R in UNLINT(V.liquid_volumes)) {                                                             \
			__compiled_reagents[++__compiled_reagents.len] = list(R.uid, UNLINT(V.liquid_volumes[R]), (MAT_PHASE_LIQUID)); \
		}                                                                                                                  \
		for(var/decl/material/R in UNLINT(V.solid_volumes)) {                                                              \
			__compiled_reagents[++__compiled_reagents.len] = list(R.uid, UNLINT(V.solid_volumes[R]), (MAT_PHASE_SOLID));   \
		}                                                                                                                  \
		.[I + SERDE_REAGENT_LIST] = __compiled_reagents;                                                                   \
	} else {                                                                                                               \
		.[I + SERDE_REAGENT_LIST] = list();                                                                                \
	}                                                                                                                      \
} else {                                                                                                                   \
	.[I + SERDE_REAGENT_LIST]   = list();                                                                                  \
	.[I + SERDE_REAGENT_VOLUME] = 0;                                                                                       \
}

#define DESERIALIZE_REAGENTS(V, I) if(((I + SERDE_REAGENT_LIST) in __deserialization_payload) && ((I + SERDE_REAGENT_VOLUME) in __deserialization_payload)) {         \
	V = list((SERDE_REAGENT_VOLUME) = __deserialization_payload[I + SERDE_REAGENT_VOLUME], (SERDE_REAGENT_LIST) = __deserialization_payload[I + SERDE_REAGENT_LIST]); \
}

#define DESERIALIZE_DECL_TO_TYPE(V) if(istext(V) || ispath(V, /decl) || istype(V, /decl)) { var/decl/__D = RESOLVE_TO_DECL(V); V = __D?.type; } else { V = null; }
#define DESERIALIZE_TYPE(V) if(istext(V)) { V = text2path(V); } else if(!ispath(V)) { V = null; }
#define DESERIALIZE_DECL(V) if(istext(V) || ispath(V)) { V = RESOLVE_TO_DECL(V); } else { V = null; }

// List cast is to avoid OpenDream complaining about V typically being typed as a reagents datum, but holding a list for serde.
#define FINALIZE_REAGENTS_SERDE_BODY(V) try {                                                              \
	if((SERDE_REAGENT_LIST in V) && (SERDE_REAGENT_VOLUME in V)) {                                         \
		var/list/LV = V;                                                                                   \
		var/__serde_volume = LV[SERDE_REAGENT_VOLUME];                                                     \
		if(__serde_volume <= 0) {                                                                          \
			V = null;                                                                                      \
		} else {                                                                                           \
			var/list/__serde_reagents = LV[SERDE_REAGENT_LIST];                                            \
			V = new /datum/reagents(__serde_volume, src);                                                  \
			for(var/list/entry in __serde_reagents) {                                                      \
				V.add_reagent(RESOLVE_TO_DECL(entry[1]), entry[2], phase = entry[3], defer_update = TRUE); \
			}                                                                                              \
			V.handle_update();                                                                             \
		}                                                                                                  \
	} else {                                                                                               \
		V = null;                                                                                          \
	}                                                                                                      \
} catch(var/exception/E) {                                                                                 \
	log_error("Exception while finalizing reagents load for [type]: [EXCEPTION_TEXT(E)]");                 \
	V = null;                                                                                              \
}

#define FINALIZE_REAGENTS_SERDE(V)            if(islist(V)) { FINALIZE_REAGENTS_SERDE_BODY(V); }
#define FINALIZE_REAGENTS_SERDE_AND_RETURN(V) if(islist(V)) { FINALIZE_REAGENTS_SERDE_BODY(V); return; }
