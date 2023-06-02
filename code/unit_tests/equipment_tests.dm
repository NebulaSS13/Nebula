/datum/unit_test/vision_glasses
	name = "EQUIPMENT: Vision Template"
	template = /datum/unit_test/vision_glasses
	var/mob/living/carbon/human/H = null
	var/expectation = SEE_INVISIBLE_NOLIGHTING
	var/glasses_type = null
	async = 1

/datum/unit_test/vision_glasses/start_test()
	var/list/test = create_test_mob_with_mind(get_safe_turf(), /mob/living/carbon/human)
	if(isnull(test))
		fail("Check Runtimed in Mob creation")

	if(test["result"] == FAILURE)
		fail(test["msg"])
		async = 0
		return 0

	H = locate(test["mobref"])
	H.equip_to_slot(new glasses_type(H), slot_glasses_str)
	return 1

/datum/unit_test/vision_glasses/check_result()

	if(isnull(H) || H.life_tick < 2)
		return 0

	if(isnull(H.get_equipped_item(slot_glasses_str)))
		fail("Mob doesn't have glasses on")

	H.handle_vision()	// Because Life has a client check that bypasses updating vision

	if(H.see_invisible == expectation)
		pass("Mob See invisible is [H.see_invisible]")
	else
		fail("Mob See invisible is [H.see_invisible] / expected [expectation]")

	return 1

/datum/unit_test/vision_glasses/NVG
	name = "EQUIPMENT: NVG see_invis"
	glasses_type = /obj/item/clothing/glasses/night

/datum/unit_test/vision_glasses/mesons
	name = "EQUIPMENT: Mesons see_invis"
	glasses_type = /obj/item/clothing/glasses/meson

/datum/unit_test/vision_glasses/plain
	name = "EQUIPMENT: Plain glasses. see_invis"
	glasses_type = /obj/item/clothing/glasses/prescription
	expectation = SEE_INVISIBLE_LIVING

// ============================================================================

/datum/unit_test/storage_capacity_test
	name = "EQUIPMENT: Storage items should be able to actually hold their initial contents"

/datum/unit_test/storage_capacity_test/start_test()
	var/bad_tests = 0

	// obj/item/storage/internal cannot be tested sadly, as they expect their host object to create them
	for(var/storage_type in subtypesof(/obj/item/storage) - typesof(/obj/item/storage/internal))
		var/obj/item/storage/S = new storage_type(null) //should be fine to put it in nullspace...
		var/bad_msg = "[ascii_red]--------------- [S.name] \[[S.type]\]"
		bad_tests += test_storage_capacity(S, bad_msg)

	if(bad_tests)
		fail("\[[bad_tests]\] Some storage item types were not able to hold their default initial contents.")
	else
		pass("All storage item types were able to hold their default initial contents.")

	return 1

/proc/test_storage_capacity(obj/item/storage/S, var/bad_msg)
	var/bad_tests = 0

	if(!isnull(S.storage_slots) && S.contents.len > S.storage_slots)
		log_unit_test("[bad_msg] Contains more items than it has slots for ([S.contents.len] / [S.storage_slots]). [ascii_reset]")
		bad_tests++

	var/total_storage_space = 0
	for(var/obj/item/I in S.contents)
		if(I.w_class > S.max_w_class)
			log_unit_test("[bad_msg] Contains an item \[[I.type]\] that is too big to be held ([I.w_class] / [S.max_w_class]). [ascii_reset]")
			bad_tests++
		if(istype(I, /obj/item/storage) && I.w_class >= S.w_class)
			log_unit_test("[bad_msg] Contains a storage item \[[I.type]\] the same size or larger than its container ([I.w_class] / [S.w_class]). [ascii_reset]")
			bad_tests++
		total_storage_space += I.get_storage_cost()

	if(total_storage_space > S.max_storage_space)
		log_unit_test("[bad_msg] Contains more items than it has storage space for ([total_storage_space] / [S.max_storage_space]). [ascii_reset]")
		bad_tests++

	return bad_tests

// ============================================================================

/datum/unit_test/equipment_slot_test
	name = "EQUIPMENT: Equipment should equip and unequip to slots in the expected manner"
	var/list/slot_to_valid_type
	var/slot_invalid_type = /obj/item/toy/balloon
	var/list/created_atoms = list()

/datum/unit_test/equipment_slot_test/New()
	..()
	/// Ordering is important here, dependencies like ID should be after uniform, etc.
	slot_to_valid_type = list(
		"[slot_w_uniform_str]" = /obj/item/clothing/under/lawyer/purpsuit,
		"[slot_back_str]"      = /obj/item/storage/backpack/clown,
		"[slot_wear_id_str]"   = /obj/item/card/id,
		"[slot_glasses_str]"   = /obj/item/clothing/glasses/meson,
		"[slot_wear_mask_str]" = /obj/item/clothing/mask/gas/sexyclown,
		"[slot_head_str]"      = /obj/item/clothing/head/hairflower,
		"[slot_shoes_str]"     = /obj/item/clothing/shoes/magboots,
		"[slot_gloves_str]"    = /obj/item/clothing/gloves/rainbow,
		"[slot_l_ear_str]"     = /obj/item/clothing/head/hairflower,
		"[slot_r_ear_str]"     = /obj/item/clothing/head/hairflower,
		"[slot_belt_str]"      = /obj/item/storage/belt/utility,
		"[slot_wear_suit_str]" = /obj/item/clothing/suit/chickensuit
	)

