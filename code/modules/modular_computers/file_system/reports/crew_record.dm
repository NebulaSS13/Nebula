var/global/list/all_crew_records =  list()
var/global/list/physical_statuses = list("Active", "Disabled", "SSD", "Deceased", "MIA")
var/global/list/security_statuses = list("None", "Released", "Parolled", "Incarcerated", "Arrest")

var/global/default_physical_status = "Active"
var/global/default_security_status = "None"
var/global/arrest_security_status =  "Arrest"

/datum/computer_file/report/crew_record
	filetype = "CDB"
	size = 2
	write_access = list(list(access_bridge))

	var/icon/photo_front = null
	var/icon/photo_side = null

/datum/computer_file/report/crew_record/New()
	..()
	filename = "record[random_id(type, 100,999)]"
	load_from_mob(null)

/datum/computer_file/report/crew_record/Destroy()
	. = ..()
	global.all_crew_records.Remove(src)

/datum/computer_file/report/crew_record/proc/load_from_mob(var/mob/living/human/H)

	if(istype(H))
		photo_front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/human/dummy = new()
		photo_front = getFlatIcon(dummy, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(dummy, WEST, always_use_defdir = 1)
		qdel(dummy)

	// Load records from the client.
	var/list/records = H?.client?.prefs?.records || list()

	// Add honorifics, etc.
	var/formal_name = "Unset"
	if(H)
		formal_name = H.real_name
		if(H.client && H.client.prefs)
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = GET_DECL(H.client.prefs.cultural_info[culturetag])
				if(H.char_rank && H.char_rank.name_short)
					formal_name = "[formal_name][culture.get_formal_name_suffix()]"
				else
					formal_name = "[culture.get_formal_name_prefix()][formal_name][culture.get_formal_name_suffix()]"

	// Generic record
	set_name(H ? H.real_name : "Unset")
	set_formal_name(formal_name)
	set_job(H ? GetAssignment(H) : "Unset")
	var/gender_term = "Unset"
	if(H)
		var/decl/pronouns/G = H.get_pronouns(ignore_coverings = TRUE)
		if(G && G.bureaucratic_term )
			gender_term = G.bureaucratic_term
	set_gender(gender_term)
	set_age(H?.get_age() || 30)
	set_status(global.default_physical_status)
	set_species_name(H ? H.get_species_name() : global.using_map.default_species)
	set_branch(H ? (H.char_branch && H.char_branch.name) : "None")
	set_rank(H ? (H.char_rank && H.char_rank.name) : "None")

	var/public_record = records[PREF_PUB_RECORD]
	set_public_record((public_record && !jobban_isbanned(H, "Records")) ? html_decode(public_record) : "No record supplied")

	// Medical record
	set_bloodtype(H?.get_blood_type() || "Unset")
	var/medical_record = records[PREF_MED_RECORD]
	set_medical_record((medical_record && !jobban_isbanned(H, "Records")) ? html_decode(medical_record) : "No record supplied")

	if(H)
		var/decl/bodytype/root_bodytype = H.get_bodytype()
		var/organ_data = list("\[*\]")
		for(var/obj/item/organ/external/E in H.get_external_organs())
			if(E.bodytype != root_bodytype)
				organ_data += "[E.bodytype] [E.name] [BP_IS_PROSTHETIC(E) ? "prosthetic" : "graft"]"
		for(var/obj/item/organ/internal/I in H.get_internal_organs())
			if(I.bodytype != root_bodytype)
				organ_data += "[I.bodytype] [I.name] [BP_IS_PROSTHETIC(I) ? "prosthetic" : "graft"]"
		set_implants(jointext(organ_data, "\[*\]"))

	// Security record
	set_criminalStatus(global.default_security_status)
	set_dna(H?.get_unique_enzymes() || "")
	set_fingerprint(H?.get_full_print(ignore_blockers = TRUE) || "")

	var/security_record = records[PREF_SEC_RECORD]
	set_security_record((security_record && !jobban_isbanned(H, "Records")) ? html_decode(security_record) : "No record supplied")

	// Employment record
	var/employment_record = "No record supplied"
	if(H)
		var/gen_record = records[PREF_GEN_RECORD]
		if(gen_record && !jobban_isbanned(H, "Records"))
			employment_record = html_decode(gen_record)
		if(H.client && H.client.prefs)
			var/list/qualifications
			for(var/culturetag in H.client.prefs.cultural_info)
				var/decl/cultural_info/culture = GET_DECL(H.client.prefs.cultural_info[culturetag])
				var/extra_note = culture.get_qualifications()
				if(extra_note)
					LAZYADD(qualifications, extra_note)
			if(LAZYLEN(qualifications))
				employment_record = "[employment_record ? "[employment_record]\[br\]" : ""][jointext(qualifications, "\[br\]>")]"
	set_employment_record(employment_record)

	// Misc cultural info.
	set_residence(H ? html_decode(H.get_cultural_value(TAG_HOMEWORLD)) : "Unset")
	set_faction(H ?   html_decode(H.get_cultural_value(TAG_FACTION)) :   "Unset")
	set_religion(H ?  html_decode(H.get_cultural_value(TAG_RELIGION)) :  "Unset")

	if(H)
		var/skills = list()
		for(var/decl/hierarchy/skill/S in global.using_map.get_available_skills())
			var/level = H.get_skill_value(S.type)
			if(level > SKILL_NONE)
				skills += "[S.name], [S.levels[level]]"

		set_skillset(jointext(skills,"\n"))

	// Antag record
	if(H?.client?.prefs)
		var/exploit_record =  H.client.prefs.exploit_record
		set_antag_record((exploit_record && !jobban_isbanned(H, "Records")) ? html_decode(exploit_record) : "")

// Cut down version for silicons
/datum/computer_file/report/crew_record/synth/load_from_mob(var/mob/living/silicon/S)
	if(istype(S))
		photo_front = getFlatIcon(S, SOUTH, always_use_defdir = 1)
		photo_side = getFlatIcon(S, WEST, always_use_defdir = 1)

	// Generic record
	set_name(S ? S.real_name : "Unset")
	set_formal_name(S ? S.real_name : "Unset")
	set_gender("Unset")
	set_status(global.default_physical_status)
	var/silicon_type = "Synthetic Lifeform"
	var/robojob = GetAssignment(S)
	if(isrobot(S))
		var/mob/living/silicon/robot/R = S
		silicon_type = R.braintype
		if(R.module)
			robojob = "[R.module.display_name] [silicon_type]"
	if(isAI(S))
		silicon_type = "AI"
		robojob = "Artificial Intelligence"
	set_job(S ? robojob : "Unset")
	set_species_name(silicon_type)

	set_implants("Robotic body")

	// Security record
	set_criminalStatus(global.default_security_status)

// Global methods
// Used by character creation to create a record for new arrivals.
/proc/CreateModularRecord(var/mob/living/H, record_type = /datum/computer_file/report/crew_record)
	var/datum/computer_file/report/crew_record/CR = new record_type()
	global.all_crew_records.Add(CR)
	CR.load_from_mob(H)
	var/datum/computer_network/network = get_local_network_at(get_turf(H))
	if(network)
		network.store_file(CR, OS_RECORDS_DIR, TRUE, mainframe_role = MF_ROLE_CREW_RECORDS)
	return CR

// Gets crew records filtered by set of positions
/proc/department_crew_manifest(var/list/filter_positions, var/blacklist = FALSE)
	var/list/matches = list()
	for(var/datum/computer_file/report/crew_record/CR in global.all_crew_records)
		var/rank = CR.get_job()
		if(blacklist)
			if(!(rank in filter_positions))
				matches.Add(CR)
		else
			if(rank in filter_positions)
				matches.Add(CR)
	return matches

// Simple record to HTML (for paper purposes) conversion.
// Not visually that nice, but it gets the work done, feel free to tweak it visually
/proc/record_to_html(var/datum/computer_file/report/crew_record/CR, var/access)
	var/dat = "<tt><H2>RECORD DATABASE DATA DUMP</H2><i>Generated on: [stationdate2text()] [stationtime2text()]</i><br>******************************<br>"
	dat += "<table>"
	for(var/datum/report_field/F in CR.fields)
		if(F.get_perms(access) & OS_READ_ACCESS)
			dat += "<tr><td><b>[F.display_name()]</b>"
			if(F.needs_big_box)
				dat += "<tr>"
			dat += "<td>[F.get_value()]"
	dat += "</tt>"
	return dat

//Should only be used for OOC stuff, for player-facing stuff you must go through the network.
/proc/get_crewmember_record(var/name)
	for(var/datum/computer_file/report/crew_record/CR in global.all_crew_records)
		if(CR.get_name() == name)
			return CR
	return null

/proc/GetAssignment(var/mob/living/human/H)
	if(!H)
		return "Unassigned"
	if(!H.mind)
		return H.job
	if(H.mind.role_alt_title)
		return H.mind.role_alt_title
	return H.mind.assigned_role

#define GETTER_SETTER(PATH, KEY) /datum/computer_file/report/crew_record/proc/get_##KEY(){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) return F.get_value()} \
/datum/computer_file/report/crew_record/proc/set_##KEY(given_value){var/datum/report_field/F = locate(/datum/report_field/##PATH/##KEY) in fields; if(F) F.set_value(given_value)}
#define SETUP_FIELD(NAME, KEY, PATH, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS, SEARCHABLE) GETTER_SETTER(PATH, KEY); /datum/report_field/##PATH/##KEY;\
/datum/computer_file/report/crew_record/generate_fields(){..(); var/datum/report_field/##KEY = add_field(/datum/report_field/##PATH/##KEY, ##NAME, searchable = SEARCHABLE, can_mod_access = CAN_MOD_ACCESS);\
KEY.set_access(ACCESS, ACCESS_EDIT || ACCESS || access_bridge)}

// Fear not the preprocessor, for it is a friend. To add a field, use one of these, depending on value type and if you need special access to see it.
// It will also create getter/setter procs for record datum, named like /get_[key here]() /set_[key_here](value) e.g. get_name() set_name(value)
// Use getter setters to avoid errors caused by typoing the string key.
#define FIELD_SHORT(NAME, KEY, ACCESS, ACCESS_EDIT, SEARCHABLE, CAN_MOD_ACCESS) SETUP_FIELD(NAME, KEY, simple_text/crew_record, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS, SEARCHABLE)
#define FIELD_LONG(NAME, KEY, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS) SETUP_FIELD(NAME, KEY, pencode_text/crew_record, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS, FALSE)
#define FIELD_NUM(NAME, KEY, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS) SETUP_FIELD(NAME, KEY, number/crew_record, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS, FALSE)
#define FIELD_LIST(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS) FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS)
#define FIELD_LIST_EDIT(NAME, KEY, OPTIONS, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS) SETUP_FIELD(NAME, KEY, options/crew_record, ACCESS, ACCESS_EDIT, CAN_MOD_ACCESS, FALSE);\
/datum/report_field/options/crew_record/##KEY/get_options(){return OPTIONS}

// GENERIC RECORDS
FIELD_SHORT("Name", name, null, access_change_ids, TRUE, TRUE)
FIELD_SHORT("Formal Name", formal_name, null, access_change_ids, FALSE, TRUE)
FIELD_SHORT("Job", job, null, access_change_ids, FALSE, TRUE)
FIELD_LIST("Gender", gender, record_genders(), null, access_change_ids, TRUE)
FIELD_NUM("Age", age, null, access_change_ids, TRUE)
FIELD_LIST_EDIT("Status", status, global.physical_statuses, null, access_medical, TRUE)

FIELD_SHORT("Species",species_name, null, access_change_ids, FALSE, TRUE)
FIELD_LIST("Branch", branch, record_branches(), null, access_change_ids, TRUE)
FIELD_LIST("Rank", rank, record_ranks(), null, access_change_ids, TRUE)
FIELD_SHORT("Religion", religion, access_chapel_office, access_change_ids, FALSE, TRUE)

FIELD_LONG("General Notes (Public)", public_record, null, access_bridge, TRUE)

// MEDICAL RECORDS
FIELD_LIST("Blood Type", bloodtype, get_all_blood_types(), access_medical, access_medical, TRUE)
FIELD_LONG("Medical Record", medical_record, access_medical, access_medical, TRUE)
FIELD_LONG("Known Implants", implants, access_medical, access_medical, TRUE)

// SECURITY RECORDS
FIELD_LIST("Criminal Status", criminalStatus, global.security_statuses, access_security, access_security, TRUE)
FIELD_LONG("Security Record", security_record, access_security, access_security, TRUE)
FIELD_SHORT("DNA", dna, access_security, access_security, TRUE, TRUE)
FIELD_SHORT("Fingerprint", fingerprint, access_security, access_security, TRUE, TRUE)

// EMPLOYMENT RECORDS
FIELD_LONG("Employment Record", employment_record, access_bridge, access_bridge, TRUE)
FIELD_SHORT("Residence", residence, access_bridge, access_change_ids, FALSE, TRUE)
FIELD_SHORT("Association", faction, access_bridge, access_bridge, FALSE, TRUE)
FIELD_LONG("Qualifications", skillset, access_bridge, access_bridge, TRUE)

// ANTAG RECORDS
FIELD_LONG("Exploitable Information", antag_record, access_hacked, access_hacked, FALSE)

//Options builderes
/datum/report_field/options/crew_record/rank/proc/record_ranks()
	var/datum/computer_file/report/crew_record/record = owner
	var/datum/mil_branch/branch = mil_branches.get_branch(record.get_branch())
	if(!branch)
		return
	. = list()
	. |= "Unset"
	for(var/rank in branch.ranks)
		var/datum/mil_rank/RA = branch.ranks[rank]
		. |= RA.name

/datum/report_field/options/crew_record/gender/proc/record_genders()
	. = list()
	. |= "Unset"
	var/list/all_genders = decls_repository.get_decls_of_type(/decl/pronouns)
	for(var/thing in all_genders)
		var/decl/pronouns/G = all_genders[thing]
		if(G.bureaucratic_term )
			. |= G.bureaucratic_term

/datum/report_field/options/crew_record/branch/proc/record_branches()
	. = list()
	. |= "Unset"
	for(var/B in mil_branches.branches)
		var/datum/mil_branch/BR = mil_branches.branches[B]
		. |= BR.name

#undef GETTER_SETTER
#undef SETUP_FIELD
#undef FIELD_SHORT
#undef FIELD_LONG
#undef FIELD_NUM
#undef FIELD_LIST
#undef FIELD_LIST_EDIT