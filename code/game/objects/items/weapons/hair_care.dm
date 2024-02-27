
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
	if(user.incapacitated() || !isliving(user))
		return ..()
	var/mob/living/user_living = user
	var/hairstyle = GET_HAIR_STYLE(user_living)
	if(hairstyle)
		var/decl/sprite_accessory/hair/hair_style = GET_DECL(hairstyle)
		if(hair_style.accessory_flags & VERY_SHORT)
			user_living.visible_message(SPAN_NOTICE("\The [user_living] just sort of runs \the [src] over their scalp."))
		else
			user_living.visible_message(SPAN_NOTICE("\The [user_living] meticulously brushes their hair with \the [src]."))
	else
		to_chat(user_living, SPAN_WARNING("You don't have any hair to brush!"))
	return TRUE
