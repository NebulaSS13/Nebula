/obj/item/chems/spray
	name                              = "spray bottle"
	desc                              = "A spray bottle, with an unscrewable top."
	icon                              = 'icons/obj/janitor.dmi'
	icon_state                        = "cleaner"
	item_state                        = "cleaner"
	item_flags                        = ITEM_FLAG_NO_BLUDGEON
	atom_flags                        = ATOM_FLAG_OPEN_CONTAINER
	slot_flags                        = SLOT_LOWER_BODY
	w_class                           = ITEM_SIZE_SMALL
	throw_speed                       = 2
	throw_range                       = 10
	attack_cooldown                   = DEFAULT_QUICK_COOLDOWN
	material                          = /decl/material/solid/organic/plastic
	volume                            = 250
	amount_per_transfer_from_this     = 10
	possible_transfer_amounts         = @"[5,10]"
	var/tmp/possible_particle_amounts = @"[1,3]"                    ///Possible chempuff particles amount for each transfer amount setting
	var/spray_particles               = 3                           ///Amount of chempuff particles
	var/tmp/particle_move_delay       = 10                          ///lower is faster
	var/tmp/sound_spray               = 'sound/effects/spray2.ogg'  ///Sound played when spraying
	var/safety                        = FALSE                       ///Whether the safety is on

/obj/item/chems/spray/solvent_can_melt(var/solvent_power = MAT_SOLVENT_STRONG)
	return FALSE // maybe reconsider this

/obj/item/chems/spray/Initialize()
	. = ..()
	src.verbs -= /obj/item/chems/verb/set_amount_per_transfer_from_this

// Override to avoid drinking from this or feeding it to your neighbor.
/obj/item/chems/spray/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	return FALSE

/obj/item/chems/spray/afterattack(atom/A, mob/user, proximity)
	if(A?.storage || istype(A, /obj/structure/table) || istype(A, /obj/structure/closet) || istype(A, /obj/item/chems) || istype(A, /obj/structure/hygiene/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /spell))
		return

	if(proximity)
		if(standard_dispenser_refill(user, A))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return

	Spray_at(A, user, proximity)

	if(reagents.has_reagent(/decl/material/liquid/acid))
		log_and_message_admins("fired sulphuric acid from \a [src].", user)
	if(reagents.has_reagent(/decl/material/liquid/acid/polyacid))
		log_and_message_admins("fired polyacid from \a [src].", user)
	if(reagents.has_reagent(/decl/material/liquid/lube))
		log_and_message_admins("fired lubricant from \a [src].", user)
	return

/obj/item/chems/spray/proc/Spray_at(atom/movable/A, mob/user, proximity)
	if(has_safety() && safety)
		to_chat(user, SPAN_WARNING("The safety is on!"))
		return
	playsound(src, sound_spray, 50, TRUE, -6)
	if (A.density && proximity)
		reagents.splash(A, amount_per_transfer_from_this)
		if(A == user)
			A.visible_message(SPAN_NOTICE("\The [user] sprays themselves with \the [src]."))
		else
			A.visible_message(SPAN_NOTICE("\The [user] sprays \the [A] with \the [src]."))
	else
		create_chempuff(A)
	return TRUE

