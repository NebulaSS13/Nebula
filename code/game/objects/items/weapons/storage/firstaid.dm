/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon = 'icons/obj/items/storage/firstaid.dmi'
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/organic/plastic
	storage = /datum/storage/firstaid

/obj/item/firstaid/empty
	icon_state = "firstaid"
	name = "First-Aid (empty)"

/obj/item/firstaid/regular
	icon_state = "firstaid"

/obj/item/firstaid/regular/WillContain()
	return list(
		/obj/item/stack/medical/bandage = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/pill_bottle/antibiotics,
		/obj/item/pill_bottle/painkillers,
		/obj/item/stack/medical/splint
		)

/obj/item/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "radfirstaid"
	item_state = "firstaid-ointment"

/obj/item/firstaid/trauma/WillContain()
	return list(/obj/item/med_pouch/trauma = 4)

/obj/item/firstaid/trauma/Initialize(ml, material_key)
	. = ..()
	icon_state = pick("radfirstaid", "radfirstaid2", "radfirstaid3")

/obj/item/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

/obj/item/firstaid/fire/WillContain()
	return list(/obj/item/med_pouch/burn = 4)

/obj/item/firstaid/fire/Initialize(ml, material_key)
	. = ..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

/obj/item/firstaid/toxin/WillContain()
	return list(/obj/item/med_pouch/toxin = 4)

/obj/item/firstaid/toxin/Initialize(ml, material_key)
	. = ..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

/obj/item/firstaid/o2/WillContain()
	return list(/obj/item/med_pouch/oxyloss = 4)

/obj/item/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

/obj/item/firstaid/adv/WillContain()
	return list(
		/obj/item/pill_bottle/assorted,
		/obj/item/stack/medical/bandage/advanced = 3,
		/obj/item/stack/medical/ointment/advanced = 2,
		/obj/item/stack/medical/splint
		)

/obj/item/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

/obj/item/firstaid/combat/WillContain()
	return list(
		/obj/item/pill_bottle/brute_meds,
		/obj/item/pill_bottle/burn_meds,
		/obj/item/pill_bottle/oxygen,
		/obj/item/pill_bottle/antitoxins,
		/obj/item/pill_bottle/strong_painkillers,
		/obj/item/pill_bottle/antibiotics,
		/obj/item/stack/medical/splint,
		)

/obj/item/firstaid/stab
	name = "stabilisation first aid"
	desc = "Stocked with medical pouches."
	icon_state = "stabfirstaid"
	item_state = "firstaid-advanced"

/obj/item/firstaid/stab/WillContain()
	return list(
		/obj/item/med_pouch/trauma,
		/obj/item/med_pouch/burn,
		/obj/item/med_pouch/oxyloss,
		/obj/item/med_pouch/toxin,
		/obj/item/med_pouch/radiation,
		)

/obj/item/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon = 'icons/obj/items/storage/surgerykit.dmi'
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"
	storage = /datum/storage/firstaid/surgery

/obj/item/firstaid/surgery/WillContain()
	return list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/sutures,
		/obj/item/stack/medical/bandage/advanced,
	)

/obj/item/firstaid/surgery/ghetto // Mostly just for debugging.
	name = "shady surgery kit"
	storage = /datum/storage/firstaid/surgery/ghetto

/obj/item/firstaid/surgery/ghetto/WillContain()
	return list(
		/obj/item/screwdriver,
		/obj/item/wrench,
		/obj/item/tool/axe/hatchet,
		/obj/item/utensil/fork,
		/obj/item/shard,
		/obj/item/flame/fuelled/lighter,
		/obj/item/stack/cable_coil
	)

/obj/item/firstaid/clotting
	name = "clotting kit"
	desc = "Contains chemicals to stop bleeding."

/obj/item/firstaid/clotting/WillContain()
	return list(/obj/item/chems/hypospray/autoinjector/clotting = 8)
