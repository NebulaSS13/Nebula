/datum/unit_test/gear_rig_validation_test
	name = "GEAR: All Rigs Shall Have Non-Null Component Types"

/datum/unit_test/gear_rig_validation_test/start_test()
	var/list/results = list()
	for(var/rigtype in subtypesof(/obj/item/rig))
		var/res = ""
		var/obj/item/rig/rig = new rigtype
		if(initial(rig.gloves) == null)
			res = "[res] - null initial gloves"
		if(initial(rig.chest) == null)
			res = "[res] - null initial chest"
		if(initial(rig.helmet) == null)
			res = "[res] - null initial helmet"
		if(initial(rig.boots) == null)
			res = "[res] - null initial boots"
		if(res)
			results += "[rigtype] - [res]"
	if(length(results))
		fail("Some rig components were null:\n[jointext(results, "\n")].")
	else
		pass("No invalid rigs.")
	return TRUE

/datum/unit_test/gear_clothing_icon_state_test
	name = "GEAR: All Clothing Shall Have Valid Icons"

/datum/unit_test/gear_clothing_icon_state_test/start_test()

	var/list/check_types = subtypesof(/obj/item/clothing)
	var/list/onmob_exception_list = list(
		/obj/item/clothing/accessory/buddytag,
		/obj/item/clothing/accessory/armor/plate,
		/obj/item/clothing/accessory/armor/tag/oneg,
		/obj/item/clothing/accessory/armor/tag/opos,
		/obj/item/clothing/accessory/armor/tag/apos,
		/obj/item/clothing/accessory/armor/tag/aneg,
		/obj/item/clothing/accessory/armor/tag/bpos,
		/obj/item/clothing/accessory/armor/tag/bneg,
		/obj/item/clothing/accessory/armor/tag/abpos,
		/obj/item/clothing/accessory/armor/tag/abneg
	)
	for(var/checktype in onmob_exception_list)
		onmob_exception_list |= typesof(checktype)

	var/list/results = list()
	for(var/clothing_type in check_types)
		var/obj/item/clothing/clothes = clothing_type
		var/initial_state = initial(clothes.icon_state)
		var/initial_item_state = initial(clothes.item_state)
		var/initial_icon = initial(clothes.icon)
		var/res
		if(!initial_icon)
			res = "[res] - missing icon"
		else if(ispath(clothing_type, /obj/item/clothing/accessory) && !check_state_in_icon("humanoid body-slot_tie", initial_icon) && !(clothing_type in onmob_exception_list))
			res = "[res] - accessory with no tie state ([initial_icon])"
		if(!initial_state)
			res = "[res] - no initial state"
		else if(initial_state != ICON_STATE_WORLD && initial_state != ICON_STATE_INV)
			res = "[res] - unconverted initial state ([initial_state])"
		else if(initial_icon && !check_state_in_icon(initial_state, initial_icon))
			res = "[res] - missing initial state ([initial_state], [initial_icon])"
		if(initial_item_state)
			res = "[res] - initial item state ([initial_item_state])"
		if(res)
			results += "[clothing_type][res]"

	if(length(results))
		fail("Some clothing failed validation:\n[jointext(results, "\n")]")
	else
		pass("All clothing passed validation paths.")
	return TRUE
