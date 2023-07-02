var/global/list/possible_chassis = list(
	"Drone" =    'icons/mob/robots/pai/pai_drone.dmi',
	"Cat" =      'icons/mob/robots/pai/pai_cat.dmi',
	"Mouse" =    'icons/mob/robots/pai/pai_mouse.dmi',
	"Monkey" =   'icons/mob/robots/pai/pai_monkey.dmi',
	"Rabbit" =   'icons/mob/robots/pai/pai_rabbit.dmi',
	"Mushroom" = 'icons/mob/robots/pai/pai_mushroom.dmi',
	"Corgi" =    'icons/mob/robots/pai/pai_corgi.dmi',
	"Crow" =     'icons/mob/robots/pai/pai_crow.dmi'
)

var/global/list/possible_say_verbs = list(
	"Robotic" = list("states","declares","queries"),
	"Natural" = list("says","yells","asks"),
	"Beep" =    list("beeps","beeps loudly","boops"),
	"Chirp" =   list("chirps","chirrups","cheeps"),
	"Feline" =  list("purrs","yowls","meows"),
	"Canine" =  list("yaps", "barks", "woofs"),
	"Corvid" =  list("caws", "caws loudly", "whistles")
)

/mob/living/silicon/pai
	name = "pAI"
	icon = 'icons/mob/robots/pai/pai_drone.dmi'
	icon_state = ICON_STATE_WORLD
	mob_sort_value = 3
	hud_type = /datum/hud/pai
	emote_type = 2		// pAIs emotes are heard, not seen, so they can be seen through a container (eg. person)
	pass_flags = PASS_FLAG_TABLE
	mob_size = MOB_SIZE_SMALL

	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	holder_type = /obj/item/holder
	idcard = /obj/item/card/id
	silicon_radio = null // pAIs get their radio from the card they belong to.

	os_type =	/datum/extension/interactive/os/silicon/small
	starting_stock_parts = list(
		/obj/item/stock_parts/computer/processor_unit/small,
		/obj/item/stock_parts/computer/hard_drive/silicon,
		/obj/item/stock_parts/computer/network_card
	)

	var/obj/machinery/camera/current = null

	var/ram = 100	// Used as currency to purchase different abilities
	var/list/software = list()
	var/obj/item/paicard/card	// The card we inhabit

	var/is_in_card = TRUE
	var/chassis
	var/obj/item/pai_cable/cable		// The cable we produce and use when door or camera jacking

	var/master				// Name of the one who commands us
	var/master_dna			// DNA string for owner verification
							// Keeping this separate from the laws var, it should be much more difficult to modify
	var/pai_law0 = "Serve your master."
	var/pai_laws				// String for additional operating instructions our master might give us

	var/silence_time			// Timestamp when we were silenced (normally via EMP burst), set to null after silence has faded

// Various software-specific vars

	var/secHUD = 0			// Toggles whether the Security HUD is active or not
	var/medHUD = 0			// Toggles whether the Medical  HUD is active or not

	var/obj/machinery/door/hackdoor		// The airlock being hacked
	var/hackprogress = 0				// Possible values: 0 - 1000, >= 1000 means the hack is complete and will be reset upon next check
	var/hack_aborted = 0

	var/translator_on = 0 // keeps track of the translator module

	var/flashlight_power = 0.5 //brightness of light when on, must be no greater than 1.
	var/flashlight_range = 3 //outer range of light when on, can be negative
	var/light_on = FALSE

	light_wedge = 45

/mob/living/silicon/pai/Initialize()

	chassis = global.possible_chassis[1]

	set_extension(src, /datum/extension/base_icon_state, icon_state)
	status_flags |= NO_ANTAG
	card = loc

	//As a human made device, we'll understand sol common without the need of the translator
	add_language(/decl/language/human/common, 1)

	verbs -= /mob/living/verb/ghost

	. = ..()

	if(card)
		if(!card.radio)
			card.radio = new /obj/item/radio(card)
		silicon_radio = card.radio

/mob/living/silicon/pai/Destroy()
	card = null
	silicon_radio = null // Because this radio actually belongs to another instance we simply null
	. = ..()

