
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/chems/glass
	name = ""
	desc = ""
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = @"[5,10,15,25,30,60]"
	volume = 60
	w_class = ITEM_SIZE_SMALL
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	unacidable = 1 //glass doesn't dissolve in acid

	drop_sound = 'sound/foley/bottledrop1.ogg'
	pickup_sound = 'sound/foley/bottlepickup1.ogg'

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/hygiene/sink,
		/obj/item/storage,
		/obj/item/grenade/chem_grenade,
		/mob/living/bot/medbot,
		/obj/item/storage/secure/safe,
		/obj/structure/iv_drip,
		/obj/machinery/disposal,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/machinery/radiocarbon_spectrometer
	)

/obj/item/chems/glass/examine(mob/user, distance)
	. = ..()
	if(distance > 2)
		return
	
	if(reagents?.total_volume)
		to_chat(user, "<span class='notice'>It contains [reagents.total_volume] units of liquid.</span>")
	else
		to_chat(user, "<span class='notice'>It is empty.</span>")
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "<span class='notice'>The airtight lid seals it completely.</span>")

/obj/item/chems/glass/attack_self()
	..()
	if(ATOM_IS_OPEN_CONTAINER(src))
		to_chat(usr, "<span class = 'notice'>You put the lid on \the [src].</span>")
		atom_flags ^= ATOM_FLAG_OPEN_CONTAINER
	else
		to_chat(usr, "<span class = 'notice'>You take the lid off \the [src].</span>")
		atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	update_icon()

/obj/item/chems/glass/attack(mob/M, mob/user, def_zone)
	if(force && !(item_flags & ITEM_FLAG_NO_BLUDGEON) && user.a_intent == I_HURT)
		return	..()
	return FALSE

/obj/item/chems/glass/standard_feed_mob(var/mob/user, var/mob/target)
	if(!ATOM_IS_OPEN_CONTAINER(src))
		to_chat(user, "<span class='notice'>You need to open \the [src] first.</span>")
		return 1
	if(user.a_intent == I_HURT)
		return 1
	return ..()

/obj/item/chems/glass/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")
	if(user.has_personal_goal(/datum/goal/achievement/specific_object/drink))
		for(var/R in reagents.reagent_volumes)
			user.update_personal_goal(/datum/goal/achievement/specific_object/drink, R)

/obj/item/chems/glass/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!ATOM_IS_OPEN_CONTAINER(src) || !proximity) //Is the container open & are they next to whatever they're clicking?
		return FALSE //If not, do nothing.
	for(var/type in can_be_placed_into) //Is it something it can be placed into?
		if(istype(target, type))
			return TRUE
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return TRUE
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return TRUE
	if(standard_feed_mob(user, target))
		return TRUE
	if(user.a_intent == I_HURT)
		if(standard_splash_mob(user,target))
			return TRUE
		if(reagents && reagents.total_volume)
			to_chat(user, SPAN_DANGER("You splash the contents of \the [src] onto \the [target]."))
			reagents.splash(target, reagents.total_volume)
			return TRUE
	else if(reagents && reagents.total_volume)
		to_chat(user, SPAN_NOTICE("You splash a small amount of the contents of \the [src] onto \the [target]."))
		reagents.splash(target, min(reagents.total_volume, 5))
		return TRUE
	. = ..()

/obj/item/chems/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/items/bucket.dmi'
	icon_state = ICON_STATE_WORLD
	center_of_mass = @"{'x':16,'y':9}"
	w_class = ITEM_SIZE_NORMAL
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = @"[10,20,30,60,120,150,180]"
	volume = 180
	atom_flags = ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_SHOW_REAGENT_NAME
	unacidable = 0
	material = /decl/material/solid/plastic
	material_force_multiplier = 0.2
	slot_flags = SLOT_HEAD
	drop_sound = 'sound/foley/donk1.ogg'
	pickup_sound = 'sound/foley/pickup2.ogg'

/obj/item/chems/glass/bucket/wood
	desc = "It's a wooden bucket. How rustic."
	icon = 'icons/obj/items/wooden_bucket.dmi'
	volume = 200
	material = /decl/material/solid/wood

/obj/item/chems/glass/bucket/attackby(var/obj/D, mob/user)
	if(istype(D, /obj/item/mop))
		if(reagents.total_volume < 1)
			to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		else if(REAGENTS_FREE_SPACE(D.reagents) >= 5)
			reagents.trans_to_obj(D, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [D] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [D] is saturated."))
		return
	else
		return ..()

/obj/item/chems/glass/bucket/on_update_icon()
	var/new_overlays
	if (!ATOM_IS_OPEN_CONTAINER(src))
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		LAZYADD(new_overlays, lid)
	else if(reagents && reagents.total_volume && round((reagents.total_volume / volume) * 100) > 80)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "bucket")
		filling.color = reagents.get_color()
		LAZYADD(new_overlays, filling)
	overlays = new_overlays
