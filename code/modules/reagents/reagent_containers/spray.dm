/obj/item/chems/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	slot_flags = SLOT_LOWER_BODY
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	unacidable = 1 //plastic
	possible_transfer_amounts = @"[5,10]"
	volume = 250
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	var/step_delay = 10 // lower is faster

/obj/item/chems/spray/Initialize()
	. = ..()
	src.verbs -= /obj/item/chems/verb/set_amount_per_transfer_from_this

/obj/item/chems/spray/afterattack(atom/A, mob/user, proximity)
	if(istype(A, /obj/item/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/closet) || istype(A, /obj/item/chems) || istype(A, /obj/structure/hygiene/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /spell))
		return

	if(proximity)
		if(standard_dispenser_refill(user, A))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
		return

	Spray_at(A, user, proximity)

	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)

	if(reagents.has_reagent(/decl/material/liquid/acid))
		log_and_message_admins("fired sulphuric acid from \a [src].", user)
	if(reagents.has_reagent(/decl/material/liquid/acid/polyacid))
		log_and_message_admins("fired polyacid from \a [src].", user)
	if(reagents.has_reagent(/decl/material/liquid/lube))
		log_and_message_admins("fired lubricant from \a [src].", user)
	return

/obj/item/chems/spray/proc/Spray_at(atom/movable/A, mob/user, proximity)
	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	if (A.density && proximity)
		reagents.splash(A, amount_per_transfer_from_this)
		if(A == user)
			A.visible_message("<span class='notice'>\The [user] sprays themselves with \the [src].</span>")
		else
			A.visible_message("<span class='notice'>\The [user] sprays \the [A] with \the [src].</span>")
	else
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, spray_size, step_delay)
	return

/obj/item/chems/spray/attack_self(var/mob/user)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, cached_json_decode(possible_transfer_amounts))
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, "<span class='notice'>You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")

/obj/item/chems/spray/examine(mob/user, distance)
	. = ..()
	if(distance == 0 && loc == user)
		to_chat(user, "[round(reagents.total_volume)] unit\s left.")

/obj/item/chems/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, "<span class='notice'>You empty \the [src] onto the floor.</span>")
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
/obj/item/chems/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	step_delay = 6

/obj/item/chems/spray/cleaner/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/cleaner, volume)

/obj/item/chems/spray/antiseptic
	name = "antiseptic spray"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/chems/spray/antiseptic/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/antiseptic, volume)

/obj/item/chems/spray/hair_remover
	name = "hair remover"
	desc = "Very effective at removing hair, feathers, spines and horns."

/obj/item/chems/spray/hair_remover/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/hair_remover, volume)

/obj/item/chems/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by Uhang Inc., it fires a mist of condensed capsaicin to blind and down an opponent quickly."
	icon = 'icons/obj/items/weapon/pepperspray.dmi'
	icon_state = ICON_STATE_WORLD
	possible_transfer_amounts = null
	volume = 60
	var/safety = 1
	step_delay = 1

/obj/item/chems/spray/pepper/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/capsaicin/condensed, 60)

/obj/item/chems/spray/pepper/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		to_chat(user, "The safety is [safety ? "on" : "off"].")

/obj/item/chems/spray/pepper/attack_self(var/mob/user)
	safety = !safety
	to_chat(usr, "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>")

/obj/item/chems/spray/pepper/Spray_at(atom/A)
	if(safety)
		to_chat(usr, "<span class = 'warning'>The safety is on!</span>")
		return
	..()

/obj/item/chems/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/items/sunflower.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

/obj/item/chems/spray/waterflower/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/items/device/chemsprayer.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 3
	w_class = ITEM_SIZE_LARGE
	possible_transfer_amounts = null
	volume = 600
	origin_tech = "{'combat':3,'materials':3,'engineering':3}"
	step_delay = 8
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/chems/spray/chemsprayer/Spray_at(atom/A)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return

/obj/item/chems/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/chems/spray/plantbgone/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/weedkiller, 100)

/obj/item/chems/spray/plantbgone/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return

	if(istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()

/obj/item/chems/spray/cleaner/deodorant
	name = "deodorant"
	desc = "A can of Gold Standard spray deodorant - for when you're too lazy to shower."
	gender = PLURAL
	volume = 35
	icon = 'icons/obj/items/deodorant.dmi'
	icon_state = "deodorant"
	item_state = "deodorant"