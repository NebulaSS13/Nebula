/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	skillset = /datum/skillset/silicon

	meat_type = null
	meat_amount = 0
	skin_material = null
	skin_amount = 0
	bone_material = null
	bone_amount = 0

	var/dexterity = DEXTERITY_FULL
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel = MAIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/radio/silicon_radio

	var/list/hud_list[10]
	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/camera/siliconcam/silicon_camera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/sensor_mode = 0 //Determines the current HUD.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/obj/item/card/id/idcard = /obj/item/card/id/synthetic
	// Various machinery stock parts used by stuff like OS (should be merged with above at some point)
	var/list/stock_parts = list()
	var/list/starting_stock_parts = list(
		/obj/item/stock_parts/computer/processor_unit,
		/obj/item/stock_parts/computer/hard_drive/silicon,
		/obj/item/stock_parts/computer/network_card
	)
	var/os_type = /datum/extension/interactive/os/silicon

	#define SEC_HUD 1 //Security HUD mode
	#define MED_HUD 2 //Medical HUD mode

/mob/living/silicon/has_dexterity(var/dex_level)
	return dexterity >= dex_level

/mob/living/silicon/Initialize()
	global.silicon_mob_list += src
	. = ..()

	if(silicon_radio)
		silicon_radio = new silicon_radio(src)
	if(silicon_camera)
		silicon_camera = new silicon_camera(src)
	for(var/T in starting_stock_parts)
		stock_parts += new T(src)
	if(os_type)
		set_extension(src, os_type)
		verbs |= /mob/living/silicon/proc/access_computer

	add_language(/decl/language/human/common)
	default_language = /decl/language/human/common
	init_id()
	init_subsystems()

/mob/living/silicon/Destroy()
	global.silicon_mob_list -= src
	QDEL_NULL(silicon_radio)
	QDEL_NULL(silicon_camera)
	QDEL_NULL(idcard)
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.unregister_alarm(src)
	QDEL_NULL_LIST(stock_parts)
	return ..()

/mob/living/silicon/fully_replace_character_name(new_name)
	..()
	create_or_update_account(new_name)
	if(istype(idcard))
		idcard.registered_name = new_name

/mob/living/silicon/proc/init_id()
	if(ispath(idcard))
		idcard = new idcard(src)
		set_id_info(idcard)

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item(var/Target)
	for(var/obj/item/grab/grab in get_active_grabs())
		qdel(grab)
		. = TRUE

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_organ_damage(0, 16, bypass_armour = TRUE)
			if(prob(50))
				SET_STATUS_MAX(src, STAT_STUN, rand(5,10))
			else
				ADJ_STATUS(src, STAT_CONFUSE, rand(2,40))
		if(2)
			src.take_organ_damage(0, 7, bypass_armour = TRUE)
			ADJ_STATUS(src, STAT_CONFUSE, rand(2,30))
	flash_eyes(affect_silicon = 1)
	to_chat(src, "<span class='danger'><B>*BZZZT*</B></span>")
	to_chat(src, "<span class='danger'>Warning: Electromagnetic pulse detected.</span>")
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, def_zone = null)

	if (istype(source, /obj/effect/containment_field))
		spark_at(loc, amount=5, cardinal_only = TRUE)

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("<span class='warning'>\The [src] was shocked by \the [source]!</span>", \
			"<span class='danger'>Energy pulse detected, system damaged!</span>", \
			"<span class='warning'>You hear an electrical crack</span>")
		if(prob(20))
			SET_STATUS_MAX(src, STAT_STUN, 2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/bullet_act(var/obj/item/projectile/Proj)

	if(!Proj.nodamage)
		switch(Proj.damage_type)
			if(BRUTE)
				adjustBruteLoss(Proj.damage)
			if(BURN)
				adjustFireLoss(Proj.damage)

	Proj.on_hit(src,100) //wow this is a terrible hack
	updatehealth()
	return 100

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return 0//The only effect that can hit them atm is flashes and they still directly edit so this works for now

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0


// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!src.stat)
		stat(null, text("System integrity: [round((health/maxHealth)*100)]%"))
	else
		stat(null, text("Systems nonfunctional"))


// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return 0

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(SSevac.evacuation_controller)
		var/eta_status = SSevac.evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	if(statpanel("Status"))
		show_emergency_shuttle_eta()
		show_system_integrity()
		show_malf_ai()
	. = ..()

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/target_zone)
	to_chat(user, "<span class='warning'>The armoured plating is too tough.</span>")
	return 0


//Silicon mob language procs

