#define BEE_SMOKE_TIME (10 SECONDS)
#define BEE_RANGE 7 //Maximum range the beehive looks for plants

////////////////////////////////////////////////////////
// Beehive
////////////////////////////////////////////////////////
/obj/structure/beehive
	name                     = "apiary"
	desc                     = "A wooden box designed specifically to house our buzzling buddies. Far more efficient than traditional hives. Just insert a frame and a queen, close it up, and you're good to go!"
	icon                     = 'icons/obj/beekeeping.dmi'
	icon_state               = "beehive-0"
	density                  = TRUE
	anchored                 = TRUE
	tool_interaction_flags   = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	parts_type               = /obj/item/beehive_assembly
	parts_amount             = 1
	material                 = /decl/material/solid/wood
	var/open                 = FALSE //Whether the lid of the hive is open
	var/bee_count            = 0
	var/tmp/max_bee_count    = 100
	var/honeycombs           = 0 // Percent
	var/tmp/notthebees       = null //Someone is currently re-enacting a scene from wickerman
	var/tmp/maxFrames        = 5 //The maximum amount of honey frames we can contain
	var/tmp/time_last_search = 0 //The time we last checked for the nearest plants.
	var/tmp/time_end_smoked  = 0 //The time when the smoked status ends or 0
	var/list/frames              //A list of honey frames we contain

/obj/structure/beehive/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/beehive/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/beehive/on_update_icon()
	cut_overlay()
	icon_state = "beehive-[open]"
	if(LAZYLEN(frames))
		add_overlay("empty[LAZYLEN(frames)]")
	if(honeycombs >= 100)
		add_overlay("full[round(honeycombs / 100)]")
	if(bee_count && REALTIMEOFDAY > time_end_smoked)
		add_overlay("bees[between(1, round(bee_count / 20), 5)]") //1 to 5.

/obj/structure/beehive/examine(mob/user)
	. = ..()
	to_chat(user, "The lid is [open? "open": "closed"].")
	to_chat(user, "There are [LAZYLEN(frames)? "[LAZYLEN(frames)] frame(s)": "no frames"] installed.")
	if(time_end_smoked >= REALTIMEOFDAY)
		to_chat(user, "The bees are smoked out.")

	//Do a skill check to get the data
	to_chat(user, SPAN_NOTICE("You start examining closely the hive.."))
	if(user.do_skilled(0.5 SECONDS, SKILL_BOTANY, src))
		//First get an accurate count or innacurate one
		var/count_msg = "\The [src]"
		if(!user.skill_fail_prob(SKILL_BOTANY, 10, SKILL_ADEPT)))
			count_msg = "[count_msg] is [bee_count ? "[round(bee_count)]% full" : "empty"]. [bee_count > 90 ? " Colony is ready to split." : ""]"
		else
			count_msg = "[count_msg] seems to [(bee_count > 0)? "have an amount of bees inside" : "be empty"]? Its hard to tell!"
		to_chat(user, count_msg)
		to_chat(user, SPAN_NOTICE("You finish examining the hive."))
	else
		to_chat(user, SPAN_WARNING("You decide against examining the hive."))

/obj/structure/beehive/proc/toggle_open(var/mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] [open ? "closes" : "opens"] \the [src]."), SPAN_NOTICE("You [open ? "close" : "open"] \the [src]."))
	open = !open
	update_icon()
	if(open)
		playsound(src, 'sound/effects/closet_open.ogg', 40)
	else
		playsound(src, 'sound/effects/closet_close.ogg', 40)

/obj/structure/beehive/attackby(var/obj/item/I, var/mob/user)

	if(istype(I, /obj/item/bee_smoker))
		return smoke_out_bees(I, user)

	if(istype(I, /obj/item/honey_frame))
		return add_frame(I, user)

	if(istype(I, /obj/item/bee_pack))
		return apply_starter_pack(I, user)

	if(istype(I, /obj/item/grab))
		return handle_grab_attack(I, user)

	if(IS_CROWBAR(I))
		to_chat(user, SPAN_WARNING("The behive is too delicate. Use a screwdriver instead!"))
		return TRUE

	return ..()

//Screwdriver dismantle makes more sense than using a crowbar
/obj/structure/beehive/handle_default_screwdriver_attackby(mob/user, obj/item/screwdriver)
	if(!can_dismantle(user))
		return 
	if(!screwdriver.do_tool_interaction(TOOL_SCREWDRIVER, user, src, 4 SECONDS))
		return
	return dismantle()

