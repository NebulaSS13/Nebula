
/obj/item/haircomb //sparklysheep's comb
	name = "plastic comb"
	desc = "A pristine comb made from flexible plastic."
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	icon = 'icons/obj/items/comb.dmi'
	icon_state = "comb"
	item_state = "comb"
	material = /decl/material/solid/organic/plastic

/obj/item/haircomb/random/Initialize()
	. = ..()
	color = get_random_colour(lower = 150)

/obj/item/haircomb/attack_self(mob/user)
	if(!user.incapacitated())
		var/decl/pronouns/G = user.get_pronouns()
		user.visible_message(SPAN_NOTICE("\The [user] uses \the [src] to comb [G.his] hair with incredible style and sophistication. What a [G.informal_term]."))

/obj/item/haircomb/brush
	name = "hairbrush"
	desc = "A surprisingly decent hairbrush with a false wood handle and semi-soft bristles."
	icon = 'icons/obj/items/hairbrush.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = null
	icon_state = "brush"
	item_state = "brush"
	material = /decl/material/solid/organic/plastic

/obj/item/haircomb/brush/attack_self(mob/user)
	if(ishuman(user) && !user.incapacitated())
		var/mob/living/carbon/human/H = user
		var/decl/sprite_accessory/hair/hair_style = GET_DECL(H.h_style)
		if(hair_style.flags & VERY_SHORT)
			H.visible_message(SPAN_NOTICE("\The [H] just sort of runs \the [src] over their scalp."))
		else
			H.visible_message(SPAN_NOTICE("\The [H] meticulously brushes their hair with \the [src]."))