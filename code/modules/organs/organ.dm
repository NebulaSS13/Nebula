/obj/item/organ
	name = "organ"
	icon = 'icons/obj/surgery.dmi'
	germ_level = 0
	w_class = ITEM_SIZE_TINY
	default_action_type = /datum/action/item_action/organ
	material = /decl/material/solid/meat
	origin_tech = "{'materials':1,'biotech':1}"
	throwforce = 2
	abstract_type = /obj/item/organ

	// Strings.
	var/organ_tag = "organ"                // Unique identifier.
	var/parent_organ = BP_CHEST            // Organ holding this object.

	// Status tracking.
	var/status = 0                         // Various status flags (such as robotic)
	var/organ_properties = 0               // A flag for telling what capabilities this organ has. ORGAN_PROP_PROSTHETIC, ORGAN_PROP_CRYSTAL, etc..
	var/vital_to_owner                     // Cache var for vitality to current owner.

	// Reference data.
	var/mob/living/carbon/human/owner      // Current mob owning the organ.
	var/datum/dna/dna                      // Original DNA.
	var/decl/species/species               // Original species.
	var/decl/bodytype/bodytype             // Original bodytype.
	var/list/ailments                      // Current active ailments if any.

	// Damage vars.
	var/damage = 0                         // Current damage to the organ
	var/min_broken_damage = 30             // Damage before becoming broken
	var/max_damage = 30                    // Damage cap, including scarring
	var/absolute_max_damage = 0            // Lifetime damage cap, ignoring scarring.
	var/rejecting                          // Is this organ already being rejected?
	var/death_time                         // REALTIMEOFDAY at moment of death.
	var/scale_max_damage_to_species_health // Whether or not we should scale the damage values of this organ to the owner species.

/obj/item/organ/Destroy()
	if(owner)
		owner.remove_organ(src, FALSE, FALSE, TRUE, TRUE, FALSE) //Tell our parent we're unisntalling in place
		owner = null
	else
		do_uninstall(TRUE, FALSE, FALSE, FALSE) //Don't ignore children here since we might own/contain them
	species = null
	bodytype = null
	QDEL_NULL(dna)
	QDEL_NULL_LIST(ailments)
	return ..()

/obj/item/organ/proc/on_holder_death(var/gibbed)
	return

/obj/item/organ/proc/refresh_action_button()
	return action

/obj/item/organ/attack_self(var/mob/user)
	return (owner && loc == owner && owner == user)

/obj/item/organ/proc/update_health()
	return

/obj/item/organ/proc/is_broken()
	return (damage >= min_broken_damage || (status & ORGAN_CUT_AWAY) || (status & ORGAN_BROKEN))

//Third rgument may be a dna datum; if null will be set to holder's dna.
/obj/item/organ/Initialize(mapload, material_key, var/datum/dna/given_dna)
	. = ..(mapload, material_key)
	if(. != INITIALIZE_HINT_QDEL)
		if(!BP_IS_PROSTHETIC(src))
			setup_as_organic(given_dna)
		else
			setup_as_prosthetic()

/obj/item/organ/proc/setup_as_organic(var/datum/dna/given_dna)
	//Null DNA setup
	if(!given_dna)
		if(dna)
			given_dna = dna //Use existing if possible
		else if(owner)
			if(owner.dna)
				given_dna = owner.dna //Grab our owner's dna if we don't have any, and they have
			else
				//The owner having no DNA can be a valid reason to keep our dna null in some cases
				log_debug("obj/item/organ/setup_as_organic(): [src] had null dna, with a owner with null dna!")
				dna = null //#TODO: Not sure that's really legal
				return
		else
			//If we have NO OWNER and given_dna, just make one up for consistency
			given_dna = new/datum/dna()
			given_dna.check_integrity() //Defaults everything

	set_dna(given_dna)
	initialize_reagents()
	return TRUE

//Allows specialization of roboticize() calls on initialization meant to be used when loading prosthetics
// NOTE: This wouldn't be necessary if prothetics were a subclass
/obj/item/organ/proc/setup_as_prosthetic(var/forced_model = /decl/prosthetics_manufacturer/basic_human)
	if(!species)
		if(owner?.species)
			set_species(owner.species)
		else
			set_species(global.using_map.default_species)

	if(istype(material))
		robotize(forced_model, apply_material = material.type)
	else
		robotize(forced_model)
	return TRUE

