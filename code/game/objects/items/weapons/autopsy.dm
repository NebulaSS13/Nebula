
//moved these here from code/defines/obj/weapon.dm
//please preference put stuff where it's easy to find - C
/obj/item/scanner/autopsy
	name = "autopsy scanner"
	desc = "Used to gather information on wounds."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "autopsy_scanner"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	w_class = ITEM_SIZE_SMALL
	origin_tech = "{'materials':1,'biotech':1}"
	var/list/weapon_data = list()
	var/list/chemtraces = list()
	var/target_name
	var/timeofdeath

/obj/item/scanner/autopsy/is_valid_scan_target(atom/O)
	return ishuman(O) || istype(O, /obj/item/organ/external)

/obj/item/scanner/autopsy/do_surgery(mob/living/carbon/M, mob/living/user, fuckup_prob)
	if(istype(M))
		scan(M,user)

/obj/item/scanner/autopsy/scan(atom/A, mob/user)
	if(ishuman(A))
		var/mob/living/carbon/human/M = A
		set_target(M, user)
		timeofdeath = M.timeofdeath
		var/obj/item/organ/external/S = GET_EXTERNAL_ORGAN(M, user.get_target_zone())
		if(!S)
			visible_message(SPAN_WARNING("[src] states, 'The targeted bodypart is missing.'"))
			return
		if(!S.how_open())
			visible_message(SPAN_WARNING("[src] states, 'The access incision is missing.'"))
			return

		add_data(S)
		for(var/T in M.chem_doses)
			var/decl/material/R = T
			chemtraces |= initial(R.name)

	else if(istype(A, /obj/item/organ/external))
		set_target(A, user)
		add_data(A)

	scan_title = "Autopsy Report ([target_name])"
	scan_data = get_formatted_data()
	playsound(src, 'sound/effects/fastbeep.ogg', 10)

/obj/item/scanner/autopsy/proc/add_data(var/obj/item/organ/external/O)
	if(!O.autopsy_data.len) return

	for(var/V in O.autopsy_data)
		var/datum/autopsy_data/W = O.autopsy_data[V]
		if(!weapon_data[V])
			weapon_data[V] = list("data" = W.copy(), "organs" = list(O.name))
		else
			var/datum/autopsy_data/data = weapon_data[V]["data"]
			data.merge_with(W)
			var/list/organs = weapon_data[V]["organs"]
			organs |= O.name

/obj/item/scanner/autopsy/proc/get_formatted_data()
	var/list/scan_data = list("Subject: [target_name]")

	if(timeofdeath)
		scan_data += "<b>Time of death:</b> [worldtime2stationtime(timeofdeath)]<br>"

	var/n = 1
	for(var/weapon in weapon_data)
		var/list/organs = weapon_data[weapon]["organs"]
		var/datum/autopsy_data/data = weapon_data[weapon]["data"]
		scan_data += "<b>Weapon #[n++]:</b> [data.weapon]"
		if(data.hits)
			var/damage_desc
			switch(data.damage)
				if(0)
					damage_desc = "Unknown"
				if(1 to 5)
					damage_desc = "<font color='green'>negligible</font>"
				if(5 to 15)
					damage_desc = "<font color='green'>light</font>"
				if(15 to 30)
					damage_desc = "<font color='orange'>moderate</font>"
				if(30 to 1000)
					damage_desc = "<font color='red'>severe</font>"
			scan_data += "<b>Severity:</b> [damage_desc]"
			scan_data += "<b>Hits by weapon:</b> [data.hits]"
		scan_data += "<b>Approximate time of wound infliction:</b> [worldtime2stationtime(data.time_inflicted)]"
		scan_data += "<b>Affected limbs:</b> [english_list(organs)]"
		scan_data += ""

	if(chemtraces.len)
		scan_data += "<b>Trace Chemicals:</b>"
		for(var/chemID in chemtraces)
			scan_data += chemID
	return jointext(scan_data, "<br>")

/obj/item/scanner/autopsy/proc/set_target(atom/new_target, user)
	if(target_name != new_target.name)
		target_name = new_target.name
		weapon_data.Cut()
		chemtraces.Cut()
		timeofdeath = null
		to_chat(user, SPAN_NOTICE("A new patient has been registered. Purging data for previous patient."))

/datum/autopsy_data
	var/weapon = null
	var/damage = 0
	var/hits = 0
	var/time_inflicted = 0

/datum/autopsy_data/proc/copy()
	var/datum/autopsy_data/W = new()
	W.weapon = weapon
	W.damage = damage
	W.hits = hits
	W.time_inflicted = time_inflicted
	return W

/datum/autopsy_data/proc/merge_with(var/datum/autopsy_data/other)
	damage += other.damage
	hits += other.hits
	time_inflicted = max(time_inflicted, other.time_inflicted)