/decl/material/solid/organic/wood/sif
	name = "sifwood"
	uid = "mat_wood_sif"
	color = "#0099cc"

/decl/material/solid/organic/wood/chipboard/sif
	name = "sifwood chipboard"
	adjective_name = "sifwood laminate"
	uid = "mat_chipboard_sif"
	color = "#0099cc"

/decl/material/solid/organic/plantmatter/grass/sif
	name  = "sifmoss"
	color = "#447171"
	uid = "mat_solid_sifmoss"
	dug_drop_type = /obj/item/stack/material/bundle

DEFINE_STACK_SUBTYPES(sif,           "sifwood",           solid/organic/wood/sif,       plank, null)
DEFINE_STACK_SUBTYPES(sif,           "sifwood",           solid/organic/wood/sif,       log,   null)
DEFINE_STACK_SUBTYPES(chipboard_sif, "sifwood chipboard", solid/organic/wood/chipboard, sheet, null)