/obj/item/chems/spray/proc/create_chempuff(var/atom/movable/target, var/particle_amount)
	set waitfor = FALSE

	var/obj/effect/effect/water/chempuff/D = new(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	if(QDELETED(src))
		return
	reagents.trans_to_obj(D, amount_per_transfer_from_this)
	D.set_up(get_turf(target), particle_amount? particle_amount : spray_particles, particle_move_delay)
	return D

/obj/item/chems/spray/attack_self(var/mob/user)
	if(has_safety())
		toggle_safety()
		return TRUE
	else
		//If no safety, we just toggle the nozzle
		var/decl/interaction_handler/IH = GET_DECL(/decl/interaction_handler/next_spray_amount)
		if(IH.is_possible(src, user))
			IH.invoked(src, user, src)
			return TRUE

///Whether the spray has a safety toggle
/obj/item/chems/spray/proc/has_safety()
	return FALSE

/obj/item/chems/spray/proc/toggle_safety()
	safety = !safety
	to_chat(usr, SPAN_NOTICE("You switch the safety [safety ? "on" : "off"]."))

/obj/item/chems/spray/examine(mob/user, distance)
	. = ..()
	if(loc == user)
		to_chat(user, "[round(reagents.total_volume)] unit\s left.")
	if(has_safety() && distance <= 1)
		to_chat(user, "The safety is [safety ? "on" : "off"].")

/obj/item/chems/get_alt_interactions(mob/user)
	. = ..()
	LAZYADD(., /decl/interaction_handler/empty/chems)
	LAZYADD(., /decl/interaction_handler/next_spray_amount)

///Toggle the spray size and transfer amount between the possible options
/decl/interaction_handler/next_spray_amount
	name                 = "Next Nozzle Setting"
	expected_target_type = /obj/item/chems/spray
	interaction_flags    = INTERACTION_NEEDS_INVENTORY | INTERACTION_NEEDS_PHYSICAL_INTERACTION

/decl/interaction_handler/next_spray_amount/is_possible(obj/item/chems/spray/target, mob/user, obj/item/prop)
	. = ..()
	if(.)
		return !isnull(target.possible_transfer_amounts)

/decl/interaction_handler/next_spray_amount/invoked(obj/item/chems/spray/target, mob/user)
	if(!target.possible_transfer_amounts)
		return
	target.amount_per_transfer_from_this = next_in_list(target.amount_per_transfer_from_this, cached_json_decode(target.possible_transfer_amounts))
	target.spray_particles = next_in_list(target.spray_particles, cached_json_decode(target.possible_particle_amounts))
	to_chat(user, SPAN_NOTICE("You adjusted the pressure nozzle. You'll now use [target.amount_per_transfer_from_this] units per spray."))

//space cleaner
/obj/item/chems/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	particle_move_delay = 6

/obj/item/chems/spray/cleaner/populate_reagents()
	add_to_reagents(/decl/material/liquid/cleaner, reagents.maximum_volume)

/obj/item/chems/spray/antiseptic
	name = "antiseptic spray"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/chems/spray/antiseptic/populate_reagents()
	add_to_reagents(/decl/material/liquid/antiseptic, reagents.maximum_volume)

/obj/item/chems/spray/hair_remover
	name = "hair remover"
	desc = "Very effective at removing hair, feathers, spines and horns."

/obj/item/chems/spray/hair_remover/populate_reagents()
	add_to_reagents(/decl/material/liquid/hair_remover, reagents.maximum_volume)

/obj/item/chems/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by Uhang Inc., it fires a mist of condensed capsaicin to blind and down an opponent quickly."
	icon = 'icons/obj/items/weapon/pepperspray.dmi'
	icon_state = ICON_STATE_WORLD
	possible_transfer_amounts = null
	volume = 60
	particle_move_delay = 1
	safety = TRUE

/obj/item/chems/spray/pepper/populate_reagents()
	add_to_reagents(/decl/material/liquid/capsaicin/condensed, reagents.maximum_volume)

/obj/item/chems/spray/pepper/has_safety()
	return TRUE

/obj/item/chems/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/items/sunflower.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10

/obj/item/chems/spray/waterflower/populate_reagents()
	add_to_reagents(/decl/material/liquid/water, reagents.maximum_volume)

/obj/item/chems/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/items/device/chemsprayer.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	w_class = ITEM_SIZE_LARGE
	possible_transfer_amounts = null
	volume = 600
	origin_tech = @'{"combat":3,"materials":3,"engineering":3}'
	particle_move_delay = 2 //Was hardcoded to 2 before, and 8 was slower than most mob's move speed
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/chems/spray/chemsprayer/Spray_at(atom/A)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		if(reagents.total_volume < 1)
			break
		create_chempuff(the_targets[a], rand(6, 8))
	return

/obj/item/chems/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/chems/spray/plantbgone/populate_reagents()
	add_to_reagents(/decl/material/liquid/weedkiller, reagents.maximum_volume)

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