//Called on initialization to add the neccessary reagents

/obj/item/organ/initialize_reagents(populate = TRUE)
	if(reagents)
		return
	create_reagents(5 * (w_class-1)**2)
	. = ..()

/obj/item/organ/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, reagents.maximum_volume)

/obj/item/organ/proc/set_dna(var/datum/dna/new_dna)
	QDEL_NULL(dna)
	dna = new_dna.Clone()
	if(!blood_DNA)
		blood_DNA = list()
	blood_DNA.Cut()
	blood_DNA[dna.unique_enzymes] = dna.b_type
	set_species(dna.species)

/obj/item/organ/proc/set_species(var/specie_name)
	vital_to_owner = null // This generally indicates the owner mob is having species set, and this value may be invalidated.
	if(istext(specie_name))
		species = get_species_by_key(specie_name)
	else
		species = specie_name
	if(!species)
		species = get_species_by_key(global.using_map.default_species)
		PRINT_STACK_TRACE("Invalid species. Expected a valid species name as string, was: [log_info_line(specie_name)]")

	bodytype = owner?.bodytype || species.default_bodytype
	species.resize_organ(src)

	// Adjust limb health proportinate to total species health.
	var/total_health_coefficient = scale_max_damage_to_species_health ? (species.total_health / DEFAULT_SPECIES_HEALTH) : 1

	//Use initial value to prevent scaling down each times we change the species during init
	absolute_max_damage = initial(absolute_max_damage)
	min_broken_damage = initial(min_broken_damage)
	max_damage = initial(max_damage)

	if(absolute_max_damage)
		absolute_max_damage = max(1, FLOOR(absolute_max_damage * total_health_coefficient))
		min_broken_damage = max(1, FLOOR(absolute_max_damage * 0.5))
	else
		min_broken_damage = max(1, FLOOR(min_broken_damage * total_health_coefficient))
		absolute_max_damage = max(1, FLOOR(min_broken_damage * 2))
	max_damage = absolute_max_damage // resets scarring, but ah well

	reset_status()

/obj/item/organ/proc/die()
	damage = max_damage
	status |= ORGAN_DEAD
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL_LIST(ailments)
	death_time = REALTIMEOFDAY
	update_icon()

/obj/item/organ/Process()

	if(loc != owner) //#FIXME: looks like someone was trying to hide a bug :P That probably could break organs placed inside a wrapper though
		owner = null
		vital_to_owner = null

	//dead already, no need for more processing
	if(status & ORGAN_DEAD)
		return
	// Don't process if we're in a freezer, an MMI or a stasis bag.or a freezer or something I dunno
	if(is_preserved())
		return
	//Process infections
	if (BP_IS_PROSTHETIC(src) || (owner && owner.species && (owner.species.species_flags & SPECIES_FLAG_IS_PLANT)))
		germ_level = 0
		return

	if(!owner && reagents)
		if(prob(40) && reagents.total_volume >= 0.1)
			if(reagents.has_reagent(/decl/material/liquid/blood))
				blood_splatter(get_turf(src), src, 1)
			reagents.remove_any(0.1)
		if(config.organs_decay)
			take_general_damage(rand(1,3))
		germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_TWO)
			germ_level += rand(2,6)
		if(germ_level >= INFECTION_LEVEL_THREE)
			die()

	else if(owner && owner.bodytemperature >= 170)	//cryo stops germs from moving and doing their bad stuffs
		//** Handle antibiotics and curing infections
		handle_antibiotics()
		handle_rejection()
		handle_germ_effects()

	if(owner && length(ailments))
		for(var/datum/ailment/ailment in ailments)
			handle_ailment(ailment)

	//check if we've hit max_damage
	if(damage >= max_damage)
		die()