/datum/unit_test/equipment_slot_test/proc/check_slot_equip_successful(mob/living/carbon/human/subject, obj/item/item, which_slot, list/failure_list)
	created_atoms |= item
	subject.equip_to_slot_if_possible(item, which_slot)
	if(!subject.isEquipped(item))
		failure_list += "[item] was equipped to [which_slot] but failed isEquipped."
	else if(subject.get_equipped_slot_for_item(item) != which_slot)
		var/equipped_location = subject.get_equipped_slot_for_item(item)
		failure_list += "[item] was expected to be equipped to [which_slot] but get_equipped_slot_for_item returned [isnull(equipped_location) ? "NULL" : equipped_location]."

/datum/unit_test/equipment_slot_test/proc/check_slot_unequip_successful(mob/living/carbon/human/subject, obj/item/item, which_slot, list/failure_list)
	created_atoms |= item
	subject.try_unequip(item)
	if(subject.isEquipped(item))
		failure_list += "[item] remained equipped to [subject.get_equipped_slot_for_item(item)] after unEquip was called."

/datum/unit_test/equipment_slot_test/proc/check_slot_equip_failure(mob/living/carbon/human/subject, obj/item/item, which_slot, list/failure_list)
	created_atoms |= item
	subject.equip_to_slot_if_possible(item, which_slot)
	if(subject.isEquipped(item))
		var/equipped_location = subject.get_equipped_slot_for_item(item)
		failure_list += "isEquipped([item]) returned true but should have failed (was equipped to [isnull(equipped_location) ? "NULL" : equipped_location])."
	else if(subject.get_equipped_slot_for_item(item))
		var/equipped_location = subject.get_equipped_slot_for_item(item)
		failure_list += "[item] was equipped to [equipped_location] despite failing isEquipped (should not be equipped)."

/datum/unit_test/equipment_slot_test/start_test()
	var/mob/living/carbon/human/subject = new(get_safe_turf())
	created_atoms |= subject
	var/list/failures = list()

	// First we try to dress them up.
	for(var/slot in slot_to_valid_type)
		var/slot_type = slot_to_valid_type[slot]
		check_slot_equip_successful(subject, new slot_type, slot, failures)

	// Now we try to unequip.
	for(var/i = length(slot_to_valid_type) to 1 step -1)
		var/slot = slot_to_valid_type[i]
		var/item = subject.get_equipped_item(slot)
		if(item) // If something failed to equip last step, it might be missing now.
			check_slot_unequip_successful(subject, item, slot, failures)

	// Try to equip an unequippable item.
	subject.dump_contents()
	for(var/slot in slot_to_valid_type)
		check_slot_equip_failure(subject, new slot_invalid_type, slot, failures)

	// Check ID, belt and pockets depending on uniform.
	var/belt_type =    slot_to_valid_type[slot_belt_str]
	var/id_type =      slot_to_valid_type[slot_wear_id_str]
	var/uniform_type = slot_to_valid_type[slot_w_uniform_str]
	check_slot_equip_failure(subject,    new belt_type,              slot_belt_str,      failures)
	check_slot_equip_failure(subject,    new id_type,                slot_wear_id_str,   failures)
	check_slot_equip_failure(subject,    new /obj/item/screwdriver,  slot_l_store_str,   failures)
	check_slot_equip_failure(subject,    new /obj/item/coin,         slot_r_store_str,   failures)
	check_slot_equip_successful(subject, new uniform_type,           slot_w_uniform_str, failures)
	check_slot_equip_successful(subject, new belt_type,              slot_belt_str,      failures)
	check_slot_equip_successful(subject, new id_type,                slot_wear_id_str,   failures)
	check_slot_equip_successful(subject, new /obj/item/screwdriver,  slot_l_store_str,   failures)
	check_slot_equip_successful(subject, new /obj/item/coin,         slot_r_store_str,   failures)

	// Check suit storage depending on suit.
	var/obj/item/clothing/suit/suit = new /obj/item/clothing/suit/space/void/mining
	var/suit_item_type = suit.allowed[1]
	check_slot_equip_failure(subject,    new suit_item_type, slot_s_store_str,   failures)
	check_slot_equip_successful(subject, suit,               slot_wear_suit_str, failures)
	check_slot_equip_successful(subject, new suit_item_type, slot_s_store_str,   failures)

	// Report results.
	if(length(failures))
		fail("[length(failures)] problems with equipment slots:\n\t- [jointext(failures,"\n\t- ")]")
	else
		pass("No problems with equipment slots detected.")
	QDEL_NULL_LIST(created_atoms)
	return TRUE
