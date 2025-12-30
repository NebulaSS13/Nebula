/obj/structure/bed/roller/ironingboard
	name = "ironing board"
	desc = "An ironing board to unwrinkle your wrinkled clothing."
	icon = 'icons/obj/structures/ironing.dmi'
	item_form_type = /obj/item/roller/ironingboard
	iv_stand = FALSE

	var/obj/item/clothing/cloth // the clothing on the ironing board
	var/obj/item/ironingiron/holding // ironing iron on the board
	var/static/list/move_sounds = list( // some nasty sounds to make when moving the board
		'sound/effects/metalscrape1.ogg',
		'sound/effects/metalscrape2.ogg',
		'sound/effects/metalscrape3.ogg'
	)

/obj/structure/bed/roller/ironingboard/Destroy()
	var/turf/T = get_turf(src)
	if(cloth)
		cloth.forceMove(T)
		remove_item(cloth)
	if(holding)
		holding.forceMove(T)
		remove_item(holding)

	. = ..()

/obj/structure/bed/roller/ironingboard/proc/remove_item(var/obj/item/used_item)
	if(used_item == cloth)
		cloth = null
	else if(used_item == holding)
		holding = null

	update_icon()
	events_repository.unregister(/decl/observ/destroyed, used_item, src, TYPE_PROC_REF(/obj/structure/bed/roller/ironingboard, remove_item))

// make a screeching noise to drive people mad
/obj/structure/bed/roller/ironingboard/Move()
	. = ..()
	if(!.)
		return
	var/turf/T = get_turf(src)
	if(isspaceturf(T) || istype(T, /turf/floor/carpet))
		return FALSE
	playsound(T, pick(move_sounds), 75, 1)

/obj/structure/bed/roller/ironingboard/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if(cloth)
		. += SPAN_NOTICE("\The [html_icon(cloth)] [cloth] lies on it.")

/obj/structure/bed/roller/ironingboard/on_update_icon()
	if(density)
		icon_state = "up"
	else
		icon_state = "down"
	if(holding)
		icon_state = "holding"

	..()
	if(cloth)
		add_overlay(image(cloth.icon, cloth.icon_state))

/obj/structure/bed/roller/ironingboard/attackby(var/obj/item/used_item, var/mob/user)
	if(!density)
		if(istype(used_item,/obj/item/clothing) || istype(used_item,/obj/item/ironingiron))
			to_chat(user, "<span class='notice'>[src] isn't deployed!</span>")
			return TRUE
		return ..()

	if(istype(used_item,/obj/item/clothing))
		if(cloth)
			to_chat(user, "<span class='notice'>[cloth] is already on the ironing table!</span>")
			return TRUE
		if(buckled_mob)
			to_chat(user, "<span class='notice'>[buckled_mob] is already on the ironing table!</span>")
			return TRUE

		if(user.try_unequip(used_item, src))
			cloth = used_item
			events_repository.register(/decl/observ/destroyed, used_item, src, TYPE_PROC_REF(/obj/structure/bed/roller/ironingboard, remove_item))
			update_icon()
		return TRUE
	else if(istype(used_item,/obj/item/ironingiron))
		var/obj/item/ironingiron/iron = used_item

		// anti-wrinkle "massage"
		if(buckled_mob && ishuman(buckled_mob))
			var/mob/living/human/H = buckled_mob
			var/zone = user.get_target_zone()
			var/parsed = parse_zone(zone)

			visible_message("<span class='danger'>[user] begins ironing [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You begin ironing [buckled_mob]'s [parsed]!</span>")
			if(!do_after(user, 40, src))
				return TRUE
			visible_message("<span class='danger'>[user] irons [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You iron [buckled_mob]'s [parsed]!</span>")

			var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, zone)
			affecting.take_damage(15, BURN, inflicter = "Hot metal")

			return TRUE

		if(!cloth)
			if(!holding && !iron.enabled && user.try_unequip(used_item, src))
				holding = iron
				events_repository.register(/decl/observ/destroyed, used_item, src, TYPE_PROC_REF(/obj/structure/bed/roller/ironingboard, remove_item))
				update_icon()
				return TRUE
			to_chat(user, "<span class='notice'>There isn't anything on the ironing board.</span>")
			return TRUE

		visible_message("[user] begins ironing [cloth].")
		if(!do_after(user, 4 SECONDS, src))
			return TRUE

		visible_message("[user] finishes ironing [cloth].")
		cloth.ironed_state = WRINKLES_NONE
		return TRUE

	return ..()

/obj/structure/bed/roller/ironingboard/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE) || buckled_mob)
		return ..()	//Takes care of unbuckling.
	if(density) // check if it's deployed
		if(holding && user.put_in_hands(holding))
			remove_item(holding)
			return TRUE
		if(cloth && user.put_in_hands(cloth))
			remove_item(cloth)
			return TRUE
		if(!buckled_mob)
			to_chat(user, "You fold the ironing table down.")
			set_density(0)
	else
		to_chat(user, "You deploy the ironing table.")
		set_density(1)
	update_icon()
	return TRUE

/obj/structure/bed/roller/ironingboard/collapse()
	var/turf/T = get_turf(src)
	if(cloth)
		cloth.forceMove(T)
		remove_item(cloth)
	if(holding)
		holding.forceMove(T)
		remove_item(holding)
	..()

/obj/item/roller/ironingboard
	name = "ironing board"
	desc = "A collapsed ironing board that can be carried around."
	icon = 'icons/obj/structures/ironing.dmi'
	icon_state = "folded"
	structure_form_type = /obj/structure/bed/roller/ironingboard