/obj/item/organ/proc/handle_ailment(var/datum/ailment/ailment)
	if(ailment.treated_by_reagent_type)
		for(var/datum/reagents/source as anything in owner.get_metabolizing_reagent_holders())
			for(var/reagent_type in source.reagent_volumes)
				if(ailment.treated_by_medication(reagent_type, source.reagent_volumes[reagent_type]))
					ailment.was_treated_by_medication(source, reagent_type)
					return
	if(ailment.treated_by_chem_effect && owner.has_chemical_effect(ailment.treated_by_chem_effect, ailment.treated_by_chem_effect_strength))
		ailment.was_treated_by_chem_effect()

/obj/item/organ/proc/is_preserved()
	if(istype(loc,/obj/item/organ))
		var/obj/item/organ/O = loc
		return O.is_preserved()
	else
		return (istype(loc,/obj/item/mmi) || istype(loc,/obj/structure/closet/body_bag/cryobag) || istype(loc,/obj/structure/closet/crate/freezer) || istype(loc,/obj/item/storage/box/freezer))

/obj/item/organ/examine(mob/user)
	. = ..(user)
	show_decay_status(user)

/obj/item/organ/proc/show_decay_status(mob/user)
	if(status & ORGAN_DEAD)
		to_chat(user, "<span class='notice'>The decay has set into \the [src].</span>")

/obj/item/organ/proc/handle_germ_effects()
	//** Handle the effects of infections
	var/germ_immunity = owner.get_immunity() //reduces the amount of times we need to call this proc
	var/antibiotics = REAGENT_VOLUME(owner.reagents, /decl/material/liquid/antibiotics)

	if (germ_level > 0 && germ_level < INFECTION_LEVEL_ONE/2 && prob(germ_immunity*0.3))
		germ_level--

	if (germ_level >= INFECTION_LEVEL_ONE/2)
		//aiming for germ level to go from ambient to INFECTION_LEVEL_TWO in an average of 15 minutes, when immunity is full.
		if(antibiotics < 5 && prob(round(germ_level/6 * owner.immunity_weakness() * 0.01)))
			if(germ_immunity > 0)
				germ_level += clamp(round(1/germ_immunity), 1, 10) // Immunity starts at 100. This doubles infection rate at 50% immunity. Rounded to nearest whole.
			else // Will only trigger if immunity has hit zero. Once it does, 10x infection rate.
				germ_level += 10

	if(germ_level >= INFECTION_LEVEL_ONE)
		var/fever_temperature = (owner.get_temperature_threshold(HEAT_LEVEL_1) - owner.species.body_temperature - 5)* min(germ_level/INFECTION_LEVEL_TWO, 1) + owner.species.body_temperature
		owner.bodytemperature += clamp(0, (fever_temperature - T20C)/BODYTEMP_COLD_DIVISOR + 1, fever_temperature - owner.bodytemperature)

	if (germ_level >= INFECTION_LEVEL_TWO)
		var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(owner, parent_organ)
		//spread germs
		if (antibiotics < 5 && parent.germ_level < germ_level && ( parent.germ_level < INFECTION_LEVEL_ONE*2 || prob(owner.immunity_weakness() * 0.3) ))
			parent.germ_level++

		if (prob(3))	//about once every 30 seconds
			take_general_damage(1,silent=prob(30))

/obj/item/organ/proc/handle_rejection()
	// Process unsuitable transplants. TODO: consider some kind of
	// immunosuppressant that changes transplant data to make it match.
	if(owner.get_immunity() < 10) //for now just having shit immunity will suppress it
		return
	if(BP_IS_PROSTHETIC(src))
		return
	if(dna)
		if(!rejecting)
			if(owner.blood_incompatible(dna.b_type))
				rejecting = 1
		else
			rejecting++ //Rejection severity increases over time.
			if(rejecting % 10 == 0) //Only fire every ten rejection ticks.
				switch(rejecting)
					if(1 to 50)
						germ_level++
					if(51 to 200)
						germ_level += rand(1,2)
					if(201 to 500)
						germ_level += rand(2,3)
					if(501 to INFINITY)
						germ_level += rand(3,5)
						var/decl/blood_type/blood_decl = dna?.b_type && get_blood_type_by_name(dna.b_type)
						if(istype(blood_decl))
							owner.reagents.add_reagent(blood_decl.transfusion_fail_reagent, round(rand(2,4) * blood_decl.transfusion_fail_percentage))
						else
							owner.reagents.add_reagent(/decl/material/liquid/coagulated_blood, rand(1,2))