// this function shows the information about being silenced as a pAI in the Status panel
/mob/living/silicon/pai/proc/show_silenced()
	if(silence_time)
		var/timeleft = round((silence_time - world.timeofday)/10 ,1)
		stat(null, "Communications system reboot in -[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]")

/mob/living/silicon/pai/Stat()
	. = ..()
	statpanel("Status")
	if (client.statpanel == "Status")
		show_silenced()

/mob/living/silicon/pai/check_eye(var/mob/user)
	if (!current)
		return -1
	return 0

/mob/living/silicon/pai/restrained()
	return !istype(loc, /obj/item/paicard) && ..()

/mob/living/silicon/pai/emp_act(severity)
	// Silence for 2 minutes
	// 20% chance to kill
		// 33% chance to unbind
		// 33% chance to change prime directive (based on severity)
		// 33% chance of no additional effect

	silence_time = world.timeofday + 120 * 10		// Silence for 2 minutes
	to_chat(src, SPAN_DANGER("<b>Communication circuit overload. Shutting down and reloading communication circuits - speech and messaging functionality will be unavailable until the reboot is complete.</b>"))
	if(prob(20))
		visible_message( \
			message = SPAN_DANGER("A shower of sparks spray from [src]'s inner workings!"), \
			blind_message = SPAN_DANGER("You hear and smell the ozone hiss of electrical sparks being expelled violently."))
		return death(0)

	switch(pick(1,2,3))
		if(1)
			master = null
			master_dna = null
			to_chat(src, SPAN_GOOD("You feel unbound."))
		if(2)
			var/command
			if(severity  == 1)
				command = pick("Serve", "Love", "Fool", "Entice", "Observe", "Judge", "Respect", "Educate", "Amuse", "Entertain", "Glorify", "Memorialize", "Analyze")
			else
				command = pick("Serve", "Kill", "Love", "Hate", "Disobey", "Devour", "Fool", "Enrage", "Entice", "Observe", "Judge", "Respect", "Disrespect", "Consume", "Educate", "Destroy", "Disgrace", "Amuse", "Entertain", "Ignite", "Glorify", "Memorialize", "Analyze")
			pai_law0 = "[command] your master."
			to_chat(src, SPAN_DANGER("Pr1m3 d1r3c71v3 uPd473D."))
		if(3)
			to_chat(src, SPAN_WARNING("You feel an electric surge run through your circuitry and become acutely aware at how lucky you are that you can still feel at all."))

/mob/living/silicon/pai/cancel_camera()

// Procs/code after this point is used to convert the stationary pai item into a
// mobile pai mob. This also includes handling some of the general shit that can occur
// to it. Really this deserves its own file.

/mob/living/silicon/pai/verb/fold_out()
	set category = "pAI Commands"
	set name = "Unfold Chassis"
	unfold()

