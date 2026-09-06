/decl/flooring/concrete
	name           = "concrete"
	desc           = "A flat expanse of stone-like artificial material."
	icon           = 'icons/turf/flooring/concrete.dmi'
	icon_base      = "inset"
	has_base_range = null
	force_material = /decl/material/solid/stone/concrete
	constructed    = TRUE
	uid            = "floor_concrete"
	can_conceal_hazards = TRUE

/decl/flooring/concrete/reinforced
	name           = "reinforced concrete"
	icon_base      = "hexacrete"
	desc           = "A flat stretch of stone-like artificial material. It has been reinforced with an unknown compound."
	uid            = "floor_concrete_reinf"

/decl/flooring/concrete/asphalt
	name           = "asphalt"
	color          = COLOR_GRAY40
	icon_base      = "concrete"
	desc           = "A stretch of rough blacktop, probably part of a road."
	uid            = "floor_asphalt"
