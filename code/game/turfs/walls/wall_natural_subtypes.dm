/turf/wall/natural/random
	reinf_material = null

// We want to avoid spawning random ores in Initialize() by serializing a subtype that does that.
/turf/wall/natural/random/GetSerializedType()
	return /turf/wall/natural

/turf/wall/natural/random/proc/get_weighted_mineral_list()
	if(strata_override)
		var/decl/strata/strata_info = GET_DECL(strata_override)
		. = strata_info.ores_sparse
	if(!.)
		. = SSmaterials.weighted_minerals_sparse

/turf/wall/natural/random/high_chance/get_weighted_mineral_list()
	if(strata_override)
		var/decl/strata/strata_info = GET_DECL(strata_override)
		. = strata_info.ores_rich
	if(!.)
		. = SSmaterials.weighted_minerals_rich

/turf/wall/natural/random/Initialize(ml, materialtype, rmaterialtype)
	if(!strata_override)
		strata_override = SSmaterials.get_strata_type(src)
	if(isnull(reinf_material))
		var/default_mineral_list = get_weighted_mineral_list()
		if(LAZYLEN(default_mineral_list))
			reinf_material = pickweight(default_mineral_list)
	. = ..()

/turf/wall/natural/volcanic
	strata_override = /decl/strata/igneous

/turf/wall/natural/random/volcanic
	strata_override = /decl/strata/igneous

/turf/wall/natural/random/volcanic/GetSerializedType()
	return /turf/wall/natural/volcanic

/turf/wall/natural/random/high_chance/volcanic
	strata_override = /decl/strata/igneous

/turf/wall/natural/random/high_chance/volcanic/GetSerializedType()
	return /turf/wall/natural/volcanic

/turf/wall/natural/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/floor/ice

/turf/wall/natural/random/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/floor/ice

/turf/wall/natural/random/ice/GetSerializedType()
	return /turf/wall/natural/ice

/turf/wall/natural/random/high_chance/ice
	strata_override = /decl/strata/permafrost
	floor_type = /turf/floor/ice

/turf/wall/natural/random/high_chance/ice/GetSerializedType()
	return /turf/wall/natural/ice

/turf/wall/natural/dirt
	material = /decl/material/solid/soil
	color = "#41311b"
	floor_type = /turf/floor/dirt

#define MATERIAL_NATURAL_TURFS(ID, MAT)                          \
/turf/floor/rock/##ID {                                          \
	color    = /decl/material/##MAT::color;                      \
	material = /decl/material/##MAT                              \
}                                                                \
/turf/floor/rock/##ID/sand {                                     \
	name = "sand";                                               \
	icon = 'icons/turf/flooring/sand.dmi';                       \
	icon_state = "sand0";                                        \
	_flooring = /decl/flooring/sand;                             \
}                                                                \
/turf/wall/natural/##ID {                                        \
	material = /decl/material/##MAT;                             \
	color = /decl/material/##MAT::color;                         \
	floor_type = /turf/floor/rock/##ID;                          \
}                                                                \
/turf/wall/natural/random/##ID {                                 \
	material = /decl/material/##MAT;                             \
	color = /decl/material/##MAT::color;                         \
	floor_type = /turf/floor/rock/##ID;                          \
}                                                                \
/turf/wall/natural/random/##ID/GetSerializedType() {             \
	return /turf/wall/natural/##ID;                              \
}                                                                \
/turf/wall/natural/random/high_chance/##ID {                     \
	material = /decl/material/##MAT;                             \
	color = /decl/material/##MAT::color;                         \
	floor_type = /turf/floor/rock/##ID                           \
}                                                                \
/turf/wall/natural/random/high_chance/##ID/GetSerializedType() { \
	return /turf/wall/natural/##ID;                              \
}
MATERIAL_NATURAL_TURFS(sandstone, solid/stone/sandstone)
MATERIAL_NATURAL_TURFS(basalt,    solid/stone/basalt)
MATERIAL_NATURAL_TURFS(granite,   solid/stone/granite)
MATERIAL_NATURAL_TURFS(marble,    solid/stone/marble)
#undef MATERIAL_NATURAL_TURFS