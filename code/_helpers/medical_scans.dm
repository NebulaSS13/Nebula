/mob/living/proc/get_raw_medical_data(var/tag = FALSE)
	. = list()
	.["name"] = name
	.["time"] = stationtime2text()
	var/brain_result
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain = GET_INTERNAL_ORGAN(src, BP_BRAIN)
		if(!brain || stat == DEAD || (status_flags & FAKEDEATH))
			brain_result = 0
		else if(stat != DEAD)
			brain_result = round(max(0,(1 - brain.get_organ_damage() / brain.max_damage)*100))
	else
		brain_result = -1
	.["brain_activity"] = brain_result

	var/pulse_result
	if(should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = get_organ(BP_HEART, /obj/item/organ/internal/heart)
		if(!heart)
			pulse_result = 0
		else if(BP_IS_PROSTHETIC(heart))
			pulse_result = -2
		else if(status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = get_pulse_as_string(GETPULSE_TOOL)
	else
		pulse_result = -1

	if(pulse_result == ">250")
		pulse_result = -3
	.["pulse"] = text2num(pulse_result)

	.["temperature"] =      bodytemperature
	.["trauma"] =           get_damage(BRUTE)
	.["burn"] =             get_damage(BURN)
	.["toxin"] =            get_damage(TOX)
	.["oxygen"] =           get_damage(OXY)
	.["radiation"] =        radiation
	.["genetic"] =          get_damage(CLONE)
	.["paralysis"] =        GET_STATUS(src, STAT_PARA)
	.["immune_system"] =    get_immunity()
	.["reagents"] = list()

	if(REAGENT_TOTAL_VOLUME(reagents))
		for(var/decl/material/reagent as anything in REAGENT_LIQUID_VOLUMES(reagents))
			var/list/reagent_data = list()
			reagent_data["name"]      = reagent.get_reagent_name(reagents, MAT_PHASE_LIQUID)
			reagent_data["quantity"]  = round(REAGENT_VOLUME(reagents, reagent),1)
			reagent_data["scannable"] = reagent.scannable
			.["reagents"] += list(reagent_data)
		for(var/decl/material/reagent as anything in REAGENT_SOLID_VOLUMES(reagents))
			var/list/reagent_data = list()
			reagent_data["name"]      = reagent.get_reagent_name(reagents, MAT_PHASE_SOLID)
			reagent_data["quantity"]  = round(REAGENT_VOLUME(reagents, reagent),1)
			reagent_data["scannable"] = reagent.scannable
			.["reagents"] += list(reagent_data)

	.["external_organs"] = list()
	for(var/obj/item/organ/external/limb in get_external_organs())
		var/list/O =               list()
		O["name"] =                limb.name
		O["brute_ratio"] =         limb.brute_ratio
		O["burn_ratio"] =          limb.burn_ratio
		O["limb_flags"] =          limb.limb_flags
		O["brute_dam"] =           limb.brute_dam
		O["burn_dam"] =            limb.burn_dam
		O["scan_results"] =        limb.get_scan_results(tag)
		O["tumors"] =              limb.has_growths()
		O["ailments"] =            limb.has_diagnosable_ailments(scanner = TRUE)
		.["external_organs"] += list(O)

	.["internal_organs"] = list()
	var/list/internal_organs = get_internal_organs()
	for(var/obj/item/organ/internal/organ in internal_organs)
		var/list/O =               list()
		O["name"] =                organ.name
		O["is_broken"] =           organ.is_broken()
		O["is_bruised"] =          organ.is_bruised()
		O["is_damaged"] =          organ.get_organ_damage() > 0
		O["scan_results"] =        organ.get_scan_results(tag)
		O["ailments"] =            organ.has_diagnosable_ailments(scanner = TRUE)
		.["internal_organs"] += list(O)

	.["missing_organs"] = list()
	var/decl/bodytype/root_bodytype = get_bodytype()
	for(var/organ_name in root_bodytype.has_organ)
		if(!GET_INTERNAL_ORGAN(src, organ_name))
			.["missing_organs"] += organ_name
	if(has_genetic_condition(GENE_COND_BLINDED))
		.["blind"] = TRUE
	if(has_genetic_condition(GENE_COND_NEARSIGHTED))
		.["nearsight"] = TRUE

/mob/living/human/get_raw_medical_data(var/tag = FALSE)
	. = ..()
	.["blood_pressure"] =   get_blood_pressure()
	.["blood_o2"] =         get_blood_oxygenation()
	if(vessel)
		.["blood_volume"] =     REAGENT_TOTAL_VOLUME(vessel)
		.["blood_volume_max"] = REAGENT_MAXIMUM_VOLUME(vessel)

/proc/display_medical_data_header(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	var/dat = list()

	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	//Table definition and starting data block.
	/*
	<!--Clean HTML Formatting-->
	<table class="block" width="95%">
		<tr><td><strong>Scan Results For:</strong></td><td>Name</td></tr>
		<tr><td><strong>Scan Performed At:</strong></td><td>00:00</td></tr>
	*/
	dat += "<table class='block' width='95%'>"
	dat += "<tr><td><strong>Scan Results For:</strong></td><td>[scan["name"]]</td></tr>"
	dat += "<tr><td><strong>Scan performed at:</strong></td><td>[scan["time"]]</td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data_health(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()

	//Brain activity
	/*
		<tr><td><strong>Brain Activity:</strong></td><td>100%</td></tr>
	*/
	dat += "<tr><td><strong>Brain activity:</strong></td>"
	switch(scan["brain_activity"])
		if(0)
			dat += "<td><span class='bad'>none, patient is braindead</span></td></tr>"
		if(-1)
			dat += "<td><span class='average'>ERROR - Nonstandard biology</span></td></tr>"
		else
			if(skill_level >= SKILL_BASIC)
				if(scan["brain_activity"] <= 50)
					dat += "<td><span class='bad'>[scan["brain_activity"]]%</span></td></tr>"
				else if(scan["brain_activity"] <= 80)
					dat += "<td><span class='average'>[scan["brain_activity"]]%</span></td></tr>"
				else
					dat += "<td>[scan["brain_activity"]]%</td></tr>"
			else
				dat += "<td>there's a squiggly line here</td></tr>"

	//Circulatory System
	/*
		<tr><td><strong>Pulse Rate:</strong></td><td>75bpm</td></tr>
		<tr><td colspan='2'><span class='average'>Patient is tachycardic.</span></td></tr>
		<tr><td><strong>Blood Pressure:</strong></td><td>120/80 (100% oxygenation)</td></tr>
		<tr><td><strong>Blood Volume:</strong></td><td>560u/560u</td></tr>
		<tr><td colspan="2" align="center"><span class='bad'>Patient in Hypovolemic Shock. Transfusion highly recommended.</span></td></tr>
	*/
	dat += "<tr><td><strong>Pulse rate:</strong></td>"
	if(scan["pulse"] == -1)
		dat += "<td><span class='average'>ERROR - Nonstandard biology</span></td></tr>"
	else if(scan["pulse"] == -2)
		dat += "<td>N/A</td></tr>"
	else if(scan["pulse"] == -3)
		dat += "<td><span class='bad'>250+bpm</span></td></tr>"
	else if(scan["pulse"] == 0)
		dat += "<td><span class='bad'>[scan["pulse"]]bpm</span></td></tr>"
	else if(scan["pulse"] >= 140)
		dat += "<td><span class='bad'>[scan["pulse"]]bpm</span></td></tr>"
	else if(scan["pulse"] >= 120)
		dat += "<td><span class='average'>[scan["pulse"]]bpm</span></td></tr>"
	else
		dat += "<td>[scan["pulse"]]bpm</td></tr>"
	if(skill_level >= SKILL_ADEPT)
		if((scan["pulse"] >= 140) || (scan["pulse"] == -3))
			dat+= "<tr><td colspan='2'><span class='bad'>Patient is tachycardic.</span></td></tr>"
		else if(scan["pulse"] >= 120)
			dat += "<tr><td colspan='2'><span class='average'>Patient is tachycardic.</span></td></tr>"
		else if(scan["pulse"] == 0)
			dat+= "<tr><td colspan='2'><span class='bad'>Patient's heart is stopped.</span></td></tr>"
		else if((scan["pulse"] > 0) && (scan["pulse"] <= 40))
			dat+= "<tr><td colspan='2'><span class='average'>Patient is bradycardic.</span></td></tr>"


	if(scan["blood_volume_max"] > 0)
		var/ratio = scan["blood_volume"]/scan["blood_volume_max"]
		dat += "<tr><td><strong>Blood pressure:</strong></td><td>[scan["blood_pressure"]]"
		if(scan["blood_o2"] <= 70)
			dat += "(<span class='bad'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
		else if(scan["blood_o2"] <= 85)
			dat += "(<span class='average'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
		else if(scan["blood_o2"] <= 90)
			dat += "(<span class='oxyloss'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
		else
			dat += "([scan["blood_o2"]]% blood oxygenation)</td></tr>"

		dat += "<tr><td><strong>Blood volume:</strong></td><td>[scan["blood_volume"]]u/[scan["blood_volume_max"]]u</td></tr>"

		if(skill_level >= SKILL_ADEPT)
			if(ratio <= 0.70)
				dat += "<tr><td colspan='2'><span class='bad'>Patient is in Hypovolemic Shock. Transfusion highly recommended.</span></td></tr>"
	else
		dat += "<tr><td><strong>Blood pressure:</strong></td><td><span class='average'>ERROR - Patient has lacks a circulatory system.</span></td></tr>"
		dat += "<tr><td><strong>Blood volume:</strong></td><td><span class='average'>ERROR - Patient has lacks a circulatory system.</span></td></tr>"

	// Body temperature.
	/*
		<tr><td><strong>Body Temperature:</strong></td><td>40&deg;C (98.6&deg;F)</td></tr>
	*/
	dat += "<tr><td><strong>Body temperature:</strong></td><td>[scan["temperature"]-T0C]&deg;C ([scan["temperature"]*1.8-459.67]&deg;F)</td></tr>"

	//Information Summary
	/*
		<tr><td><strong>Physical Trauma:</strong></td><td>severe</td></tr>
		<tr><td><strong>Burn Severity:</strong></td><td>severe</td></tr>
		<tr><td><strong>Systematic Organ Failure:</strong>severe</td></tr>
		<tr><td><strong>Oxygen Deprivation:</strong></td><td>severe</tr>
		<tr><td><strong>Radiation Level:</strong></td><td>acute</td></tr>
		<tr><td><strong>Genetic Tissue Damage:</strong></td><td>severe</td></tr>
		<tr><td><strong>Paralysis Summary:</strong></td><td>approx 0 seconds left</td></tr>
	*/
	if(skill_level >= SKILL_BASIC)
		subdat += "<tr><td><strong>Physical Trauma:</strong></td><td>\t[get_severity(scan["trauma"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Burn Severity:</strong></td><td>\t[get_severity(scan["burn"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Systematic Organ Failure:</strong></td><td>\t[get_severity(scan["toxin"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Oxygen Deprivation:</strong></td><td>\t[get_severity(scan["oxygen"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Radiation Level:</strong></td><td>\t[get_severity(scan["radiation"]/5,TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Genetic Tissue Damage:</strong></td><td>\t[get_severity(scan["genetic"],TRUE)]</td></tr>"

		if(scan["paralysis"])
			subdat += "<tr><td><strong>Paralysis Summary:</strong></td><td>approx. [scan["paralysis"]/4] seconds left</td></tr>"

		dat += subdat

		subdat = null
		dat += "<tr><td colspan = '2'>Antibody levels and immune system perfomance are at [scan["immune_system"]*100]% of baseline.</td></tr>"

		var/other_reagent = FALSE
		for(var/list/reagent_data in scan["reagents"])
			if(reagent_data["scannable"])
				subdat += "<tr><td colspan='2'>[reagent_data["quantity"]]u [reagent_data["name"]]</td></tr>"
			else
				other_reagent = TRUE
		if(subdat)
			dat += "<tr><td colspan='2'>Beneficial reagents detected in subject's bloodstream:</td></tr>"
			dat += subdat
		if(other_reagent)
			dat += "<tr><td colspan='2'><span class='average'>Warning: Unknown substance detected in subject's blood.</span></td></tr>"
	else
		dat += "<tr><td colspan='2'>You see a lot of numbers and abbreviations here, but you have no clue what any of this means.</td></tr>"

	dat = JOINTEXT(dat)

	return dat

/proc/display_medical_data_body(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()
	//External Organs
	dat += "<tr><td colspan='2'><center><table class='block' border='1' width='95%'><tr><th colspan='3'>Body Status</th></tr>"
	dat += "<tr><th>Organ</th><th>Damage</th><th>Status</th></tr>"
	subdat = list()

	for(var/list/organ_data in scan["external_organs"])
		if(!organ_data)
			break
		var/row = list()
		row += "<tr><td>[organ_data["name"]]</td>"
		var/rowdata = list()
		if(organ_data["brute_dam"] + organ_data["burn_dam"] == 0)
			rowdata += "None"
		else if(skill_level < SKILL_ADEPT)
			if(organ_data["brute_dam"])
				rowdata += "<span class='bad'>Damaged</span>"
			if(organ_data["burn_dam"])
				rowdata += "<span class='average'>Burned</span>"
		else
			if(organ_data["brute_dam"])
				rowdata += "<span class='bad'>[capitalize(get_wound_severity(organ_data["brute_ratio"], (organ_data["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))] physical trauma</span>"
			if(organ_data["burn_dam"])
				rowdata += "<span class='average'>[capitalize(get_wound_severity(organ_data["burn_ratio"], (organ_data["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))] burns</span>"
		row += "<td>[jointext(rowdata, "<br>")]</td>"

		if(skill_level >= SKILL_ADEPT)
			var/list/status = list()
			if(organ_data["scan_results"])
				status += "<span class='bad'>[english_list(organ_data["scan_results"], nothing_text = "&nbsp;")]</span>"
			if(organ_data["tumors"])
				status += "<span class='bad'>Abnormal internal growth</span>"
			if(organ_data["ailments"])
				status += "[jointext(organ_data["ailments"], "<br>")]"
			row += "<td>[status ? jointext(status, "<br>") : "Nominal."]</td>"
		else
			row += "<td>&nbsp;</td>"

		row += "</tr>"
		subdat += JOINTEXT(row)

	dat += subdat
	subdat = list()

	//Internal Organs
	if(skill_level >= SKILL_BASIC)
		dat += "<tr><th colspan='3'><center>Internal Organs</center></th></tr>"
		for(var/list/organ_data in scan["internal_organs"])
			var/row = list()
			row += "<tr><td>[organ_data["name"]]</td>"
			if(organ_data["is_broken"])
				row += "<td><span class='bad'>Severe</span></td>"
			else if(organ_data["is_bruised"])
				row += "<td><span class='average'>Moderate</span></td>"
			else if(organ_data["is_damaged"])
				row += "<td><span class='mild'>Minor</span></td>"
			else
				row += "<td>None</td>"

			if(skill_level >= SKILL_ADEPT)
				var/list/status = list()
				if(organ_data["scan_results"])
					status += "<span class='bad'>[english_list(organ_data["scan_results"], nothing_text = "&nbsp;")]</span>"
				if(organ_data["ailments"])
					status += "[jointext(organ_data["ailments"], "<br>")]"
				row += "<td>[status ? jointext(status, "<br>") : "Nominal."]</td>"
			else
				row += "<td>&nbsp;</td>"

			row += "</tr>"
			subdat += jointext(row, null)

	if(skill_level <= SKILL_ADEPT)
		dat += shuffle(subdat)
	else
		dat += subdat
	for(var/organ_name in scan["missing_organs"])
		if(organ_name != BP_APPENDIX)
			dat += "<tr><td colspan='3'><span class='bad'>No [organ_name] detected.</span></td></tr>"
		else
			dat += "<tr><td colspan='3'>No [organ_name] detected</td></tr>"

	if(scan["blind"])
		dat += "<tr><td colspan='3'><span class='bad'>Cataracts detected.</span></td></tr>"
	else if(scan["nearsight"])
		dat += "<tr><td colspan='3'><span class='average'>Retinal misalignment detected.</span></td></tr>"
	dat += "</table></center></td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data(var/list/scan, skill_level = SKILL_DEFAULT, var/TT = FALSE)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/dat = list()

	if(TT)
		dat += "<tt>"

	//necessary evil, due to the limitations of nanoUI's variable length output.
	//This allows for the display_medical_data proc to be used for non-ui things
	//while keeping the variable size lower for the scanner template.
	//decoupling the two would lead to inconsistent output between the template
	//and other sources if changes are ever made.
	dat += display_medical_data_header(scan, skill_level)
	dat += display_medical_data_health(scan, skill_level)
	dat += display_medical_data_body(scan, skill_level)

	if(TT)
		dat += "</tt>"

	dat = JOINTEXT(dat)
	return dat

/proc/get_severity(amount, var/tag = FALSE)
	if(!amount)
		return "none"
	if(amount > 50)
		if(tag)
			. = "<span class='bad'>severe</span>"
		else
			. = "severe"
	else if(amount > 25)
		if(tag)
			. = "<span class='bad'>significant</span>"
		else
			. = "significant"
	else if(amount > 10)
		if(tag)
			. = "<span class='average'>moderate</span>"
		else
			. = "moderate"
	else
		if (tag)
			.= "<span class='mild'>minor</span>"
		else
			.= "minor"
