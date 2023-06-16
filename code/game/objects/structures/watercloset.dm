var/global/list/hygiene_props = list()

//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos
/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged = 0 // -1 = never clog
	var/can_drain = 0
	var/drainage = 0.5
	var/last_gurgle = 0

/obj/structure/hygiene/Initialize()
	. = ..()
	global.hygiene_props += src
	START_PROCESSING(SSobj, src)

/obj/structure/hygiene/Destroy()
	global.hygiene_props -= src
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/hygiene/proc/clog(var/severity)
	if(clogged || !anchored) //We can only clog if our state is zero, aka completely unclogged and cloggable
		return FALSE
	clogged = severity
	tool_interaction_flags &= ~TOOL_INTERACTION_ANCHOR
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = 0
	tool_interaction_flags = initial(tool_interaction_flags)

/obj/structure/hygiene/attackby(var/obj/item/thing, var/mob/user)
	if(clogged > 0 && isplunger(thing))
		user.visible_message(SPAN_NOTICE("\The [user] strives valiantly to unclog \the [src] with \the [thing]!"))
		spawn
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
		if(do_after(user, 45, src) && clogged > 0)
			visible_message(SPAN_NOTICE("With a loud gurgle, \the [src] begins flowing more freely."))
			playsound(loc, pick(SSfluids.gurgles), 100, 1)
			clogged--
			if(clogged <= 0)
				unclog()
		return
	. = ..()

/obj/structure/hygiene/examine(mob/user)
	. = ..()
	if(clogged > 0)
		to_chat(user, SPAN_WARNING("It seems to be badly clogged."))

/obj/structure/hygiene/Process()
	if(clogged <= 0)
		drain()
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message("\The [src] gurgles and overflows!")
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			var/obj/effect/fluid/F = locate() in T
			var/adding = min(flood_amt-F?.reagents.total_volume, rand(30,50)*clogged)
			if(adding > 0)
				if(!F) F = new(T)
				F.reagents.add_reagent(/decl/material/liquid/water, adding)

/obj/structure/hygiene/proc/drain()
	if(!can_drain) return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		return

	T.remove_fluid(CEILING(fluid_here*drainage))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)

/obj/structure/hygiene/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = 0
	anchored = 1
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR

	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/hygiene/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/hygiene/toilet/attack_hand(var/mob/user)
	if(!user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()

	if(swirlie)
		usr.visible_message(
			SPAN_DANGER("\The [user] slams the toilet seat onto \the [swirlie]'s head!"),
			SPAN_NOTICE("You slam the toilet seat onto \the [swirlie]'s head!"),
			"You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return TRUE

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, SPAN_NOTICE("The cistern is empty."))
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You find \a [I] in the cistern."))
			w_items -= I.w_class
		return TRUE

	if(user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		open = !open
		update_icon()
		return TRUE

	return ..()

/obj/structure/hygiene/toilet/on_update_icon()
	..()
	icon_state = "toilet[open][cistern]"

/obj/structure/hygiene/toilet/attackby(obj/item/I, var/mob/user)
	if(IS_CROWBAR(I))
		to_chat(user, SPAN_NOTICE("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message(
				SPAN_NOTICE("\The [user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"),
				SPAN_NOTICE("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"),
				"You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
		return

	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		var/mob/living/GM = G.get_affecting_mob()
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(GM)
			if(!GM.loc == get_turf(src))
				to_chat(user, SPAN_WARNING("\The [GM] needs to be on the toilet."))
				return
			if(open && !swirlie)
				user.visible_message(SPAN_DANGER("\The [user] starts jamming \the [GM]'s face into \the [src]!"))
				swirlie = GM
				if(do_after(user, 30, src))
					user.visible_message(SPAN_DANGER("\The [user] gives [GM.name] a swirlie!"))
					GM.adjustOxyLoss(5)
				swirlie = null
			else
				user.visible_message(
				SPAN_DANGER("\The [user] slams \the [GM] into the [src]!"),
				SPAN_NOTICE("You slam \the [GM] into the [src]!"))
				GM.adjustBruteLoss(8)
				playsound(src.loc, 'sound/effects/bang.ogg', 25, 1)
		return

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > ITEM_SIZE_NORMAL)
			to_chat(user, SPAN_WARNING("\The [I] does not fit."))
			return
		if(w_items + I.w_class > ITEM_SIZE_HUGE)
			to_chat(user, SPAN_WARNING("The cistern is full."))
			return
		if(!user.try_unequip(I, src))
			return
		w_items += I.w_class
		to_chat(user, SPAN_NOTICE("You carefully place \the [I] into the cistern."))
		return

	. = ..()

/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"
	obj_flags = OBJ_FLAG_MOVES_UNSUPPORTED

/obj/structure/hygiene/urinal/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		var/mob/living/GM = G.get_affecting_mob()
		if(GM)
			if(!GM.loc == get_turf(src))
				to_chat(user, SPAN_WARNING("\The [GM] needs to be on \the [src]."))
				return
			user.visible_message(SPAN_DANGER("\The [user] slams \the [GM] into the [src]!"))
			GM.adjustBruteLoss(8)
	. = ..()

/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2200s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	clogged = -1
	can_drain = 1
	drainage = 0.2 			//showers are tiny, drain a little slower

	var/on = 0
	var/next_mist = 0
	var/next_wash = 0
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)

	var/sound_id = /obj/structure/hygiene/shower
	var/datum/sound_token/sound_token

//add heat controls? when emagged, you can freeze to death in it?

/obj/structure/hygiene/shower/Initialize()
	. = ..()
	create_reagents(5)

/obj/structure/hygiene/shower/Destroy()
	QDEL_NULL(sound_token)
	. = ..()

/obj/structure/hygiene/shower/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES, TRUE))
		return ..()
	switch_state(!on, user)
	return TRUE

