/obj/structure/bed/simple
	desc = "A slatted wooden bed."
	icon = 'icons/obj/structures/simple_bed.dmi'
	icon_state = "bed_padded_preview" // For map editor preview purposes
	parts_type = /obj/item/stack/material/plank
	material = /decl/material/solid/organic/wood
	reinf_material = /decl/material/solid/organic/plantmatter/grass/dry
	color = /decl/material/solid/organic/plantmatter/grass/dry::color
	anchored = TRUE
	user_comfort = 0.8
	buckle_sound = "rustle"

/obj/structure/bed/simple/show_buckle_message(var/mob/buckled, var/mob/buckling)
	if(buckled == buckling)
		visible_message(
			SPAN_NOTICE("\The [buckled] lies down on \the [src]."),
			SPAN_NOTICE("You lie down on \the [src]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)
	else
		var/decl/pronouns/pronouns = buckled.get_pronouns()
		visible_message(
			SPAN_NOTICE("\The [buckled] [pronouns.is] laid down on \the [src] by \the [buckling]."),
			SPAN_NOTICE("You are laid down on \the [src] by \the [buckling]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)

/obj/structure/bed/simple/show_unbuckle_message(var/mob/buckled, var/mob/buckling)
	if(buckled == buckling)
		visible_message(
			SPAN_NOTICE("\The [buckled] rises from \the [src]."),
			SPAN_NOTICE("You rise from \the [src]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)
	else
		visible_message(
			SPAN_NOTICE("\The [buckled] was pulled off \the [src] by \the [buckling]."),
			SPAN_NOTICE("You were pulled off \the [src] by \the [buckling]."),
			SPAN_NOTICE("You hear a rustling sound.")
		)

/obj/structure/bed/simple/ebony
	material = /decl/material/solid/organic/wood/ebony

/obj/structure/bed/simple/ebony/cloth
	reinf_material = /decl/material/solid/organic/cloth
	color = /decl/material/solid/organic/cloth::color

/obj/structure/bed/simple/crafted
	reinf_material = null
	icon_state = "bed"
	color = /decl/material/solid/organic/wood::color

/obj/item/bedsheet/furs
	name = "sleeping furs"
	desc = "Some cured hides and furs, soft enough to be a good blanket."
	icon = 'icons/obj/items/sleeping_furs.dmi'
	item_state = null
	material_alteration = MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_COLOR
	material = /decl/material/solid/organic/skin/fur
	color = /decl/material/solid/organic/skin/fur::color
