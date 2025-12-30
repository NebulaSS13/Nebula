/obj/structure/pillar
	name       = "pillar"
	desc       = "A tall, narrow structure, usually used to hold up the roof."
	icon       = 'icons/obj/structures/pillars/pillar_square.dmi'
	icon_state = ICON_STATE_WORLD
	anchored   = TRUE
	opacity    = TRUE
	density    = TRUE
	material   = /decl/material/solid/stone/marble
	material_alteration = MAT_FLAG_ALTERATION_ALL

/obj/structure/pillar/narrow
	icon = 'icons/obj/structures/pillars/pillar_narrow.dmi'

/obj/structure/pillar/round
	icon = 'icons/obj/structures/pillars/pillar_round.dmi'

/obj/structure/pillar/triad
	icon = 'icons/obj/structures/pillars/pillar_triad.dmi'

/obj/structure/pillar/wide
	name = "wide pillar"
	w_class = ITEM_SIZE_LARGE_STRUCTURE
	icon = 'icons/obj/structures/pillars/pillar_wide_round.dmi'

/obj/structure/pillar/wide/square
	icon = 'icons/obj/structures/pillars/pillar_wide_square.dmi'

/obj/structure/pillar/wide/inset
	icon = 'icons/obj/structures/pillars/pillar_wide_inset.dmi'
