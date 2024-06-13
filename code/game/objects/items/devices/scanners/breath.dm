/obj/item/scanner/breath
	name = "breath analyzer"
	desc = "A two-in-one breathalyzer and respirometer, measuring intoxication, breath contents, and respiratory health."
	icon = 'icons/obj/items/device/scanner/breath_scanner.dmi'
	item_flags = ITEM_FLAG_NO_BLUDGEON
	material = /decl/material/solid/metal/aluminium
	origin_tech = @'{"biotech":1}'
	printout_color = "#deebff"
	var/mode = 1

/obj/item/scanner/breath/is_valid_scan_target(atom/O)
	if(isliving(O))
		var/mob/living/M = O
		return !!M.get_inhaled_reagents()
	return FALSE

/obj/item/scanner/breath/scan(atom/A, mob/user)
	scan_data = breath_scan_action(A, user, src, mode)
	playsound(src, 'sound/effects/fastbeep.ogg', 20)

/proc/breath_scan_action(mob/living/target, mob/living/user, obj/scanner, var/verbose)
	if (!user.check_dexterity(DEXTERITY_COMPLEX_TOOLS) || !istype(target))
		return

	. = breath_scan_results(target, verbose, user.get_skill_value(SKILL_MEDICAL))
	to_chat(user, "<hr>")
	to_chat(user, .)
	to_chat(user, "<hr>")

/proc/breath_scan_results(var/mob/living/target, var/verbose, var/skill_level = SKILL_DEFAULT)
	. = list()
	var/header = list()
	var/b
	var/endb
	var/dat = list()

	if(skill_level >= SKILL_BASIC)
		header += "<style> .scan_notice{color: #5f94af;}</style>"
		header += "<style> .scan_warning{color: #ff0000; font-style: italic;}</style>"
		header += "<style> .scan_danger{color: #ff0000; font-weight: bold;}</style>"
		header += "<style> .scan_red{color:red}</style>"
		header += "<style> .scan_green{color:green}</style>"
		header += "<style> .scan_blue{color: #5f94af}</style>"
		header += "<style> .scan_orange{color:#ffa500}</style>"
		b		= "<b>"
		endb	= "</b>"

	. += "[b]Breath sample results for \the [target]:[endb]"

	var/obj/item/organ/internal/lungs/lungs = target.get_organ(BP_LUNGS)
	var/breathing = "none"
	if(istype(lungs) && !(target.status_flags & FAKEDEATH))
		if(lungs.breath_fail_ratio < 0.3)
			breathing = "normal"
		else if(lungs.breath_fail_ratio < 1)
			breathing = "shallow"

	switch(breathing)
		if("none")
			. += "<span class='scan_danger'>Alert: No breathing detected.</span>"
			return
		if("shallow")
			. += "<span class='scan_warning'>Subject's breathing is abnormally shallow.</span>"
		if("normal")
			. += "<span class='scan_notice'>Subject's breathing is normal.</span>"

	// Other general warnings.
	if(skill_level >= SKILL_BASIC)
		switch(target.get_damage(OXY))
			if(0 to 25)
				dat += "<span class='scan_green'>Subject oxygen levels nominal.</span>"
			if(25 to 50)
				dat += "<span class='scan_orange'>Subject oxygen levels abnormal.</span>"
			if(50 to INFINITY)
				dat += "<span class='scan_blue'>[b]Severe oxygen deprivation detected.[endb]</span>"

		if(istype(lungs))
			if(lungs.is_broken())
				dat += "<span class='scan_danger'>[b]Tension pneumothorax detected.[endb]</span>"
			else if(lungs.is_bruised())
				dat += "<span class='scan_warning'>Collapsed lung detected.</span>"
			else
				dat += "<span class='scan_green'>Subject lung health nominal.</span>"
		else
			dat += "<span class='scan_warning'>Subject lung health unknown.</span>"

	. += (skill_level < SKILL_BASIC) ? shuffle(dat) : dat

	// Reagent data.
	. += "[b]Reagent scan:[endb]"

	var/print_reagent_default_message = TRUE
	if (target.has_chemical_effect(CE_ALCOHOL, 1))
		. += "<span class='scan_orange'>Alcohol detected in subject's breath.</span>"
		print_reagent_default_message = FALSE
	if (target.has_chemical_effect(CE_ALCOHOL_TOXIC, 1))
		. += "<span class='scan_red'>Subject is suffering from alcohol poisoning.</span>"
		print_reagent_default_message = FALSE

	var/datum/reagents/inhaled = target.get_inhaled_reagents()
	if(inhaled && inhaled.total_volume)
		var/unknown = 0
		for(var/rtype in inhaled.reagent_volumes)
			var/decl/material/R = GET_DECL(rtype)
			if(R.scannable)
				print_reagent_default_message = FALSE
				. += "<span class='scan_notice'>[capitalize(R.gas_name)] found in subject's breath.</span>"
			else
				++unknown
		if(unknown)
			print_reagent_default_message = FALSE
			. += "<span class='scan_warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's breath.</span>"

	if(print_reagent_default_message)
		. += "No results."

	header = jointext(header, null)
	. = jointext(.,"<br>")
	. = jointext(list(header,.),null)