/obj/structure/hygiene/shower/proc/switch_state(new_state, mob/user)
	if(new_state == on)
		return
	on = new_state
	next_mist = on ? (world.time + 5 SECONDS) : INFINITY
	update_icon()
	update_sound()

/obj/structure/hygiene/shower/proc/update_sound()
	playsound(src, on ? 'sound/effects/shower_start.ogg' : 'sound/effects/shower_end.ogg', 40)
	QDEL_NULL(sound_token)
	if(on)
		sound_token = play_looping_sound(src, sound_id, 'sound/effects/shower_mid3.ogg', volume = 20, range = 7, falloff = 4, prefer_mute = TRUE)

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = 1
	mouse_opacity = 0

/obj/effect/mist/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		addtimer(CALLBACK(src, /datum/proc/qdel_self), 25 SECONDS)

/obj/structure/hygiene/shower/attackby(obj/item/I, var/mob/user)
	if(istype(I, /obj/item/scanner/gas))
		to_chat(user, SPAN_NOTICE("The water temperature seems to be [watertemp]."))
		return

	if(IS_WRENCH(I))
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		if(newtemp != watertemp && !QDELETED(I) && !QDELETED(user) && !QDELETED(src) && user.Adjacent(src) && I.loc == src)
			to_chat(user, SPAN_NOTICE("You begin to adjust the temperature valve with \the [I]."))
			playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
			if(do_after(user, (5 SECONDS), src) && newtemp != watertemp)
				watertemp = newtemp
				user.visible_message(
					SPAN_NOTICE("\The [user] adjusts \the [src] with \the [I]."),
					SPAN_NOTICE("You adjust the shower with \the [I]."))
				add_fingerprint(user)
		return TRUE
	. = ..()

/obj/structure/hygiene/shower/on_update_icon()
	..()
	if(on)
		add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))

/obj/structure/hygiene/shower/proc/update_mist()
	if(on && temperature_settings[watertemp] >= T20C && world.time >= next_mist && !(locate(/obj/effect/mist) in loc))
		new /obj/effect/mist(loc)
		next_mist = world.time + (25 SECONDS)

