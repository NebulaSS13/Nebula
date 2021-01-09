/obj/item/grenade/chem_grenade
	name = "grenade casing"
	icon = 'icons/obj/items/grenades/grenade_chem.dmi'
	desc = "A hand made chemical grenade."
	w_class = ITEM_SIZE_SMALL
	force = 2.0
	det_time = null
	unacidable = 1
	var/stage = 0
	var/state = 0
	var/path = 0
	var/obj/item/assembly_holder/detonator = null
	var/list/beakers = new/list()
	var/list/allowed_containers = list(/obj/item/chems/glass/beaker, /obj/item/chems/glass/bottle)
	var/affected_area = 3

/obj/item/grenade/chem_grenade/Initialize()
	. = ..()
	create_reagents(1000)

/obj/item/grenade/chem_grenade/attack_self(mob/user)
	if(!stage || stage==1)
		if(detonator)
			detonator.detached()
			usr.put_in_hands(detonator)
			detonator=null
			det_time = null
			stage=0
		else if(beakers.len)
			for(var/obj/B in beakers)
				if(istype(B))
					beakers -= B
					user.put_in_hands(B)
		SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
		update_icon()
	if(stage > 1 && !active && clown_check(user))
		to_chat(user, "<span class='warning'>You prime \the [name]!</span>")
		activate(user)
		add_fingerprint(user)
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			C.throw_mode_on()

/obj/item/grenade/chem_grenade/on_update_icon()
	..()
	if(detonator)
		add_overlay("[icon_state]-assembled")
	if(path == 1)
		add_overlay("[icon_state]-locked")

/obj/item/grenade/chem_grenade/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/assembly_holder) && (!stage || stage==1) && path != 2)
		var/obj/item/assembly_holder/det = W
		if(istype(det.a_left,det.a_right.type) || (!isigniter(det.a_left) && !isigniter(det.a_right)))
			to_chat(user, "<span class='warning'>Assembly must contain one igniter.</span>")
			return
		if(!det.secured)
			to_chat(user, "<span class='warning'>Assembly must be secured with screwdriver.</span>")
			return
		if(!user.unEquip(det, src))
			return
		path = 1
		log_and_message_admins("has attached \a [W] to \the [src].")
		to_chat(user, "<span class='notice'>You add [W] to the metal casing.</span>")
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 25, -3)
		detonator = det
		if(istimer(detonator.a_left))
			var/obj/item/assembly/timer/T = detonator.a_left
			det_time = 10*T.time
		if(istimer(detonator.a_right))
			var/obj/item/assembly/timer/T = detonator.a_right
			det_time = 10*T.time
		SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
		stage = 1
	else if(isScrewdriver(W) && path != 2)
		if(stage == 1)
			path = 1
			if(beakers.len)
				to_chat(user, "<span class='notice'>You lock the assembly.</span>")
				SetName("grenade")
			else
				to_chat(user, "<span class='notice'>You lock the empty assembly.</span>")
				SetName("fake grenade")
			playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
			stage = 2
		else if(stage == 2)
			if(active && prob(95))
				to_chat(user, "<span class='warning'>You trigger the assembly!</span>")
				detonate()
				return
			else
				to_chat(user, "<span class='notice'>You unlock the assembly.</span>")
				playsound(src.loc, 'sound/items/Screwdriver.ogg', 25, -3)
				SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
				stage = 1
				active = FALSE
	else if(is_type_in_list(W, allowed_containers) && (!stage || stage==1) && path != 2)
		path = 1
		if(beakers.len == 2)
			to_chat(user, "<span class='warning'>The grenade can not hold more containers.</span>")
			return
		else
			if(W.reagents.total_volume)
				if(!user.unEquip(W, src))
					return
				to_chat(user, "<span class='notice'>You add \the [W] to the assembly.</span>")
				beakers += W
				stage = 1
				SetName("unsecured grenade with [beakers.len] containers[detonator?" and detonator":""]")
			else
				to_chat(user, "<span class='warning'>\The [W] is empty.</span>")
	update_icon()

/obj/item/grenade/chem_grenade/activate(mob/user)
	if(active) 
		return
	if(detonator)
		if(!isigniter(detonator.a_left))
			detonator.a_left.activate()
			active = TRUE
		if(!isigniter(detonator.a_right))
			detonator.a_right.activate()
			active = TRUE
	update_icon()
	if(active && user)
		log_and_message_admins("has primed \a [src].")