/obj/structure/beehive/proc/handle_grab_attack(var/obj/item/grab/G, var/mob/user)
	var/mob/living/GM = G.get_affecting_mob()
	if(!GM || notthebees)
		return
	if(G.target_zone != BP_HEAD)
		to_chat(user, SPAN_WARNING("You must have a head grab to do this!"))
		return
	if(!open)
		to_chat(user, SPAN_WARNING("\The [src]'s lid must be opened to do this!"))
		return
	if(bee_count < 10 || (REALTIMEOFDAY <= time_end_smoked))
		to_chat(user, SPAN_WARNING("\The [src] must contain at least 10 bees, and not have been recently smoked to do this!"))
		return

	//Prep
	notthebees = GM
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	add_fingerprint(user)

	//Do the initial message and align the mob over the hive
	user.visible_message(SPAN_DANGER("\The [user] starts jamming \the [GM]'s face into \the [src]!"), SPAN_DANGER("You start jamming \the [GM]'s face into \the [src]!"))
	GM.forceMove(get_turf(src))
	GM.set_dir(NORTH)
	GM.apply_effect(2, STUN) //knock them down, hopefully face first into the hive

	var/bee_factor = (bee_count / max_bee_count)
	var/turns = 0
	while(do_after(user, 5 SECONDS, src) && (LAZYLEN(GM.grabbed_by)) && !(QDELETED(src) || QDELETED(user) || QDELETED(G) || QDELETED(GM)) && turns < 4)
		++turns
		var/damage = (bee_factor * 8) + rand(-2, 2)
		GM.apply_effect(damage * 2, PAIN)
		GM.apply_damage(damage, BRUTE, BP_HEAD, 0, "bee stings", 0, TRUE)
		GM.emote("scream")
		ADJ_STATUS(GM, STAT_JITTER, 10 * bee_factor)

	//If something gets deleted meanwhile just return early
	if(QDELETED(GM) || QDELETED(G) || QDELETED(src) || QDELETED(user) || !LAZYLEN(GM.grabbed_by))
		notthebees = null
		return

	//Post attack
	if(turns > 0)
		GM.add_chemical_effect(CE_TOXIN, 1) //Bee venom
	if(turns >= 4 && (bee_count >= (max_bee_count / 2)) && prob(10 * bee_factor))
		var/obj/item/organ/external/h = GM.get_organ(BP_HEAD)
		if(h)
			h.disfigure(PAIN) //Set it to PAIN since otherwise it has pre-written flavor text that completely doesn't fit the situation
			user.visible_message(SPAN_DANGER("\The [GM]'s [h] has swollen beyond recognition!"))

	//Just drop it next to the hive so they don't get stuck
	GM.forceMove(get_turf(user))
	GM.apply_effect(1, STUN) //Just knock them for a bit so they're not standing up on the same turf as the user
	user.visible_message(SPAN_NOTICE("\The [user] dislodge \the [GM] from \the [src]!"))
	notthebees = null
	return TRUE

/obj/structure/beehive/attack_hand(var/mob/user)
	if(open)
		return remove_frame(user)
	return ..()

/obj/structure/beehive/AltClick(mob/user)
	. = ..()
	return toggle_open(user)

/obj/structure/beehive/Process()
	if((REALTIMEOFDAY > time_end_smoked) && bee_count)
		//#TODO: I just left this as it is, but it seems like this processes too fast, and is generally really gross
		pollinate_flowers()
		bee_count = min(bee_count * 1.005, max_bee_count) //Bees count just increases super fast to 100
		update_icon()

/obj/structure/beehive/proc/pollinate_flowers()
	var/coef = bee_count / 100
	var/trays = 0
	for(var/obj/machinery/portable_atmospherics/hydroponics/H in view(BEE_RANGE, src)) //#TODO: Seems really intensive to do that each tick

		if(H.seed && !H.dead)
			H.health += 0.05 * coef
			++trays
	honeycombs = min(honeycombs + 0.1 * coef * min(trays, 5), LAZYLEN(frames) * 100)

/obj/structure/beehive/proc/smoke_out_bees(var/obj/item/bee_smoker/B, var/mob/user)
	if(!open)
		to_chat(user, SPAN_WARNING("You need to open \the [src] first before smoking the bees."))
		return
	if(time_end_smoked > REALTIMEOFDAY)
		to_chat(user, SPAN_WARNING("There's enough smoke already!"))
		return
	user.visible_message(SPAN_NOTICE("\The [user] smokes the bees in \the [src]."), SPAN_NOTICE("You smoke the bees in \the [src]."))
	time_end_smoked = REALTIMEOFDAY + BEE_SMOKE_TIME
	new/obj/effect/effect/smoke/bees(get_turf(src))
	update_icon()
	return TRUE

