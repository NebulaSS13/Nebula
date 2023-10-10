/*
 *
 *  Mob Unit Tests.
 *
 *  Human suffocation in Space.
 *  Mob damage Template
 *  Species sprite options
 *
 */

//
// Tests Life() and mob breathing in space.
//

/datum/unit_test/human_breath
	name = "MOB: Breathing Species Suffocate in Space"
	var/list/test_subjects = list()
	async = 1

/datum/unit_test/human_breath/start_test()
	var/turf/T = get_space_turf()

	if(!isspaceturf(T))	//If the above isn't a space turf then we force it to find one will most likely pick 1,1,1
		T = locate(/turf/space)
	for(var/species_name in get_all_species())
		var/decl/species/S = get_species_by_key(species_name)
		var/mob/living/carbon/human/H = new(T, S.name)
		if(H.need_breathe())
			H.apply_effect(20, STUN, 0)
			var/obj/item/organ/internal/lungs/L = H.get_organ(H.species.breathing_organ, /obj/item/organ/internal/lungs)
			if(L)
				L.last_successful_breath = -INFINITY
			test_subjects[S.name] = list(H, damage_check(H, OXY))
	return 1

/datum/unit_test/human_breath/check_result()
	for(var/i in test_subjects)
		var/mob/living/carbon/human/H = test_subjects[i][1]
		if(H.life_tick < 10) 	// Finish Condition
			return 0	// Return 0 to try again later.

	var/failcount = 0
	for(var/i in test_subjects)
		var/mob/living/carbon/human/H = test_subjects[i][1]
		var/ending_oxyloss = damage_check(H, OXY)
		var/starting_oxyloss = test_subjects[i][2]
		if(starting_oxyloss >= ending_oxyloss)
			failcount++
			log_debug("[H.species.name] is not taking oxygen damage, started with [starting_oxyloss] and ended with [ending_oxyloss] at place [log_info_line(H.loc)].")

	if(failcount)
		fail("[failcount] breathing species mobs didn't suffocate in space.")
	else
		pass("All breathing species mobs suffocated in space.")

	return 1	// return 1 to show we're done and don't want to recheck the result.

// ============================================================================

var/global/default_mobloc = null

/proc/create_test_mob_with_mind(var/turf/mobloc = null, var/mobtype = /mob/living/carbon/human)
	var/list/test_result = list("result" = FAILURE, "msg"    = "", "mobref" = null)

	if(isnull(mobloc))
		if(!default_mobloc)
			for(var/turf/simulated/floor/tiled/T in world)
				if(!T.zone?.air)
					continue
				var/pressure = T.zone.air.return_pressure()
				if(90 < pressure && pressure < 120) // Find a turf between 90 and 120
					default_mobloc = T
					break
		mobloc = default_mobloc
	if(!mobloc)
		test_result["msg"] = "Unable to find a location to create test mob"
		return test_result

	var/mob/living/carbon/human/H = new mobtype(mobloc)

	H.mind_initialize("TestKey[rand(0,10000)]")

	test_result["result"] = SUCCESS
	test_result["msg"] = "Mob created"
	test_result["mobref"] = "\ref[H]"

	return test_result

//Generic Check
// TODO: Need to make sure I didn't just recreate the wheel here.