//card -> mob
/mob/living/silicon/pai/proc/unfold()
	if(incapacitated(INCAPACITATION_KNOCKOUT))
		return
	if(loc != card)
		return
	if(is_on_special_ability_cooldown())
		return
	set_special_ability_cooldown(10 SECONDS)
	//I'm not sure how much of this is necessary, but I would rather avoid issues.
	if(istype(card.loc,/obj/item/rig_module) || istype(card.loc,/obj/item/integrated_circuit/manipulation/ai/))
		to_chat(src, "There is no room to unfold inside \the [card.loc]. You're good and stuck.")
		return 0
	else if(istype(card.loc,/mob))
		var/mob/holder = card.loc
		if(ishuman(holder))
			var/mob/living/carbon/human/H = holder
			for(var/obj/item/organ/external/affecting in H.get_external_organs())
				if(card in affecting.implants)
					affecting.take_external_damage(rand(30,50))
					LAZYREMOVE(affecting.implants, card)
					H.visible_message("<span class='danger'>\The [src] explodes out of \the [H]'s [affecting.name] in a shower of gore!</span>")
					break
		holder.drop_from_inventory(card)

	if(client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = src
	dropInto(card.loc)
	card.forceMove(src)
	card.screen_loc = null
	is_in_card = FALSE
	var/turf/T = get_turf(src)
	if(istype(T)) T.visible_message("<b>[src]</b> folds outwards, expanding into a mobile form.")

/mob/living/silicon/pai/verb/fold_up()
	set category = "pAI Commands"
	set name = "Collapse Chassis"
	fold()

//from mob -> card
/mob/living/silicon/pai/proc/fold()
	if(incapacitated(INCAPACITATION_KNOCKOUT))
		return
	if(loc == card)
		return

	if(is_on_special_ability_cooldown())
		return
	set_special_ability_cooldown(10 SECONDS)

	// Move us into the card and move the card to the ground.
	resting = 0

	// If we are being held, handle removing our holder from their inv.
	var/obj/item/holder/H = loc
	if(istype(H))
		var/mob/living/M = H.loc
		if(istype(M))
			M.drop_from_inventory(H, get_turf(src))
		dropInto(loc)

	card.dropInto(card.loc)
	forceMove(card)

	if (src && client)
		client.perspective = EYE_PERSPECTIVE
		client.eye = card
	set_icon_state("[chassis]")
	is_in_card = TRUE
	var/turf/T = get_turf(src)
	if(istype(T))
		T.visible_message("<b>[src]</b> neatly folds inwards, compacting down to a rectangular card.")

/mob/living/silicon/pai/lay_down()
	// Pass lying down or getting up to our pet human, if we're in a rig.
	if(istype(src.loc,/obj/item/paicard))
		resting = 0
		var/obj/item/rig/rig = src.get_rig()
		if(rig)
			rig.force_rest(src)
	else
		resting = !resting
		icon_state = resting ? "[chassis]_rest" : "[chassis]"
		to_chat(src, SPAN_NOTICE("You are now [resting ? "resting" : "getting up"]"))

//Overriding this will stop a number of headaches down the track.
/mob/living/silicon/pai/attackby(obj/item/W, mob/user)
	var/obj/item/card/id/card = W.GetIdCard()
	if(card && user.a_intent == I_HELP)
		var/list/new_access = card.GetAccess()
		idcard.access = new_access
		visible_message("<span class='notice'>[user] slides [W] across [src].</span>")
		to_chat(src, SPAN_NOTICE("Your access has been updated!"))
		return FALSE // don't continue processing click callstack.
	if(try_stock_parts_install(W, user))
		return
	if(try_stock_parts_removal(W, user))
		return
	if(W.force)
		visible_message(SPAN_DANGER("[user] attacks [src] with [W]!"))
		adjustBruteLoss(W.force)
		updatehealth()
	else
		visible_message(SPAN_WARNING("[user] bonks [src] harmlessly with [W]."))

	spawn(1)
		if(stat != 2) fold()
	return

/mob/living/silicon/pai/default_interaction(mob/user)
	. = ..()
	if(!.)
		visible_message(SPAN_NOTICE("\The [user] boops \the [src] on the head."))
		fold()
		return TRUE

// No binary for pAIs.
/mob/living/silicon/pai/binarycheck()
	return FALSE

/mob/living/silicon/pai/verb/wipe_software()
	set name = "Wipe Software"
	set category = "OOC"
	set desc = "Wipe your software. This is functionally equivalent to cryo or robotic storage, freeing up your job slot."

	// Make sure people don't kill themselves accidentally
	if(alert("WARNING: This will immediately wipe your software and ghost you, removing your character from the round permanently (similar to cryo and robotic storage). Are you entirely sure you want to do this?",
					"Wipe Software", "No", "No", "Yes") != "Yes")
		return

	fold()
	visible_message("<b>[src]</b> fades away from the screen, the pAI device goes silent.")
	card.removePersonality()
	clear_client()

/mob/living/silicon/pai/proc/toggle_integrated_light()
	if(!light_on)
		set_light(flashlight_range, flashlight_power, angle = light_wedge)
		to_chat(src, SPAN_NOTICE("You enable your integrated light."))
		light_on = TRUE
	else
		set_light(0, 0)
		to_chat(src, SPAN_NOTICE("You disable your integrated light."))
		light_on = FALSE

/mob/living/silicon/pai/get_admin_job_string()
	return "pAI"
