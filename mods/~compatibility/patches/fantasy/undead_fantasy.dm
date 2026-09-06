/mob/living/human/skeleton/hnoll/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/hnoll::uid
	. = ..()

/mob/living/human/skeleton/kobaloi/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/kobaloi::uid
	. = ..()

/mob/living/human/zombie/hnoll/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/hnoll::uid
	. = ..()

/mob/living/human/zombie/kobaloi/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	if(!species_uid)
		species_uid = /decl/species/kobaloi::uid
	. = ..()

/mob/living/human/grant_basic_undead_equipment()

	var/species_name = get_species_name()
	if(species_name == /decl/species/human::name || species_name == /decl/species/hnoll::name)
		var/pants_type = pick(/obj/item/clothing/pants/trousers, /obj/item/clothing/pants/trousers/braies)
		equip_to_slot_or_del(new pants_type(src), slot_w_uniform_str)

		var/jerkin_type = pick(/obj/item/clothing/shirt/tunic, /obj/item/clothing/shirt/tunic/short, /obj/item/clothing/shirt/jerkin)
		equip_to_slot_or_del(new jerkin_type(src), slot_w_uniform_str)

		if(prob(30))
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/forged/banded(src), slot_wear_suit_str)
		else
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/crafted/leather(src), slot_wear_suit_str)
		if(prob(20))
			put_in_active_hand(new /obj/item/bladed/broadsword(src))
		else
			put_in_active_hand(new /obj/item/bladed/shortsword(src))
			put_in_inactive_hand(new /obj/item/shield/crafted/buckler(src))
		return

	if(species_name == /decl/species/kobaloi::name)

		var/pants_type = pick(/obj/item/clothing/pants/trousers/braies, /obj/item/clothing/pants/loincloth)
		equip_to_slot_or_del(new pants_type(src), slot_w_uniform_str)
		if(prob(75))
			var/jerkin_type = pick(/obj/item/clothing/shirt/tunic/short, /obj/item/clothing/shirt/jerkin)
			equip_to_slot_or_del(new jerkin_type(src), slot_w_uniform_str)

		if(prob(30))
			equip_to_slot_or_del(new /obj/item/clothing/suit/armor/crafted/leather(src), slot_wear_suit_str)
			put_in_active_hand(new /obj/item/bladed/knife(src))
		return
