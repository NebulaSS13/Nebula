/obj/structure/pedestal
	name       = "pedestal"
	desc       = "A flat-topped structure for decoration or presentation of items."
	icon       = 'icons/obj/structures/pedestals/pedestal_square.dmi'
	icon_state = ICON_STATE_WORLD
	anchored   = TRUE
	opacity    = FALSE
	density    = TRUE
	material   = /decl/material/solid/stone/marble
	material_alteration = MAT_FLAG_ALTERATION_ALL
	var/place_item_y = -5

/obj/structure/pedestal/attackby(obj/item/used_item, mob/user)
	if(!user.check_intent(I_FLAG_HARM) && user.try_unequip(used_item, get_turf(src)))
		used_item.reset_offsets(anim_time = 0)
		used_item.pixel_y = used_item.default_pixel_y + place_item_y
		return TRUE
	return ..()

/obj/structure/pedestal/narrow
	icon = 'icons/obj/structures/pedestals/pedestal_narrow.dmi'

/obj/structure/pedestal/round
	icon = 'icons/obj/structures/pedestals/pedestal_round.dmi'

/obj/structure/pedestal/triad
	icon = 'icons/obj/structures/pedestals/pedestal_triad.dmi'
