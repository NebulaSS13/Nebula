/obj/item/clothing/head/fated
	name = "strange key"
	desc = "A glowing key, uncomfortably hot to the touch."

	icon = 'icons/clothing/head/fated_key.dmi'
	body_parts_covered = 0
	armor = list(melee = 55, bullet = 55, laser = 55, energy = 55, bomb = 55, bio = 100, rad = 100)

/obj/item/clothing/head/fated/equipped(mob/living/user, slot)
	. = ..()
	if(istype(user) && canremove && loc == user && slot == slot_head_str)
		canremove = FALSE
		to_chat(user, SPAN_DANGER("<font size=3>\The [src] shatters your mind as it sears through [user.isSynthetic() ? "metal and circuitry" : "flesh and bone"], embedding itself into your skull!</font>"))
		user.Paralyse(5)
		addtimer(CALLBACK(src, .proc/activate_role), 5 SECONDS)
	else
		canremove = TRUE
		name = initial(name)
		desc = initial(desc)
		body_parts_covered = initial(body_parts_covered)
		item_flags &= ~ITEM_FLAG_AIRTIGHT

/obj/item/clothing/head/fated/proc/activate_role()
	var/mob/living/starbearer = loc
	if(istype(starbearer) && !canremove)
		name = "halo of starfire"
		desc = "Beware the fire of the star-bearers; it is too terrible to touch."
		starbearer.add_aura(new /obj/aura/regenerating(starbearer))
		body_parts_covered = SLOT_UPPER_BODY|SLOT_LOWER_BODY|SLOT_LEGS|SLOT_ARMS|SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_HANDS|SLOT_FEET
		item_flags |= ITEM_FLAG_AIRTIGHT

/obj/item/clothing/head/fated/verb/perform_division()

	set name = "Divide"
	set desc = "The sanctioned action is to cut."
	set category = "Abilities"
	set src in usr

	var/mob/living/user = usr
	if(!istype(user))
		return

	if(user.incapacitated())
		to_chat(user, SPAN_WARNING("You are in no fit state to perform division."))
		return

	if(world.time < user.last_special)
		to_chat(user, SPAN_WARNING("You have not yet regained enough focus to perform division."))
		return

	var/atom/blade
	for(var/obj/item/held in shuffle(user.get_held_items()))
		if(has_edge(held))
			blade = held
			break
	if(!blade)
		to_chat(user, SPAN_WARNING("You have no blade with which to divide."))
		return

	user.visible_message(SPAN_DANGER("\The [user] raises \his [blade.name] to shoulder level!"))
	playsound(user.loc, 'sound/effects/sanctionedaction_prep.ogg', 100, 1)

	if(do_after(user, 1 SECOND, progress = 0, same_direction = 1))
		user.visible_message(SPAN_DANGER("\The [user] swings \his [blade.name] in a blazing arc!"))
		playsound(user.loc, 'sound/effects/sanctionedaction_cut.ogg', 100, 1)
		var/obj/item/projectile/sanctionedaction/cut = new(user.loc)
		cut.launch(get_edge_target_turf(get_turf(user.loc), user.dir), user.zone_sel.selecting)
		user.last_special = world.time + 10 SECONDS

/obj/item/projectile/sanctionedaction
	name = "rending slash"
	desc = "O shining blade, divider of infinities."
	icon = 'icons/effects/sanctionedaction.dmi'
	icon_state = "cut"
	penetrating = 100

/obj/item/projectile/sanctionedaction/check_penetrate(var/atom/A)
	. = TRUE
	if(istype(A, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = A
		if(H.organs && H.organs.len)
			var/obj/item/organ/external/E = pick(H.organs)
			if(istype(E))
				E.droplimb()

/obj/item/projectile/sanctionedaction/before_move()
	. = ..()
	var/turf/T = get_turf(src)
	if(T)
		T.explosion_act(2)
		var/firecount = rand(5,8)
		while(firecount)
			firecount--
			new /obj/effect/white_fire(get_turf(src))

/obj/effect/white_fire
	name = "white fire"
	icon = 'icons/effects/sanctionedaction.dmi'
	alpha = 0
	layer = PROJECTILE_LAYER

/obj/effect/white_fire/Initialize()
	. = ..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	icon_state = pick(list("flame1","flame2"))
	fade_out()

/obj/effect/white_fire/proc/fade_out()
	set waitfor = FALSE
	animate(src, alpha = 255, time = 3)
	sleep(13)
	animate(src, alpha = 0, time = 40)
	sleep(40)
	qdel(src)
