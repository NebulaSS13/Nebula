/decl/strata
	var/name
	var/list/base_materials
	var/list/ores_sparse
	var/list/ores_rich

/decl/strata/igneous
	name = "igneous rock"
	base_materials = list(MAT_BASALT)

/decl/strata/sedimentary
	name = "sedimentary rock"
	base_materials = list(MAT_SANDSTONE)

/decl/strata/metamorphic
	name = "metamorphic rock"
	base_materials = list(MAT_MARBLE)

/decl/strata/permafrost
	name = "permafrost"
	base_materials = list(MAT_WATER)
