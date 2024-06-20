////////////
//CIG PACK//
////////////
/obj/item/storage/box/fancy/cigarettes
	name = "pack of Trans-Stellar Duty-frees"
	desc = "A ubiquitous brand of cigarettes, found in the facilities of every major spacefaring corporation in the universe. As mild and flavorless as it gets."
	icon = 'icons/obj/items/storage/cigpack/cigpack.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	key_type = /obj/item/clothing/mask/smokable/cigarette
	atom_flags = ATOM_FLAG_NO_CHEM_CHANGE | ATOM_FLAG_OPEN_CONTAINER

/obj/item/storage/box/fancy/cigarettes/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette = 6)

/obj/item/storage/box/fancy/cigarettes/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/storage/box/fancy/cigarettes/initialize_reagents(populate)
	create_reagents(5 * max_storage_space)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

/obj/item/storage/box/fancy/cigarettes/remove_from_storage(obj/item/W, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/storage/box/fancy/cigarettes/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!ismob(M))
		return

	if(M == user && user.get_target_zone() == BP_MOUTH && contents.len > 0 && !user.get_equipped_item(slot_wear_mask_str))
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = null
		for(var/obj/item/clothing/mask/smokable/cigarette/C in contents)
			cig = C
			break

		if(cig == null)
			to_chat(user, "<span class='notice'>Looks like the packet is out of cigarettes.</span>")
			return

		// Instead of running equip_to_slot_if_possible() we check here first,
		// to avoid dousing cig with reagents if we're not going to equip it
		if(!cig.mob_can_equip(user, slot_wear_mask_str))
			return

		// We call remove_from_storage first to manage the reagent transfer and
		// UI updates.
		remove_from_storage(cig, null)
		user.equip_to_slot(cig, slot_wear_mask_str)

		reagents.maximum_volume = 5 * contents.len
		to_chat(user, "<span class='notice'>You take a cigarette out of the pack.</span>")
		update_icon()
	else
		..()

/obj/item/storage/box/fancy/cigarettes/dromedaryco
	name = "pack of Dromedary Co. cigarettes"
	desc = "A packet of six imported Dromedary Company cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\"."
	icon = 'icons/obj/items/storage/cigpack/dromedary.dmi'
	icon_state = "Dpacket"

/obj/item/storage/box/fancy/cigarettes/dromedaryco/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/dromedaryco = 6)

/obj/item/storage/box/fancy/cigarettes/killthroat
	name = "pack of Acme Co. cigarettes"
	desc = "A packet of six Acme Company cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon = 'icons/obj/items/storage/cigpack/acme.dmi'
	icon_state = "Bpacket"

/obj/item/storage/box/fancy/cigarettes/killthroat/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/killthroat = 6)

/obj/item/storage/box/fancy/cigarettes/killthroat/populate_reagents()
	add_to_reagents(/decl/material/liquid/fuel, (max_storage_space * 4))

// New exciting ways to kill your lungs! - Sunbeamstress //

/obj/item/storage/box/fancy/cigarettes/luckystars
	name = "pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon = 'icons/obj/items/storage/cigpack/lucky_stars.dmi'
	icon_state = "LSpacket"
	item_state = "Dpacket" //I actually don't mind cig packs not showing up in the hand. whotf doesn't just keep them in their pockets/coats //

/obj/item/storage/box/fancy/cigarettes/luckystars/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/luckystars = 6)

/obj/item/storage/box/fancy/cigarettes/jerichos
	name = "pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon = 'icons/obj/items/storage/cigpack/jerichos.dmi'
	icon_state = "Jpacket"
	item_state = "Dpacket"

/obj/item/storage/box/fancy/cigarettes/jerichos/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/jerichos = 6)

/obj/item/storage/box/fancy/cigarettes/menthols
	name = "pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon = 'icons/obj/items/storage/cigpack/menthol.dmi'
	icon_state = "TMpacket"
	item_state = "Dpacket"
	key_type = /obj/item/clothing/mask/smokable/cigarette/menthol

/obj/item/storage/box/fancy/cigarettes/menthols/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/menthol = 6)

/obj/item/storage/box/fancy/cigarettes/carcinomas
	name = "pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too. Yes, actual cats."
	icon = 'icons/obj/items/storage/cigpack/carcinoma.dmi'
	icon_state = "CApacket"
	item_state = "Dpacket"

/obj/item/storage/box/fancy/cigarettes/carcinomas/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/carcinomas = 6)

/obj/item/storage/box/fancy/cigarettes/professionals
	name = "pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They taste disgusting, too."
	icon_state = "P100packet"
	icon = 'icons/obj/items/storage/cigpack/professionals.dmi'
	item_state = "Dpacket"

