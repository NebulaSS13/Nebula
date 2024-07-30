// Surface base type
/obj/structure/loot_pile/surface
	// Surface loot piles are considerably harder and more dangerous to reach, so you're more likely to get rare things.
	chance_uncommon = 20
	chance_rare = 5
	loot_depletion = TRUE
	loot_left = 5 // This is to prevent people from asking the whole station to go down to some alien ruin to get massive amounts of phat lewt.
	abstract_type = /obj/structure/loot_pile/surface

// Contains old mediciation, most of it unidentified and has a good chance of being useless.
/obj/structure/loot_pile/surface/medicine_cabinet
	name = "abandoned medicine cabinet"
	desc = "An old cabinet, it might still have something of use inside."
	icon_state = "medicine_cabinet"
	density = FALSE
	chance_uncommon = 1
	chance_rare = 1

/obj/structure/loot_pile/surface/medicine_cabinet/get_common_loot()
	var/static/list/common_loot = list(
		/obj/item/pill_bottle/sugariron,
		/obj/item/stack/medical/bandage,
		/obj/item/stack/medical/ointment,
		/obj/item/med_pouch/trauma,
		/obj/item/med_pouch/burn,
		/obj/item/med_pouch/toxin,
		/obj/item/med_pouch/radiation,
		/obj/item/med_pouch/oxyloss,
		/obj/item/chems/hypospray/autoinjector/stabilizer
	)
	return common_loot

/obj/structure/loot_pile/surface/medicine_cabinet/get_uncommon_loot()
	var/static/list/uncommon_loot = list(
		/obj/item/pill_bottle/painkillers,
		/obj/item/stack/medical/splint,
		/obj/item/pill_bottle/burn_meds,
		/obj/item/pill_bottle/brute_meds,
		/obj/item/pill_bottle/antitoxins,
		/obj/item/pill_bottle/antibiotics,
		/obj/item/pill_bottle/oxygen
	)
	return uncommon_loot

/obj/structure/loot_pile/surface/medicine_cabinet/get_rare_loot()
	var/static/list/rare_loot = list(
		/obj/item/stack/medical/bandage/advanced,
		/obj/item/stack/medical/ointment/advanced,
		/obj/item/pill_bottle/strong_painkillers
	)
	return rare_loot

// Like the above but has way better odds, in exchange for being in a place still inhabited (or was recently).
/obj/structure/loot_pile/surface/medicine_cabinet/fresh
	name = "medicine cabinet"
	desc = "A cabinet designed to hold medicine, it might still have something of use inside."
	chance_uncommon = 20
	chance_rare = 5
