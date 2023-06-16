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

/obj/structure/bed/roller/ironingboard/proc/remove_item(var/obj/item/I)
	if(I == cloth)
		cloth = null
	else if(I == holding)
		holding = null

	update_icon()
	events_repository.unregister(/decl/observ/destroyed, I, src, /obj/structure/bed/roller/ironingboard/proc/remove_item)

// make a screeching noise to drive people mad
/obj/structure/bed/roller/ironingboard/Move()
	var/turf/T = get_turf(src)
	if(isspaceturf(T) || istype(T, /turf/simulated/floor/carpet))
		return
	playsound(T, pick(move_sounds), 75, 1)

	. = ..()

/obj/structure/bed/roller/ironingboard/examine(mob/user)
	. = ..()
	if(cloth)
		to_chat(user, "<span class='notice'>\The [html_icon(cloth)] [cloth] lies on it.</span>")

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

/obj/structure/bed/roller/ironingboard/attackby(var/obj/item/I, var/mob/user)
	if(!density)
		if(istype(I,/obj/item/clothing) || istype(I,/obj/item/ironingiron))
			to_chat(user, "<span class='notice'>[src] isn't deployed!</span>")
			return
		return ..()

	if(istype(I,/obj/item/clothing))
		if(cloth)
			to_chat(user, "<span class='notice'>[cloth] is already on the ironing table!</span>")
			return
		if(buckled_mob)
			to_chat(user, "<span class='notice'>[buckled_mob] is already on the ironing table!</span>")
			return

		if(user.try_unequip(I, src))
			cloth = I
			events_repository.register(/decl/observ/destroyed, I, src, /obj/structure/bed/roller/ironingboard/proc/remove_item)
			update_icon()
		return
	else if(istype(I,/obj/item/ironingiron))
		var/obj/item/ironingiron/R = I

		// anti-wrinkle "massage"
		if(buckled_mob && ishuman(buckled_mob))
			var/mob/living/carbon/human/H = buckled_mob
			var/zone = user.get_target_zone()
			var/parsed = parse_zone(zone)

			visible_message("<span class='danger'>[user] begins ironing [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You begin ironing [buckled_mob]'s [parsed]!</span>")
			if(!do_after(user, 40, src))
				return
			visible_message("<span class='danger'>[user] irons [src.buckled_mob]'s [parsed]!</span>", "<span class='danger'>You iron [buckled_mob]'s [parsed]!</span>")

			var/obj/item/organ/external/affecting = GET_EXTERNAL_ORGAN(H, zone)
			affecting.take_external_damage(0, 15, used_weapon = "Hot metal")

			return

		if(!cloth)
			if(!holding && !R.enabled && user.try_unequip(I, src))
				holding = R
				events_repository.register(/decl/observ/destroyed, I, src, /obj/structure/bed/roller/ironingboard/proc/remove_item)
				update_icon()
				return
			to_chat(user, "<span class='notice'>There isn't anything on the ironing board.</span>")
			return

		visible_message("[user] begins ironing [cloth].")
		if(!do_after(user, 40, src))
			return

		visible_message("[user] finishes ironing [cloth].")
		cloth.ironed_state = WRINKLES_NONE
		return

	..()

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
	structure_form_type = /obj/structure/bed/roller/ironingboard