/mob/living/silicon/can_speak(decl/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	if(!ispath(language, /decl/language))
		return
	var/decl/language/added_language = GET_DECL(language)
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	if(!ispath(rem_language, /decl/language))
		return
	var/decl/language/removed_language = GET_DECL(rem_language)
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		var/decl/language/lang = GET_DECL(default_language)
		dat += "Current default language: [lang.name] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/decl/language/L in languages)
		if(!(L.flags & LANG_FLAG_NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br/>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical","Disable")
	switch(sensor_type)
		if ("Security")
			sensor_mode = SEC_HUD
			to_chat(src, "<span class='notice'>Security records overlay enabled.</span>")
		if ("Medical")
			sensor_mode = MED_HUD
			to_chat(src, "<span class='notice'>Life signs monitor overlay enabled.</span>")
		if ("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. It...", "Pose", null)  as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/explosion_act(severity)
	..()
	var/brute
	var/burn
	switch(severity)
		if(1)
			brute = 400
			burn = 100
		if(2)
			brute = 60
			burn = 60
		if(3)
			brute = 30
	apply_damage(brute, BRUTE, damage_flags = DAM_EXPLODE)
	apply_damage(burn, BURN, damage_flags = DAM_EXPLODE)

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!(alarm.alarm_z() in SSmapping.get_connected_levels(get_z(src))))
		return // Didn't actually hear it as far as we're concerned.
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, "<span class='warning'>--- [AH.category] Detected ---</span>")
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						to_chat(src, "<span class='notice'>--- [AH.category] Cleared ---</span>")
					to_chat(src, "\The [A.alarm_name()].")

		if(alarm_raised)
			to_chat(src, "<A HREF=?src=\ref[src];showalerts=1>\[Show Alerts\]</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")


/mob/living/silicon/proc/is_traitor()
	var/decl/special_role/traitors = GET_DECL(/decl/special_role/traitor)
	return mind && (mind in traitors.current_antagonists)

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow = null

/mob/living/silicon/proc/clear_client()
	//Handle job slot/tater cleanup.
	if(mind)
		if(mind.assigned_job)
			mind.assigned_job.clear_slot()
		if(mind.objectives.len)
			qdel(mind.objectives)
			mind.assigned_special_role = null
		clear_antag_roles(mind)
	ghostize(0)
	qdel(src)

/mob/living/silicon/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /obj/screen/fullscreen/flash)
	if(affect_silicon)
		return ..()

/mob/living/silicon/seizure()
	flash_eyes(affect_silicon = TRUE)

/mob/living/silicon/get_bullet_impact_effect_type(var/def_zone)
	return BULLET_IMPACT_METAL

/mob/living/silicon/proc/get_computer_network()
	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		return os.get_network()


/mob/living/silicon/proc/try_stock_parts_install(obj/item/stock_parts/W, mob/user)
	if(istype(W) && user.try_unequip(W))
		W.forceMove(src)
		stock_parts += W
		to_chat(usr, "<span class='notice'>You install the [W.name].</span>")
		return TRUE

/mob/living/silicon/proc/try_stock_parts_removal(obj/item/W, mob/user)
	if(!IS_CROWBAR(W) || user.a_intent == I_HURT)
		return
	if(!length(stock_parts))
		to_chat(user, SPAN_WARNING("No parts left to remove"))
		return

	var/obj/item/stock_parts/remove = input(user, "Which component do you want to pry out?", "Remove Component") as null|anything in stock_parts
	if(!remove || !(remove in stock_parts) || !Adjacent(user))
		return
	stock_parts -= remove
	to_chat(user, SPAN_NOTICE("You remove \the [remove]."))
	user.put_in_hands(remove)
	return TRUE

/mob/living/silicon/proc/access_computer()
	set category = "Silicon Commands"
	set name = "Boot OS Device"

	if(incapacitated())
		to_chat(src, SPAN_WARNING("You are in no state to do that right now."))
		return

	var/datum/extension/interactive/os/os = get_extension(src, /datum/extension/interactive/os)
	if(!istype(os))
		to_chat(src, SPAN_WARNING("You seem to be lacking an OS capable device!"))
		return

	if(!os.on)
		os.system_boot()
	if(!os.on)
		to_chat(src, SPAN_WARNING("ERROR: OS failed to boot."))
		return

	os.ui_interact(src)

/mob/living/silicon/get_admin_job_string()
	return "Silicon-based"

/mob/living/silicon/get_telecomms_race_info()
	return list("Artificial Life", TRUE)

/mob/living/silicon/proc/process_os()
	var/datum/extension/interactive/os = get_extension(src, /datum/extension/interactive/os)
	if(os)
		os.Process()

/mob/living/silicon/handle_flashed(var/obj/item/flash/flash, var/flash_strength)
	SET_STATUS_MAX(src, STAT_WEAK, flash_strength)
	return TRUE

/mob/living/silicon/get_speech_bubble_state_modifier()
	return "synth"