/obj/item/organ/proc/remove_rejuv()
	qdel(src)

/obj/item/organ/proc/rejuvenate(var/ignore_prosthetic_prefs)
	SHOULD_CALL_PARENT(TRUE)
	damage = 0
	reset_status()
	if(!ignore_prosthetic_prefs && owner?.client?.prefs && owner.client.prefs.real_name == owner.real_name)
		for(var/decl/aspect/aspect as anything in owner.personal_aspects)
			if(aspect.applies_to_organ(organ_tag))
				aspect.apply(owner)

/obj/item/organ/proc/reset_status()
	status = initial(status)
	if(species) // qdel clears species ref
		species.apply_species_organ_modifications(src)

//Germs
/obj/item/organ/proc/handle_antibiotics()
	if(!owner || !germ_level)
		return

	var/antibiotics = GET_CHEMICAL_EFFECT(owner, CE_ANTIBIOTIC)
	if (!antibiotics)
		return

	if (germ_level < INFECTION_LEVEL_ONE)
		germ_level = 0	//cure instantly
	else if (germ_level < INFECTION_LEVEL_TWO)
		germ_level -= 5	//at germ_level == 500, this should cure the infection in 5 minutes
	else
		germ_level -= 3 //at germ_level == 1000, this will cure the infection in 10 minutes
	if(owner && owner.lying)
		germ_level -= 2
	germ_level = max(0, germ_level)

/obj/item/organ/proc/take_general_damage(var/amount, var/silent = FALSE)
	CRASH("Not Implemented")

/obj/item/organ/proc/heal_damage(amount)
	if(can_recover())
		damage = clamp(0, damage - round(amount, 0.1), max_damage)

/obj/item/organ/proc/robotize(var/company = /decl/prosthetics_manufacturer/basic_human, var/skip_prosthetics = 0, var/keep_organs = 0, var/apply_material = /decl/material/solid/metal/steel, var/check_bodytype, var/check_species)
	vital_to_owner = null
	BP_SET_PROSTHETIC(src)
	QDEL_NULL(dna)
	reagents?.clear_reagents()
	material = GET_DECL(apply_material)
	matter = null
	create_matter()

/obj/item/organ/attack(var/mob/target, var/mob/user)
	if(BP_IS_PROSTHETIC(src) || !istype(target) || !istype(user) || (user != target && user.a_intent == I_HELP))
		return ..()

	if(alert("Do you really want to use this organ as food? It will be useless for anything else afterwards.",,"Ew, no.","Bon appetit!") == "Ew, no.")
		to_chat(user, SPAN_NOTICE("You successfully repress your cannibalistic tendencies."))
		return

	if(QDELETED(src))
		return

	if(!user.try_unequip(src))
		return

	var/obj/item/chems/food/organ/O = new(get_turf(src))
	O.SetName(name)
	O.appearance = src
	if(reagents && reagents.total_volume)
		reagents.trans_to(O, reagents.total_volume)
	transfer_fingerprints_to(O)
	user.put_in_active_hand(O)
	qdel(src)
	target.attackby(O, user)

/obj/item/organ/proc/can_feel_pain()
	return (!BP_IS_PROSTHETIC(src) && (!species || !(species.species_flags & SPECIES_FLAG_NO_PAIN)))

/obj/item/organ/proc/is_usable()
	return !(status & (ORGAN_CUT_AWAY|ORGAN_MUTATED|ORGAN_DEAD))

/obj/item/organ/proc/can_recover()
	return (max_damage > 0) && !(status & ORGAN_DEAD) || death_time >= REALTIMEOFDAY - ORGAN_RECOVERY_THRESHOLD