/obj/structure/hygiene/shower/Process()
	..()
	if(on)
		update_mist()
		for(var/thing in loc.get_contained_external_atoms())
			wash_mob(thing)
			process_heat(thing)
		reagents.add_reagent(/decl/material/liquid/water, REAGENTS_FREE_SPACE(reagents))
		if(world.time >= next_wash)
			next_wash = world.time + (10 SECONDS)
			reagents.splash(get_turf(src), reagents.total_volume, max_spill = 0)

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M))
		return
	var/water_temperature = temperature_settings[watertemp]
	var/temp_adj = clamp(BODYTEMP_COOLING_MAX, water_temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(water_temperature >= H.get_temperature_threshold(HEAT_LEVEL_1))
			to_chat(H, SPAN_DANGER("The water is searing hot!"))
		else if(water_temperature <= H.get_temperature_threshold(COLD_LEVEL_1))
			to_chat(H, SPAN_DANGER("The water is freezing cold!"))

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/structure/hygiene/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/hygiene/sink/receive_mouse_drop(var/atom/dropping, var/mob/user)
	. = ..()
	if(!. && isitem(dropping) && ATOM_IS_OPEN_CONTAINER(dropping))
		var/obj/item/thing = dropping
		if(thing.reagents?.total_volume <= 0)
			to_chat(usr, SPAN_WARNING("\The [thing] is empty."))
		else
			visible_message(SPAN_NOTICE("\The [user] tips the contents of \the [thing] into \the [src]."))
			thing.reagents.clear_reagents()
			thing.update_icon()
		return TRUE

/obj/structure/hygiene/sink/attack_hand(var/mob/user)

	if(isrobot(user) || isAI(user) || !Adjacent(user))
		return ..()

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return TRUE

	to_chat(usr, SPAN_NOTICE("You start washing your hands."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = TRUE
	if(!do_after(user, 40, src))
		busy = FALSE
		return TRUE
	busy = FALSE

	user.clean_blood()
	user.visible_message(
		SPAN_NOTICE("\The [user] washes their hands using \the [src]."),
		SPAN_NOTICE("You wash your hands using \the [src]."))
	return TRUE

/obj/structure/hygiene/sink/attackby(obj/item/O, var/mob/user)
	if(isplunger(O) && clogged > 0)
		return ..()

	if(busy)
		to_chat(user, SPAN_WARNING("Someone's already washing here."))
		return

	var/obj/item/chems/RG = O
	if (istype(RG) && ATOM_IS_OPEN_CONTAINER(RG) && RG.reagents)
		RG.reagents.add_reagent(/decl/material/liquid/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(
			SPAN_NOTICE("\The [user] fills \the [RG] using \the [src]."),
			SPAN_NOTICE("You fill \the [RG] using \the [src]."))
		playsound(loc, 'sound/effects/sink.ogg', 75, 1)
		return 1

	else if (istype(O, /obj/item/baton))
		var/obj/item/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				if(isliving(user))
					var/mob/living/M = user
					SET_STATUS_MAX(M, STAT_STUN, 10)
					SET_STATUS_MAX(M, STAT_STUTTER, 10)
					SET_STATUS_MAX(M, STAT_WEAK, 10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				var/decl/pronouns/G = user.get_pronouns()
				user.visible_message(SPAN_DANGER("\The [user] was stunned by [G.his] wet [O]!"))
				return 1
	else if(istype(O, /obj/item/mop))
		if(REAGENTS_FREE_SPACE(O.reagents) >= 5)
			O.reagents.add_reagent(/decl/material/liquid/water, 5)
			to_chat(user, SPAN_NOTICE("You wet \the [O] in \the [src]."))
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, SPAN_WARNING("\The [O] is saturated."))
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, SPAN_NOTICE("You start washing \the [I]."))
	playsound(loc, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 40, src))
		busy = 0
		return TRUE
	busy = 0

	if(istype(O, /obj/item/chems/spray/extinguisher)) return TRUE // We're washing, not filling.

	O.clean_blood()
	user.visible_message( \
		SPAN_NOTICE("\The [user] washes \a [I] using \the [src]."),
		SPAN_NOTICE("You wash \a [I] using \the [src]."))


/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"

/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	clogged = -1 // how do you clog a puddle

/obj/structure/hygiene/sink/puddle/attack_hand(var/mob/M)
	flick("puddle-splash", src)
	return ..()

/obj/structure/hygiene/sink/puddle/attackby(obj/item/O, var/mob/user)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

//toilet paper interaction for clogging toilets and other facilities

/obj/structure/hygiene/attackby(obj/item/I, mob/user)
	if (!istype(I, /obj/item/stack/tape_roll/barricade_tape/toilet))
		return ..()
	if (clogged == -1)
		to_chat(user, SPAN_WARNING("Try as you might, you can not clog \the [src] with \the [I]."))
		return
	if (clogged)
		to_chat(user, SPAN_WARNING("\The [src] is already clogged."))
		return
	if (!do_after(user, 3 SECONDS, src))
		to_chat(user, SPAN_WARNING("You must stay still to clog \the [src]."))
		return
	if (clogged || QDELETED(I) || !user.try_unequip(I))
		return
	to_chat(user, SPAN_NOTICE("You unceremoniously jam \the [src] with \the [I]. What a rebel."))
	clog(1)
	qdel(I)

////////////////////////////////////////////////////
// Toilet Paper Roll
////////////////////////////////////////////////////
/decl/barricade_tape_template/toilet
	tape_kind         = "toilet paper"
	tape_desc         = "A length of toilet paper. Seems like custodia is marking their territory again."
	roll_desc         = "A unbranded roll of standard issue two ply toilet paper. Refined from carefully rendered down sea shells due to the government's 'Abuse Of The Trees Act'."
	base_icon_state   = "stripetape"
	tape_color        = COLOR_WHITE
	detail_overlay    = "stripes"
	detail_color      = COLOR_WHITE

/obj/item/stack/tape_roll/barricade_tape/toilet
	icon          = 'icons/obj/toiletpaper.dmi'
	icon_state    = ICON_STATE_WORLD
	slot_flags    = SLOT_HEAD | SLOT_OVER_BODY
	amount        = 30
	max_amount    = 30
	tape_template = /decl/barricade_tape_template/toilet

/obj/item/stack/tape_roll/barricade_tape/toilet/verb/tear_sheet()
	set category = "Object"
	set name     = "Tear Sheet"
	set desc     = "Tear a sheet of toilet paper."
	set src in usr

	if (usr.incapacitated())
		return

	if(can_use(1))
		visible_message(SPAN_NOTICE("\The [usr] tears a sheet from \the [src]."), SPAN_NOTICE("You tear a sheet from \the [src]."))
		var/obj/item/paper/crumpled/bog/C =  new(loc)
		usr.put_in_hands(C)

////////////////////////////////////////////////////
// Toilet Paper Sheet
////////////////////////////////////////////////////
/obj/item/paper/crumpled/bog
	name       = "sheet of toilet paper"
	desc       = "A single sheet of toilet paper. Two ply."
	icon       = 'icons/obj/toiletpaper.dmi'
	icon_state = "bogroll_sheet"

/obj/structure/hygiene/faucet
	name = "faucet"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "faucet"
	desc = "An outlet for liquids. Water you waiting for?"
	anchored = 1
	drainage = 0
	clogged = -1

	var/fill_level = 500
	var/open = FALSE

/obj/structure/hygiene/faucet/attack_hand(mob/user)
	if(!user.check_dexterity(DEXTERITY_SIMPLE_MACHINES))
		return ..()
	open = !open
	if(open)
		playsound(src.loc, 'sound/effects/closet_open.ogg', 20, 1)
	else
		playsound(src.loc, 'sound/effects/closet_close.ogg', 20, 1)
	user.visible_message(SPAN_NOTICE("\The [user] has [open ? "opened" : "closed"] the faucet."))
	update_icon()
	return TRUE

/obj/structure/hygiene/faucet/on_update_icon()
	..()
	icon_state = icon_state = "[initial(icon_state)][open ? "-on" : null]"

/obj/structure/hygiene/faucet/proc/water_flow()
	if(!isturf(src.loc))
		return

	// Check for depth first, and pass if the water's too high. I know players will find a way to just submerge entire ship if I do not.
	var/turf/T = get_turf(src)

	if(!T || T.get_fluid_depth() > fill_level)
		return

	if(world.time > next_gurgle)
		next_gurgle = world.time + 80
		playsound(T, pick(SSfluids.gurgles), 50, 1)

	T.add_fluid(/decl/material/liquid/water, min(75, fill_level - T.get_fluid_depth()))

/obj/structure/hygiene/faucet/Process()
	..()
	if(open)
		water_flow()

/obj/structure/hygiene/faucet/examine(mob/user)
	. = ..()
	to_chat(user, "It is turned [open ? "on" : "off"].")