/obj/structure/beehive/proc/add_frame(var/obj/item/honey_frame/H, var/mob/user)
	if(!open)
		to_chat(user, SPAN_NOTICE("You need to open \the [src] first before inserting \the [H]."))
		return
	if(LAZYLEN(frames) >= maxFrames)
		to_chat(user, SPAN_NOTICE("There is no room for another frame."))
		return

	user.visible_message(SPAN_NOTICE("\The [user] starts placing \the [H] into \the [src]."), SPAN_NOTICE("You start placing \the [H] into of \the [src]..."))
	if(user.do_skilled(2 SECONDS, SKILL_BOTANY, src) && user.unEquip(H, src) && !(QDELETED(src) || QDELETED(user) || QDELETED(H)))
		LAZYADD(frames, H)
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [H] into \the [src]."), SPAN_NOTICE("You load \the [H] into \the [src]."))
		update_icon()
		return TRUE

/obj/structure/beehive/proc/remove_frame(var/mob/user)
	if(!LAZYLEN(frames))
		to_chat(user, SPAN_NOTICE("There's nothing to remove from the hive. Add some frames!"))
		return
	if((time_end_smoked <= REALTIMEOFDAY) && bee_count)
		to_chat(user, SPAN_WARNING("The bees won't let you take anything out like this, smoke them first."))
		return

	var/obj/item/honey_frame/H = LAZYACCESS(frames, LAZYLEN(frames))
	user.visible_message(SPAN_NOTICE("\The [user] starts taking \the [H] out of \the [src]."), SPAN_NOTICE("You start taking \the [H] out of \the [src]..."))
	if(user.do_skilled(3 SECONDS, SKILL_BOTANY, src) && !(QDELETED(src) || QDELETED(user) || QDELETED(H)))
		LAZYREMOVE(frames, H)
		user.put_in_hands(H)
		user.visible_message(SPAN_NOTICE("\The [user] removed \the [H] out of \the [src]."), SPAN_NOTICE("You removed \the [H] out of \the [src]..."))
		update_icon()
		return TRUE

/obj/structure/beehive/proc/apply_starter_pack(var/obj/item/bee_pack/B, var/mob/user)
	if(!open)
		to_chat(user, SPAN_NOTICE("You need to open \the [src] before moving the bees."))
		return
	if(B.full)
		if(bee_count)
			to_chat(user, SPAN_NOTICE("\The [src] already has bees inside."))
			return
		if(user.do_skilled(5 SECONDS, SKILL_BOTANY, src) && !(QDELETED(user) || QDELETED(src) || QDELETED(B)) && B.full)
			user.visible_message(SPAN_NOTICE("\The [user] puts the queen and the bees from \the [B] into \the [src]."), SPAN_NOTICE("You put the queen and the bees from \the [B] into \the [src]."))
			bee_count = 20
			B.empty()
	else
		if(bee_count < 90)
			to_chat(user, SPAN_NOTICE("\The [src] is not ready to split."))
			return
		if((REALTIMEOFDAY > time_end_smoked))
			to_chat(user, SPAN_NOTICE("Smoke \the [src] first!"))
			return
		if(user.do_skilled(5 SECONDS, SKILL_BOTANY, src) && !(QDELETED(user) || QDELETED(src) || QDELETED(B)) && !B.full && (bee_count >= 90))
			user.visible_message(SPAN_NOTICE("\The [user] puts bees and larvae from \the [src] into \the [B]."), SPAN_NOTICE("You put bees and larvae from \the [src] into \the [B]."))
			bee_count /= 2
			B.fill()

	update_icon()
	return TRUE

////////////////////////////////////////////////////////
// Honey Extractor
////////////////////////////////////////////////////////
/obj/machinery/honey_extractor
	name                           = "honey extractor"
	desc                           = "A machine used to extract honey and wax from a beehive frame."
	icon                           = 'icons/obj/virology.dmi'
	icon_state                     = "centrifuge"
	anchored                       = TRUE
	density                        = TRUE
	construct_state                = /decl/machine_construction/default/panel_closed
	uncreated_component_parts      = list(/obj/item/stock_parts/power/apc/buildable = 1)
	stat_immune                    = NOSCREEN | NOINPUT
	idle_power_usage               = 0 //W
	active_power_usage             = 750 //W == ~1HP electric motor
	required_interaction_dexterity = DEXTERITY_SIMPLE_MACHINES
	core_skill                     = SKILL_BOTANY
	waterproof                     = FALSE
	var/time_done_processing       = 0
	var/tmp/max_frames             = 10
	var/list/loaded_frames

/obj/machinery/honey_extractor/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(500)