/obj/item/organ/proc/get_scan_results(var/tag = FALSE)
	. = list()
	if(BP_IS_CRYSTAL(src))
		. += tag ? "<span class='average'>Crystalline</span>" : "Crystalline"
	else if(BP_IS_PROSTHETIC(src))
		. += tag ? "<span class='average'>Mechanical</span>" : "Mechanical"
	if(status & ORGAN_CUT_AWAY)
		. += tag ? "<span class='bad'>Severed</span>" : "Severed"
	if(status & ORGAN_MUTATED)
		. += tag ? "<span class='bad'>Genetic Deformation</span>" : "Genetic Deformation"
	if(status & ORGAN_DEAD)
		if(can_recover())
			. += tag ? "<span class='bad'>Decaying</span>" : "Decaying"
		else
			. += tag ? "<span style='color:#999999'>Necrotic</span>" : "Necrotic"
	if(BP_IS_BRITTLE(src))
		. += tag ? "<span class='bad'>Brittle</span>" : "Brittle"

	switch (germ_level)
		if (INFECTION_LEVEL_ONE to INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
			. +=  "Mild Infection"
		if (INFECTION_LEVEL_ONE + ((INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3))
			. +=  "Mild Infection+"
		if (INFECTION_LEVEL_ONE + (2 * (INFECTION_LEVEL_TWO - INFECTION_LEVEL_ONE) / 3) to INFECTION_LEVEL_TWO)
			. +=  "Mild Infection++"
		if (INFECTION_LEVEL_TWO to INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3))
			if(tag)
				. += "<span class='average'>Acute Infection</span>"
			else
				. +=  "Acute Infection"
		if (INFECTION_LEVEL_TWO + ((INFECTION_LEVEL_THREE - INFECTION_LEVEL_THREE) / 3) to INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3))
			if(tag)
				. += "<span class='average'>Acute Infection+</span>"
			else
				. +=  "Acute Infection+"
		if (INFECTION_LEVEL_TWO + (2 * (INFECTION_LEVEL_THREE - INFECTION_LEVEL_TWO) / 3) to INFECTION_LEVEL_THREE)
			if(tag)
				. += "<span class='average'>Acute Infection++</span>"
			else
				. +=  "Acute Infection++"
		if (INFECTION_LEVEL_THREE to INFINITY)
			if(tag)
				. += "<span class='bad'>Septic</span>"
			else
				. +=  "Septic"
	if(rejecting)
		if(tag)
			. += "<span class='bad'>Genetic Rejection</span>"
		else
			. += "Genetic Rejection"

//used by stethoscope
/obj/item/organ/proc/listen()
	return

/obj/item/organ/proc/get_mechanical_assisted_descriptor()
	return "mechanically-assisted [name]"

var/global/list/ailment_reference_cache = list()
/proc/get_ailment_reference(var/ailment_type)
	if(!ispath(ailment_type, /datum/ailment))
		return
	if(!global.ailment_reference_cache[ailment_type])
		global.ailment_reference_cache[ailment_type] = new ailment_type
	return global.ailment_reference_cache[ailment_type]

/obj/item/organ/proc/get_possible_ailments()
	. = list()
	if(owner.status_flags & GODMODE)
		return .
	for(var/ailment_type in subtypesof(/datum/ailment))
		var/datum/ailment/ailment = ailment_type
		if(initial(ailment.category) == ailment_type)
			continue
		ailment = get_ailment_reference(ailment_type)
		if(ailment.can_apply_to(src))
			. += ailment_type
	for(var/datum/ailment/ailment in ailments)
		. -= ailment.type

/obj/item/organ/emp_act(severity)
	. = ..()
	if(BP_IS_PROSTHETIC(src))
		if(length(ailments) < 3 && prob(15 - (5 * length(ailments))))
			var/list/possible_ailments = get_possible_ailments()
			if(length(possible_ailments))
				add_ailment(pick(possible_ailments))

/obj/item/organ/proc/add_ailment(var/datum/ailment/ailment)
	if(ispath(ailment, /datum/ailment))
		ailment = get_ailment_reference(ailment)
	if(!istype(ailment) || !ailment.can_apply_to(src))
		return FALSE
	LAZYADD(ailments, new ailment.type(src))
	return TRUE

/obj/item/organ/proc/add_random_ailment()
	var/list/possible_ailments = get_possible_ailments()
	if(length(possible_ailments))
		add_ailment(pick(possible_ailments))

