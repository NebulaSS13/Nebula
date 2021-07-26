MANTIDIFY(/obj/structure/bed/chair/padded/purple, "mantid nest", "resting place")

/obj/structure/bed/chair/padded/purple/ascent
	icon_state = "nest_chair"
	pixel_z = 0

/obj/structure/bed/chair/padded/purple/ascent/gyne
	name = "mantid throne"
	icon_state = "nest_chair_large"

/obj/structure/ascent_spawn
	name = "mantid cryotank"
	desc = "A liquid-filled, cloudy tank with strange forms twitching inside."
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cellold2"
	anchored = TRUE
	density =  TRUE

/obj/structure/mopbucket/ascent
	name = "portable liquid cleaning agent holder"
	desc = "An alien container of some sort."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/structure/closet/crate/freezer/meat/ascent
	name = "cryogenic stasis unit"
	desc = "A bizarre alien stasis unit."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/structure/hygiene/shower/ascent
	name = "hydrating decontamination armature"
	desc = "An alien vertical squirt bath."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/structure/hygiene/sink/ascent
	name = "hydration outlet"
	desc = "An alien wall mounted basin with mysterious protrusions."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'

/obj/structure/reagent_dispensers/water_cooler/ascent
	name = "hydration dispensator"
	desc = "An alien device housing liquid for alien purposes."
	icon = 'mods/species/ascent/icons/ascent_doodads.dmi'
	cups = 50
	cup_type = /obj/item/chems/food/hydration

/obj/structure/reagent_dispensers/water_cooler/ascent/DispenserMessages(var/mob/user)
	return list("\The [user] grabs a hydration ration orb from \the [src].", "You grab a hydration ration orb from \the [src].")

/obj/structure/reagent_dispensers/water_cooler/ascent/RejectionMessage(var/mob/user)
	return "\The [src]'s orb supply is empty. Notify a control mind."
