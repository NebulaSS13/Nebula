

// subtypes of stuff in here will be avoided when randomizing interactions.
GLOBAL_LIST_INIT(random_chem_interaction_blacklist, list(
	/decl/material/liquid/adminordrazine,
	/decl/material/solid/tobacco,
	/decl/material/liquid/drink,
	/decl/material/liquid/random,
	/decl/material/liquid/ethanol // Includes alcoholic beverages
))

#define FOR_ALL_EFFECTS \
	var/list/all_effects = decls_repository.get_decls_unassociated(data);\
	for(var/decl/random_chem_effect/effect in all_effects)

/decl/material/liquid/random
	name = "exotic chemical"
	lore_text = "A strange and exotic chemical substance."
	taste_mult = 0 // Random taste not yet implemented
	hidden_from_codex = TRUE
	var/max_effect_number = 8
	var/list/data = list()
	var/initialized = FALSE

/decl/material/liquid/random/proc/randomize_data(temperature)
	data = list()
	var/list/effects_to_get = subtypesof(/decl/random_chem_effect/random_properties)
	if(length(effects_to_get) > max_effect_number)
		shuffle(effects_to_get)
		effects_to_get.Cut(max_effect_number + 1)
	effects_to_get += subtypesof(/decl/random_chem_effect/general_properties)
	
	var/list/decls = decls_repository.get_decls_unassociated(effects_to_get)
	for(var/item in decls)
		var/decl/random_chem_effect/effect = item
		effect.prototype_process(src, temperature)
	
	var/whitelist = subtypesof(/decl/material)
	for(var/bad_type in GLOB.random_chem_interaction_blacklist)
		whitelist -= typesof(bad_type)

	var/chill_num = pick(1,2,4)
	chilling_products = list()
	for(var/i in 1 to chill_num)
		chilling_products[pick_n_take(whitelist)] = 1 / chill_num // it's possible that these form a valid reaction, but we're OK with that.

	var/heat_num = pick(1,2,4)
	heating_products = list()
	for(var/i in 1 to heat_num)
		heating_products[pick_n_take(whitelist)] = 1 / heat_num

	initialized = TRUE

/decl/material/liquid/random/proc/stable_at_temperature(temperature)
	if(temperature > chilling_point && temperature < heating_point)
		return TRUE

/decl/material/liquid/random/affect_blood(var/mob/living/M, var/alien, var/removed, var/datum/reagents/holder)
	FOR_ALL_EFFECTS
		var/data = REAGENT_DATA(holder, type)
		effect.affect_blood(M, alien, removed, LAZYACCESS(data, effect.type))

/decl/material/liquid/random/proc/on_chemicals_analyze(mob/user)
	to_chat(user, get_scan_data(user))

/decl/material/liquid/random/proc/get_scan_data(mob/user)
	var/list/dat = list()
	var/chem_skill = user.get_skill_value(SKILL_CHEMISTRY)
	if(chem_skill < SKILL_BASIC)
		dat += "You analyze the strange liquid. The readings are confusing; could it maybe be juice?"
	else if(chem_skill < SKILL_ADEPT)
		dat += "You analyze the strange liquid. Based on the readings, you are skeptical that this is safe to drink."
	else
		dat += "The readings are very unsual and intriguing. You suspect it may be of alien origin."
		var/sci_skill = user.get_skill_value(SKILL_SCIENCE)
		var/beneficial
		var/harmful
		var/list/effect_descs = list()
		FOR_ALL_EFFECTS
			if(effect.beneficial > 0)
				beneficial = 1
			if(effect.beneficial < 0)
				harmful = 1
			if(effect.desc)
				effect_descs += effect.desc
		if(sci_skill <= SKILL_ADEPT)
			if(beneficial)
				dat += "The scan suggests that the chemical has some potentially beneficial effects!"
			if(harmful)
				dat += "The readings confirm that the chemical is not safe for human use."
		else
			dat += "A close analysis of the scan suggests that the chemical has some of the following effects: [english_list(effect_descs)]."
	return jointext(dat, "<br>")

/decl/material/liquid/random/get_value()

	. = 0
	FOR_ALL_EFFECTS
		. += effect.get_value(data[effect.type])
	. = max(., 0)


// Extra unique types for exoplanet spawns, etc.
/decl/material/liquid/random/one
/decl/material/liquid/random/two

#undef FOR_ALL_EFFECTS