/obj/item/organ/proc/remove_ailment(var/datum/ailment/ailment)
	if(ispath(ailment, /datum/ailment))
		for(var/datum/ailment/ext_ailment in ailments)
			if(ailment == ext_ailment.type)
				LAZYREMOVE(ailments, ext_ailment)
				return TRUE
	else if(istype(ailment))
		for(var/datum/ailment/ext_ailment in ailments)
			if(ailment == ext_ailment)
				LAZYREMOVE(ailments, ext_ailment)
				return TRUE
	return FALSE

/obj/item/organ/proc/has_diagnosable_ailments(var/mob/user, var/scanner = FALSE)
	for(var/datum/ailment/ailment in ailments)
		if(ailment.manual_diagnosis_string && !scanner)
			LAZYADD(., ailment.replace_tokens(message = ailment.manual_diagnosis_string, user = user))
		else if(ailment.scanner_diagnosis_string && scanner)
			LAZYADD(., ailment.replace_tokens(message = ailment.scanner_diagnosis_string, user = user))

//Handles only the installation of the organ, without triggering any callbacks.
//if we're an internal organ, having a null "target" is legal if we have an "affected"
//CASES:
// 1. When creating organs and running their init this is called to properly set them up
// 2. When installing an organ through surgery this is called.
// 3. When attaching a detached organ through surgery this is called.
// The organ may be inside an external organ that's not inside a mob, or inside a mob
//detached : If true, the organ will be installed in a detached state, otherwise it will be added in an attached state
/obj/item/organ/proc/do_install(var/mob/living/carbon/human/target, var/obj/item/organ/external/affected, var/in_place = FALSE, var/update_icon = TRUE, var/detached = FALSE)
	//Make sure to force the flag accordingly
	set_detached(detached)

	owner = target
	vital_to_owner = null
	action_button_name = initial(action_button_name)
	if(owner)
		forceMove(owner)
		if(!(status & ORGAN_CUT_AWAY)) //Don't run ailments if we're still detached
			for(var/datum/ailment/ailment in ailments)
				ailment.begin_ailment_event()
	else if(affected)
		forceMove(affected) //When installed in a limb with no owner
	return src

//Handles uninstalling the organ from its owner and parent limb, without triggering effects or deep updates
//CASES:
// 1. Before deletion to clear our references.
// 2. Called through removal on surgery or dismemberement
// 3. Called when we're changing a mob's species.
//detach: If detach is true, we're going to set the organ to detached, and add it to the detached organs list, and remove it from processing lists.
//        If its false, we just remove the organ from all lists
/obj/item/organ/proc/do_uninstall(var/in_place = FALSE, var/detach = FALSE, var/ignore_children = FALSE, var/update_icon = TRUE)
	action_button_name = null
	screen_loc = null
	rejecting = null
	for(var/datum/ailment/ailment in ailments)
		if(ailment.timer_id)
			deltimer(ailment.timer_id)
			ailment.timer_id = null

	//When we detach, we set the ORGAN_CUT_AWAY flag on, depending on whether the organ supports it or not
	if(detach)
		set_detached(TRUE)
	else
		owner = null
		vital_to_owner = null
	return src

//Events handling for checks and effects that should happen when removing the organ through interactions. Called by the owner mob.
/obj/item/organ/proc/on_remove_effects(var/mob/living/last_owner)
	START_PROCESSING(SSobj, src)
	vital_to_owner = null

//Events handling for checks and effects that should happen when installing the organ through interactions. Called by the owner mob.
/obj/item/organ/proc/on_add_effects()
	STOP_PROCESSING(SSobj, src)
	vital_to_owner = null

//Since some types of organs completely ignore being detached, moved it to an overridable organ proc for external prosthetics
/obj/item/organ/proc/set_detached(var/is_detached)
	if(is_detached)
		status |= ORGAN_CUT_AWAY
	else
		status &= ~ORGAN_CUT_AWAY

//Some checks to avoid doing type checks for nothing
/obj/item/organ/proc/is_internal()
	return FALSE

// If an organ is inside a holder, the holder should be handling damage in their explosion_act() proc.
/obj/item/organ/explosion_act(severity)
	return !owner && ..()

/obj/item/organ/proc/is_vital_to_owner()
	if(isnull(vital_to_owner))
		if(!owner?.species)
			vital_to_owner = null
			return FALSE
		vital_to_owner = (organ_tag in owner.species.vital_organs)
	return vital_to_owner