/proc/damage_check(var/mob/living/M, var/damage_type)
	var/loss = null

	switch(damage_type)
		if(BRUTE)
			loss = M.getBruteLoss()
		if(BURN)
			loss = M.getFireLoss()
		if(TOX)
			loss = M.getToxLoss()
		if(OXY)
			loss = M.getOxyLoss()
		if(CLONE)
			loss = M.getCloneLoss()
		if(PAIN)
			loss = M.getHalLoss()

	if(!loss && istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M            // Synthetics have robot limbs which don't report damage to getXXXLoss()
		if(H.isSynthetic())                          // So we have to hard code this check or create a different one for them.
			return H.species.total_health - H.health
	return loss

// ==============================================================================================================

//
//DAMAGE EXPECTATIONS
// used with expectected_vunerability

#define STANDARD 0            // Will take standard damage (damage_ratio of 1)
#define ARMORED 1             // Will take less damage than applied
#define EXTRA_VULNERABLE 2    // Will take more dmage than applied
#define IMMUNE 3              // Will take no damage

//==============================================================================================================


/datum/unit_test/mob_damage
	name = "MOB: Template for mob damage"
	template = /datum/unit_test/mob_damage
	var/damagetype = BRUTE
	var/mob_type = /mob/living/carbon/human
	var/expected_vulnerability = STANDARD
	var/damage_location = BP_CHEST

/datum/unit_test/mob_damage/start_test()
	var/list/test = create_test_mob_with_mind(get_safe_turf(), mob_type)
	var/damage_amount = 4	// Do not raise, if damage >= 5 there is a % chance to reduce damage by half in /obj/item/organ/external/take_damage()
							// Which makes checks impossible.

	if(isnull(test))
		fail("Runtimed in mob creation")

	if(test["result"] == FAILURE)
		fail(test["msg"])
		return 0

	var/mob/living/carbon/human/H = locate(test["mobref"])

	if(isnull(H))
		fail("Test unable to set test mob from reference")
		return 0

	if(H.stat)

		fail("Test needs to be re-written, mob has a stat = [H.stat]")
		return 0

	if(HAS_STATUS(H, STAT_ASLEEP))
		fail("Test needs to be re-written, mob is sleeping for some unknown reason")
		return 0

	// Damage the mob

	var/initial_health = H.health

	if(damagetype == OXY && H.need_breathe())
		var/obj/item/organ/internal/lungs/L = H.get_organ(H.species.breathing_organ, /obj/item/organ/internal/lungs)
		if(L)
			L.last_successful_breath = -INFINITY

	H.apply_damage(damage_amount, damagetype, damage_location)

	var/ending_damage = damage_check(H, damagetype)

	var/ending_health = H.health
	qdel(H)

	// Now test this stuff.

	var/failure = 0

	var/damage_ratio = STANDARD

	if (ending_damage == 0)
		damage_ratio = IMMUNE

	else if (ending_damage < damage_amount)
		damage_ratio = ARMORED

	else if (ending_damage > damage_amount)
		damage_ratio = EXTRA_VULNERABLE

	if(damage_ratio != expected_vulnerability)
		failure = 1

	// Now generate the message for this test.

	var/expected_msg = null

	switch(expected_vulnerability)
		if(STANDARD)
			expected_msg = "To take standard damage"
		if(ARMORED)
			expected_msg = "To take less damage"
		if(EXTRA_VULNERABLE)
			expected_msg = "To take extra damage"
		if(IMMUNE)
			expected_msg = "To take no damage"


	var/msg = "Damage taken: [ending_damage] out of [damage_amount] || expected: [expected_msg] \[Overall Health:[ending_health] (Initial: [initial_health]\]"

	if(failure)
		fail(msg)
	else
		pass(msg)

	return 1

// =================================================================
// Human damage check.
// =================================================================

/datum/unit_test/mob_damage/brute
	name = "MOB: Human Brute damage check"
	damagetype = BRUTE

/datum/unit_test/mob_damage/fire
	name = "MOB: Human Fire damage check"
	damagetype = BURN

/datum/unit_test/mob_damage/tox
	name = "MOB: Human Toxin damage check"
	damagetype = TOX

/datum/unit_test/mob_damage/oxy
	name = "MOB: Human Oxygen damage check"
	damagetype = OXY

/datum/unit_test/mob_damage/clone
	name = "MOB: Human Clone damage check"
	damagetype = CLONE

/datum/unit_test/mob_damage/halloss
	name = "MOB: Human Halloss damage check"
	damagetype = PAIN

// ==============================================================================

/datum/unit_test/robot_module_icons
	name = "MOB: Robot Modules Shall Have UI Icons"
	var/icon_file = 'icons/mob/screen1_robot.dmi'

/datum/unit_test/robot_module_icons/start_test()
	var/failed = 0
	if(!isicon(icon_file))
		fail("[icon_file] is not a valid icon file.")
		return 1

	var/list/valid_states = icon_states(icon_file)

	if(!valid_states.len)
		return 1

	for(var/i=1, i<=SSrobots.all_module_names.len, i++)
		var/modname = lowertext(SSrobots.all_module_names[i])
		var/bad_msg = "[ascii_red]--------------- [modname]"
		if(!(modname in valid_states))
			log_unit_test("[bad_msg] does not contain a valid icon state in [icon_file][ascii_reset]")
			failed=1

	if(failed)
		fail("Some icon states did not exist")
	else
		pass("All modules had valid icon states")

	return 1

#undef IMMUNE

/datum/unit_test/mob_nullspace
	name = "MOB: Mob in nullspace shall not cause runtimes"
	var/list/test_subjects = list()
	async = 1

/datum/unit_test/mob_nullspace/start_test()
	// Simply create one of each species type in nullspace
	for(var/species_name in get_all_species())
		var/test_subject = new/mob/living/carbon/human(null, species_name)
		test_subjects += test_subject
	return TRUE

/datum/unit_test/mob_nullspace/check_result()
	for(var/ts in test_subjects)
		var/mob/living/carbon/human/H = ts
		if(H.life_tick < 10)
			return FALSE

	QDEL_NULL_LIST(test_subjects)

	// No failure state, we just rely on the general runtime check to fail the entire build for us
	pass("Mob nullspace test concluded.")
	return TRUE
/datum/unit_test/mob_organ_size
	name = "MOB: Internal organs fit inside external organs."

/datum/unit_test/mob_organ_size/start_test()
	var/failed = FALSE
	for(var/species_name in get_all_species())
		var/mob/living/carbon/human/H = new(null, species_name)
		for(var/obj/item/organ/external/E in H.get_external_organs())
			for(var/obj/item/organ/internal/I in E.internal_organs)
				if(I.w_class > E.cavity_max_w_class)
					failed = TRUE
					log_bad("Internal organ [I] inside external organ [E] on species [species_name] was too large to fit.")
	if(failed)
		fail("A mob had an internal organ too large for its external organ.")
	else
		pass("All mob organs fit.")
	return TRUE

// ============================================================================

//
// Tests butchery products.
//

/datum/unit_test/mob_butchery
	name = "MOB: All Living Mobs Shall Have Valid Products When Butchery Values Are Set"
	async = 1
	var/list/failed =      list()
	var/list/check_meat =  list()
	var/list/check_skin =  list()
	var/list/check_bones = list()

/datum/unit_test/mob_butchery/start_test()

	for(var/mobtype in subtypesof(/mob/living))

		// Humans use species for their products and are
		// difficult to properly unit test because of this.
		if(ispath(mobtype, /mob/living/carbon/human))
			continue

		var/mob/living/animal = mobtype

		var/mtype = ispath(initial(animal.meat_type))
		var/mcount = initial(animal.meat_amount) > 0
		if(mtype && mcount)
			check_meat += mobtype
		else if(mtype && !mcount)
			failed[mobtype] = "valid meat_type but meat_amount ([mcount]) is below or equal to zero"
		else if(!mtype && mcount)
			failed[mobtype] = "invalid meat_type ([mtype]) but meat_amount above zero"

		var/smat =   initial(animal.skin_material)
		var/stype =  (smat && istype(GET_DECL(smat), /decl/material))
		var/scount = initial(animal.skin_amount) > 0
		if(stype && scount)
			check_skin += mobtype
		else if(stype && !scount)
			failed[mobtype] = "valid skin_material but skin_amount is below or equal to zero"
		else if(!stype && scount)
			failed[mobtype] = "invalid skin_material ([smat]) but skin_amount above zero"

		var/bmat =   initial(animal.bone_material)
		var/btype =  (bmat && istype(GET_DECL(bmat), /decl/material))
		var/bcount = initial(animal.bone_amount) > 0
		if(btype && bcount)
			check_bones += mobtype
		else if(btype && !bcount)
			failed += "[mobtype] - valid bone_material but bone_amount is below or equal to zero"
		else if(!btype && bcount)
			failed += "[mobtype] - invalid bone_material ([bmat]) but bone_amount above zero"

	var/list/spawned_mobs = list()
	for(var/mobtype in check_skin)
		var/mob/living/M = spawned_mobs[mobtype] || new mobtype
		spawned_mobs[mobtype] = M
		if(!length(M.harvest_skin()))
			failed += "[mobtype] - invalid skin products"
	for(var/mobtype in check_bones)
		var/mob/living/M = spawned_mobs[mobtype] || new mobtype
		spawned_mobs[mobtype] = M
		if(!length(M.harvest_bones()))
			failed += "[mobtype] - invalid bone products"
	for(var/mobtype in check_meat)
		var/mob/living/M = spawned_mobs[mobtype] || new mobtype
		spawned_mobs[mobtype] = M
		if(!length(M.harvest_meat()))
			failed += "[mobtype] - invalid meat products"
	for(var/thing in spawned_mobs)
		var/mob/living/M = spawned_mobs[thing]
		if(!QDELETED(M))
			qdel(M)
	spawned_mobs.Cut()

	return TRUE

/datum/unit_test/mob_butchery/check_result()
	if(length(failed))
		fail("Some living mobs with butchery values have invalid values or do not produce valid products:\n[jointext(failed, "\n")]")
	else
		pass("All living mobs with butchery values produce valid products.")
	return TRUE

// ============================================================================

/datum/unit_test/robot_modules_shall_have_appropriate_states
	name = "MOB ICONS: Robot Module Icons Shall Have Appropriate States"

/datum/unit_test/robot_modules_shall_have_appropriate_states/start_test()

	var/list/failures = list()
	for(var/moduletype in typesof(/obj/item/robot_module))
		var/obj/item/robot_module/mod = new
		for(var/sprite in mod.module_sprites)
			var/check_icon = mod.module_sprites[sprite]
			if(!check_state_in_icon("world", check_icon))
				failures += "[moduletype] ([sprite]): [check_icon] missing world sprite"
			if(!check_state_in_icon("world-eyes", check_icon))
				failures += "[moduletype] ([sprite]): [check_icon] missing eyes sprite"

	if(length(failures))
		fail("Some robot modules had invalid or missing icon_states:\n[jointext(failures, "\n")]")
	else
		pass("All robot modules had appropriate icon_states.")
	return 1

// ============================================================================

/datum/unit_test/pai_icons_shall_have_appropriate_states
	name = "MOB ICONS: PAI Icons Shall Have Appropriate States"

/datum/unit_test/pai_icons_shall_have_appropriate_states/start_test()
	var/list/failures = list()
	for(var/chassis in global.possible_chassis)
		var/check_icon = global.possible_chassis[chassis]
		if(!check_state_in_icon("world", check_icon))
			failures += "[chassis]: [check_icon] missing world state"
		if(!check_state_in_icon("world-rest", check_icon))
			failures += "[chassis]: [check_icon] missing world-rest sprite"
		if(!check_state_in_icon("world-dead", check_icon))
			failures += "[chassis]: [check_icon] missing world-dead state"
	if(length(failures))
		fail("Some pAI icons had invalid or missing icon_states:\n[jointext(failures, "\n")]")
	else
		pass("All pAI icons had appropriate icon_states.")
	return 1

// ============================================================================