/obj/machinery/honey_extractor/dump_contents()
	. = ..()
	if(reagents?.total_volume)
		reagents.trans_to_turf(get_turf(src), reagents.total_volume)

/obj/machinery/honey_extractor/components_are_accessible(path)
	return (REALTIMEOFDAY > time_done_processing) && ..()

/obj/machinery/honey_extractor/cannot_transition_to(state_path, mob/user)
	if(time_done_processing >= REALTIMEOFDAY)
		return SPAN_NOTICE("You must wait for \the [src] to finish first!")
	return ..()

/obj/machinery/honey_extractor/attackby(var/obj/item/I, var/mob/user)
	if(time_done_processing >= REALTIMEOFDAY)
		to_chat(user, SPAN_NOTICE("\The [src] is currently spinning, wait until it's finished."))
		return

	if(istype(I, /obj/item/honey_frame) && (LAZYLEN(loaded_frames) < max_frames))
		var/obj/item/honey_frame/H = I
		if(!H.honey)
			to_chat(user, SPAN_NOTICE("\The [H] is empty, put it into a beehive."))
			return
		LAZYDISTINCTADD(loaded_frames, H)
		user.unEquip(H, src)
		user.visible_message(SPAN_NOTICE("\The [user] loads \the [H] into \the [src]."), SPAN_NOTICE("You load \the [H] into \the [src]."))
		return TRUE

	else if(istype(I, /obj/item/chems/glass))
		if(reagents?.total_volume < 1)
			to_chat(user, SPAN_NOTICE("There is no honey in \the [src]."))
			return
		var/obj/item/chems/glass/G = I
		var/transferred = min(G.reagents.maximum_volume - G.reagents.total_volume, reagents.total_volume)
		reagents.trans_to_obj(I, transferred)
		user.visible_message(SPAN_NOTICE("\The [user] collects honey from \the [src] into \the [G]."), SPAN_NOTICE("You collect [transferred] units of honey from \the [src] into \the [G]."))
		return TRUE
	return ..()

/obj/machinery/honey_extractor/physical_attack_hand(mob/user)
	if(inoperable())
		return
	if(time_done_processing > REALTIMEOFDAY)
		to_chat(user, SPAN_WARNING("Wait until \the [src] stops processing first!"))
		return
	if(LAZYLEN(loaded_frames))
		var/choice = show_radial_menu(user, src, list("turn on", "remove a frame", "remove all frames"))
		switch(choice)
			if("turn on")
				START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
				time_done_processing = REALTIMEOFDAY + 10 SECONDS
				update_use_power(POWER_USE_ACTIVE)
				update_icon()
				return TRUE

			if("remove a frame")
				var/obj/item/honey_frame/H = loaded_frames[loaded_frames.len]
				LAZYREMOVE(loaded_frames, H)
				user.put_in_hands(H)
				user.visible_message(SPAN_NOTICE("\The [user] take \a [H] from \the [src]."), SPAN_NOTICE("You take \a [H] from \the [src]."))
				return TRUE

			if("remove all frames")
				user.visible_message(SPAN_NOTICE("\The [user] begins to remove the honey frames from \the [src]."), SPAN_NOTICE("You begin removing the honey frames from \the [src]."))
				if(user.do_skilled(6 SECONDS, SKILL_BOTANY) && !(QDELETED(src) || QDELETED(user)) && LAZYLEN(loaded_frames))
					for(var/obj/I in loaded_frames)
						user.put_in_hands(I)
					LAZYCLEARLIST(loaded_frames)
					user.visible_message(SPAN_NOTICE("\The [user] removed all honey frames from \the [src]."), SPAN_NOTICE("You removed all honey frames from \the [src]."))
					return TRUE
				else
					user.visible_message(SPAN_NOTICE("\The [user] stops removing honey frames from \the [src]."), SPAN_NOTICE("You stop removing honey frames from \the [src]."))
	else
		to_chat(user, SPAN_WARNING("There are no honey frames in \the [src]!"))

/obj/machinery/honey_extractor/on_update_icon()
	if(time_done_processing > REALTIMEOFDAY && operable())
		icon_state = "centrifuge_moving"
	else
		icon_state = "centrifuge"

/obj/machinery/honey_extractor/Process()
	//Just abort the current batch if we lose power
	if(inoperable())
		time_done_processing = 0
		on_update_icon()
		return PROCESS_KILL

	if(REALTIMEOFDAY >= time_done_processing && LAZYLEN(loaded_frames))
		extract_honey()
		update_use_power(POWER_USE_IDLE)
		return PROCESS_KILL