/obj/item/grenade/chem_grenade/detonate()
	set waitfor = 0
	if(!stage || stage < 2) 
		return

	var/has_reagents = 0
	for(var/obj/item/chems/glass/G in beakers)
		if(G.reagents.total_volume) 
			has_reagents = TRUE
			break

	active = FALSE
	if(!has_reagents)
		playsound(src.loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		spawn(0) //Otherwise det_time is erroneously set to 0 after this
			if(istimer(detonator.a_left)) //Make sure description reflects that the timer has been reset
				var/obj/item/assembly/timer/T = detonator.a_left
				det_time = 10*T.time
			if(istimer(detonator.a_right))
				var/obj/item/assembly/timer/T = detonator.a_right
				det_time = 10*T.time
		update_icon()
		return

	playsound(src.loc, 'sound/effects/bamf.ogg', 50, 1)
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src)
		M.throw_mode_off()

	for(var/obj/item/chems/glass/G in beakers)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)

	anchored = TRUE
	set_invisibility(INVISIBILITY_MAXIMUM)

	// Visual effect to show the grenade going off.
	if(reagents.total_volume) 
		var/datum/effect/effect/system/steam_spread/steam = new
		steam.set_up(10, 0, get_turf(src))
		steam.attach(src)
		steam.start()

 	// Allow time for reactions to proc.
	var/max_delays = 5
	var/delays = 0
	while(reagents.total_volume && delays <= max_delays)
		delays++
		sleep(SSmaterials.wait)

	// The reactions didn't use up all reagents, dump them as a fluid.
	if(reagents.total_volume)
		reagents.trans_to(loc, reagents.total_volume)

	qdel(src)

/obj/item/grenade/chem_grenade/examine(mob/user)
	. = ..()
	if(detonator)
		to_chat(user, "With attached [detonator.name]")

/obj/item/grenade/chem_grenade/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon = 'icons/obj/items/grenades/grenade_large.dmi'
	allowed_containers = list(/obj/item/chems/glass)
	origin_tech = "{'combat':3,'materials':3}"
	affected_area = 4
	material = /decl/material/solid/metal/steel

/obj/item/grenade/chem_grenade/metalfoam
	name = "metal-foam grenade"
	desc = "Used for emergency sealing of air breaches."
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/metalfoam/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/B1 = new(src)
	var/obj/item/chems/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/solid/metal/aluminium, 30)
	B2.reagents.add_reagent(/decl/material/liquid/foaming_agent, 10)
	B2.reagents.add_reagent(/decl/material/liquid/acid/polyacid, 10)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()

/obj/item/grenade/chem_grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/incendiary/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/B1 = new(src)
	var/obj/item/chems/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/solid/metal/aluminium, 15)
	B1.reagents.add_reagent(/decl/material/liquid/fuel, 15)
	B2.reagents.add_reagent(/decl/material/solid/metal/aluminium, 15)
	B2.reagents.add_reagent(/decl/material/liquid/acid, 15)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()

/obj/item/grenade/chem_grenade/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	path = 1
	stage = 2

/obj/item/grenade/chem_grenade/antiweed/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/B1 = new(src)
	var/obj/item/chems/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/liquid/weedkiller, 25)
	B1.reagents.add_reagent(/decl/material/solid/potassium, 25)
	B2.reagents.add_reagent(/decl/material/solid/phosphorus, 25)
	B2.reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 25)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()

/obj/item/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = 2
	path = 1

/obj/item/grenade/chem_grenade/cleaner/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/B1 = new(src)
	var/obj/item/chems/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/liquid/surfactant, 40)
	B2.reagents.add_reagent(/decl/material/liquid/water, 40)
	B2.reagents.add_reagent(/decl/material/liquid/cleaner, 10)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()

/obj/item/grenade/chem_grenade/teargas
	name = "tear gas grenade"
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."
	stage = 2
	path = 1

/obj/item/grenade/chem_grenade/teargas/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/large/B1 = new(src)
	var/obj/item/chems/glass/beaker/large/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/solid/phosphorus, 40)
	B1.reagents.add_reagent(/decl/material/solid/potassium, 40)
	B1.reagents.add_reagent(/decl/material/liquid/capsaicin/condensed, 40)
	B2.reagents.add_reagent(/decl/material/liquid/nutriment/sugar, 40)
	B2.reagents.add_reagent(/decl/material/liquid/capsaicin/condensed, 80)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()

/obj/item/grenade/chem_grenade/water
	name = "water grenade"
	desc = "A water grenade, generally used for firefighting."
	icon = 'icons/obj/items/grenades/grenade_water.dmi'
	stage = 2
	path = 1

/obj/item/grenade/chem_grenade/water/Initialize()
	. = ..()
	var/obj/item/chems/glass/beaker/B1 = new(src)
	var/obj/item/chems/glass/beaker/B2 = new(src)
	B1.reagents.add_reagent(/decl/material/liquid/water, 40)
	B2.reagents.add_reagent(/decl/material/liquid/water, 40)
	detonator = new/obj/item/assembly_holder/timer_igniter(src)
	beakers += B1
	beakers += B2
	update_icon()