/obj/item/storage/box/fancy/cigarettes/professionals/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/professionals = 6)

//cigarellos
/obj/item/storage/box/fancy/cigarettes/cigarello
	name = "pack of Trident Original cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years."
	icon = 'icons/obj/items/storage/cigpack/cigarillo.dmi'
	icon_state = "CRpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	key_type = /obj/item/clothing/mask/smokable/cigarette/trident

/obj/item/storage/box/fancy/cigarettes/cigarello/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/trident = 5)

/obj/item/storage/box/fancy/cigarettes/cigarello/variety
	name = "pack of Trident Fruit cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. This is a fruit variety pack."
	icon = 'icons/obj/items/storage/cigpack/cigarillo_fruity.dmi'
	icon_state = "CRFpacket"

/obj/item/storage/box/fancy/cigarettes/cigarello/variety/WillContain()
	return list(
				/obj/item/clothing/mask/smokable/cigarette/trident/watermelon,
				/obj/item/clothing/mask/smokable/cigarette/trident/orange,
				/obj/item/clothing/mask/smokable/cigarette/trident/grape,
				/obj/item/clothing/mask/smokable/cigarette/trident/cherry,
				/obj/item/clothing/mask/smokable/cigarette/trident/berry
			)

/obj/item/storage/box/fancy/cigarettes/cigarello/mint
	name = "pack of Trident Menthol cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. These are the menthol variety."
	icon = 'icons/obj/items/storage/cigpack/cigarillo_menthol.dmi'
	icon_state = "CRMpacket"

/obj/item/storage/box/fancy/cigarettes/cigarello/mint/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/trident/mint = 5)

////////////////////////////////////////////////////////////////////////////////
// Syndie Cigs
////////////////////////////////////////////////////////////////////////////////

// Flash Powder Pack
/obj/item/storage/box/fancy/cigarettes/flash_powder
	name = "pack of flash powder laced Trans-Stellar Duty-frees"

/obj/item/storage/box/fancy/cigarettes/flash_powder/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/box/fancy/cigarettes/C = /obj/item/storage/box/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'F' has been scribbled on it."

/obj/item/storage/box/fancy/cigarettes/flash_powder/populate_reagents()
	add_to_reagents(/decl/material/solid/metal/aluminium, max_storage_space)
	add_to_reagents(/decl/material/solid/potassium,       max_storage_space)
	add_to_reagents(/decl/material/solid/sulfur,          max_storage_space)

//Chemsmoke Pack
/obj/item/storage/box/fancy/cigarettes/chemsmoke
	name = "pack of smoke powder laced Trans-Stellar Duty-frees"

/obj/item/storage/box/fancy/cigarettes/chemsmoke/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/box/fancy/cigarettes/C = /obj/item/storage/box/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'S' has been scribbled on it."

/obj/item/storage/box/fancy/cigarettes/chemsmoke/populate_reagents()
	add_to_reagents(/decl/material/solid/potassium,        max_storage_space)
	add_to_reagents(/decl/material/liquid/nutriment/sugar, max_storage_space)
	add_to_reagents(/decl/material/solid/phosphorus,       max_storage_space)

//Mindbreak Pack (now called /decl/chemical_reaction/hallucinogenics)
/obj/item/storage/box/fancy/cigarettes/mindbreak
	name = "pack of mindbreak toxin laced Trans-Stellar Duty-frees" //#TODO: maybe fix the lore for that?

/obj/item/storage/box/fancy/cigarettes/mindbreak/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/box/fancy/cigarettes/C = /obj/item/storage/box/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'MB' has been scribbled on it." //#TODO: maybe fix the lore for that?

/obj/item/storage/box/fancy/cigarettes/mindbreak/populate_reagents()
	add_to_reagents(/decl/material/solid/silicon,         max_storage_space)
	add_to_reagents(/decl/material/liquid/fuel/hydrazine, max_storage_space)
	add_to_reagents(/decl/material/liquid/antitoxins,     max_storage_space)

//Tricord pack (now called /decl/material/liquid/regenerator)
/obj/item/storage/box/fancy/cigarettes/tricord
	name = "pack of tricordazine laced Trans-Stellar Duty-frees" //#TODO: maybe fix the lore for that?

/obj/item/storage/box/fancy/cigarettes/tricord/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/box/fancy/cigarettes/C = /obj/item/storage/box/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'T' has been scribbled on it." //#TODO: maybe fix the lore for that?

/obj/item/storage/box/fancy/cigarettes/tricord/populate_reagents()
	add_to_reagents(/decl/material/liquid/regenerator, (4 * max_storage_space))