/obj/machinery/honey_extractor/proc/extract_honey()
	if(!LAZYLEN(loaded_frames))
		return
	var/decl/material/M = GET_DECL(/decl/material/solid/wax/bees)
	M.create_object(loc, LAZYLEN(loaded_frames), /obj/item/stack/material/puck)
	for(var/obj/item/honey_frame/F in loaded_frames)
		reagents.add_reagent(/decl/material/liquid/nutriment/honey, F.honey)
		F.honey = 0
	on_update_icon()

////////////////////////////////////////////////////////
// Bee Smoker
////////////////////////////////////////////////////////
/obj/item/bee_smoker
	name        = "bee smoker"
	desc        = "A device used to calm down bees before harvesting honey."
	icon        = 'icons/obj/items/weapon/batterer.dmi'
	icon_state  = "battererburnt"
	w_class     = ITEM_SIZE_SMALL
	material    = /decl/material/solid/metal/steel
	force       = 4
	attack_verb = list("smoked", "infumated")

/obj/item/bee_smoker/attack(mob/living/M, mob/living/user, target_zone, animate)
	. = ..()
	//Sometimes smoke the guy that got hit
	if(. && prob(50))
		var/turf/T = get_turf(M)
		if(!(locate(/obj/effect/effect/smoke/bees) in T))
			new/obj/effect/effect/smoke/bees(T)

/obj/effect/effect/smoke/bees
	time_to_live = BEE_SMOKE_TIME

////////////////////////////////////////////////////////
// Honey Frame
////////////////////////////////////////////////////////
/obj/item/honey_frame
	name              = "beehive frame"
	desc              = "A frame for the beehive that the bees will fill with honeycombs."
	icon              = 'icons/obj/beekeeping.dmi'
	icon_state        = "honeyframe"
	w_class           = ITEM_SIZE_SMALL
	material          = /decl/material/solid/wood
	var/honey         = 0
	var/tmp/max_honey = 20

/obj/item/honey_frame/on_update_icon()
	cut_overlays()
	if(honey >= (max_honey / 2))
		overlays += "honeycomb"
		name     = "filled beehive frame"
	else
		name = initial(name)

//filled
/obj/item/honey_frame/filled/Initialize()
	. = ..()
	honey = max_honey

////////////////////////////////////////////////////////
// Beehive Assembly
////////////////////////////////////////////////////////
/obj/item/beehive_assembly
	name       = "beehive assembly"
	desc       = "Contains everything you need to assemble a beehive."
	icon       = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "apiary"
	material   = /decl/material/solid/wood
	w_class    = ITEM_SIZE_LARGE

/obj/item/beehive_assembly/attack_self(var/mob/user)
	to_chat(user, SPAN_NOTICE("You start assembling a beehive..."))
	if(user.do_skilled(8 SECONDS, SKILL_BOTANY))
		user.visible_message(SPAN_NOTICE("\The [user] assembles a beehive."), SPAN_NOTICE("You assemble a beehive."))
		new /obj/structure/beehive(get_turf(user))
		user.unEquip(src, null)
		qdel(src)

////////////////////////////////////////////////////////
// Bee Starter Pack
////////////////////////////////////////////////////////
/obj/item/bee_pack
	name       = "bee pack"
	desc       = "A stasis pack for moving bees."
	icon       = 'icons/obj/beekeeping.dmi'
	icon_state = "beepack"
	material   = /decl/material/solid/plastic
	w_class    = ITEM_SIZE_SMALL
	var/full   = TRUE

/obj/item/bee_pack/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(full)
		to_chat(user, SPAN_NOTICE("Contains a queen bee and some worker bees. Everything you'll need to start a hive!"))
	else
		to_chat(user, SPAN_NOTICE("It's empty."))

/obj/item/bee_pack/on_update_icon()
	cut_overlays()
	if(full)
		overlays += "beepack-full"
	else
		overlays += "beepack-empty"

/obj/item/bee_pack/proc/empty()
	full = FALSE
	update_icon()

/obj/item/bee_pack/proc/fill()
	full = TRUE
	update_icon()

////////////////////////////////////////////////////////
// Beekeeper crate
////////////////////////////////////////////////////////
/obj/structure/closet/crate/hydroponics/beekeeping
	name = "beekeeping crate"
	desc = "All you need to set up your own beehive."

/obj/structure/closet/crate/hydroponics/beekeeping/WillContain()
	return list(
		/obj/item/beehive_assembly = 1,
		/obj/item/bee_smoker       = 1,
		/obj/item/honey_frame      = 5,
		/obj/item/bee_pack         = 1,
		/obj/item/screwdriver      = 1,
	)

#undef BEE_SMOKE_TIME
#undef BEE_RANGE
