/*
 * The 'fancy' path is for objects like candle boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 *
 * Contains:
 *		Egg Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/storage/fancy
	item_state = "syringe_kit" //placeholder, many of these don't have inhands
	opened = 0 //if an item has been removed from this container
	obj_flags = OBJ_FLAG_HOLLOW
	material = /decl/material/solid/cardboard
	var/obj/item/key_type //path of the key item that this "fancy" container is meant to store

/obj/item/storage/fancy/on_update_icon()
	. = ..()
	if(!opened)
		icon_state = initial(icon_state)
	else
		var/key_count = count_by_type(contents, key_type)
		icon_state = "[initial(icon_state)][key_count]"

/obj/item/storage/fancy/examine(mob/user, distance)
	. = ..()
	if(distance > 1)
		return

	var/key_name = initial(key_type.name)
	if(!contents.len)
		to_chat(user, "There are no [key_name]s left in the box.")
	else
		var/key_count = count_by_type(contents, key_type)
		to_chat(user, "There [key_count == 1? "is" : "are"] [key_count] [key_name]\s in the box.")

/*
 * Egg Box
 */

/obj/item/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	name = "egg box"
	storage_slots = 12
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	key_type = /obj/item/chems/food/egg
	can_hold = list(
		/obj/item/chems/food/egg,
		/obj/item/chems/food/boiledegg
		)
	material = /decl/material/solid/cardboard

/obj/item/storage/fancy/egg_box/WillContain()
	return list(/obj/item/chems/food/egg = 12)

/obj/item/storage/fancy/egg_box/empty/WillContain()
	return

/*
 * Cracker Packet
 */

/obj/item/storage/fancy/crackers
	name = "\improper Getmore Crackers"
	icon = 'icons/obj/food.dmi'
	icon_state = "crackerbag"
	storage_slots = 6
	max_w_class = ITEM_SIZE_TINY
	w_class = ITEM_SIZE_SMALL
	key_type = /obj/item/chems/food/cracker
	can_hold = list(/obj/item/chems/food/cracker)
	material = /decl/material/solid/cardboard

/obj/item/storage/fancy/crackers/WillContain()
	return list(/obj/item/chems/food/cracker = 6)

/*
 * Crayon Box
 */

/obj/item/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/items/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 6
	key_type = /obj/item/pen/crayon
	material = /decl/material/solid/cardboard

/obj/item/storage/fancy/crayons/WillContain()
	return list(
			/obj/item/pen/crayon/red,
			/obj/item/pen/crayon/orange,
			/obj/item/pen/crayon/yellow,
			/obj/item/pen/crayon/green,
			/obj/item/pen/crayon/blue,
			/obj/item/pen/crayon/purple,
		)


/obj/item/storage/fancy/crayons/on_update_icon()
	. = ..()
	//#FIXME: This can't handle all crayons types and colors.
	var/list/cur_overlays
	for(var/obj/item/pen/crayon/crayon in contents)
		LAZYADD(cur_overlays, overlay_image(icon, crayon.stroke_colour_name, flags = RESET_COLOR))
	if(LAZYLEN(cur_overlays))
		add_overlay(cur_overlays)

////////////
//CIG PACK//
////////////
/obj/item/storage/fancy/cigarettes
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
	material = /decl/material/solid/cardboard
	key_type = /obj/item/clothing/mask/smokable/cigarette
	atom_flags = ATOM_FLAG_NO_REACT | ATOM_FLAG_OPEN_CONTAINER | ATOM_FLAG_NO_TEMP_CHANGE

/obj/item/storage/fancy/cigarettes/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette = 6)

/obj/item/storage/fancy/cigarettes/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/storage/fancy/cigarettes/initialize_reagents(populate)
	create_reagents(5 * max_storage_space)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
	. = ..()

/obj/item/storage/fancy/cigarettes/remove_from_storage(obj/item/W, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/storage/fancy/cigarettes/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M, /mob))
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

/obj/item/storage/fancy/cigarettes/dromedaryco
	name = "pack of Dromedary Co. cigarettes"
	desc = "A packet of six imported Dromedary Company cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\"."
	icon = 'icons/obj/items/storage/cigpack/dromedary.dmi'
	icon_state = "Dpacket"

/obj/item/storage/fancy/cigarettes/dromedaryco/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/dromedaryco = 6)

/obj/item/storage/fancy/cigarettes/killthroat
	name = "pack of Acme Co. cigarettes"
	desc = "A packet of six Acme Company cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon = 'icons/obj/items/storage/cigpack/acme.dmi'
	icon_state = "Bpacket"

/obj/item/storage/fancy/cigarettes/killthroat/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/killthroat = 6)

/obj/item/storage/fancy/cigarettes/killthroat/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/fuel, (max_storage_space * 4))

// New exciting ways to kill your lungs! - Earthcrusher //

/obj/item/storage/fancy/cigarettes/luckystars
	name = "pack of Lucky Stars"
	desc = "A mellow blend made from synthetic, pod-grown tobacco. The commercial jingle is guaranteed to get stuck in your head."
	icon = 'icons/obj/items/storage/cigpack/lucky_stars.dmi'
	icon_state = "LSpacket"
	item_state = "Dpacket" //I actually don't mind cig packs not showing up in the hand. whotf doesn't just keep them in their pockets/coats //

/obj/item/storage/fancy/cigarettes/luckystars/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/luckystars = 6)

/obj/item/storage/fancy/cigarettes/jerichos
	name = "pack of Jerichos"
	desc = "Typically seen dangling from the lips of Martian soldiers and border world hustlers. Tastes like hickory smoke, feels like warm liquid death down your lungs."
	icon = 'icons/obj/items/storage/cigpack/jerichos.dmi'
	icon_state = "Jpacket"
	item_state = "Dpacket"

/obj/item/storage/fancy/cigarettes/jerichos/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/jerichos = 6)

/obj/item/storage/fancy/cigarettes/menthols
	name = "pack of Temperamento Menthols"
	desc = "With a sharp and natural organic menthol flavor, these Temperamentos are a favorite of NDV crews. Hardly anyone knows they make 'em in non-menthol!"
	icon = 'icons/obj/items/storage/cigpack/menthol.dmi'
	icon_state = "TMpacket"
	item_state = "Dpacket"
	key_type = /obj/item/clothing/mask/smokable/cigarette/menthol

/obj/item/storage/fancy/cigarettes/menthols/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/menthol = 6)

/obj/item/storage/fancy/cigarettes/carcinomas
	name = "pack of Carcinoma Angels"
	desc = "This unknown brand was slated for the chopping block, until they were publicly endorsed by an old Earthling gonzo journalist. The rest is history. They sell a variety for cats, too. Yes, actual cats."
	icon = 'icons/obj/items/storage/cigpack/carcinoma.dmi'
	icon_state = "CApacket"
	item_state = "Dpacket"

/obj/item/storage/fancy/cigarettes/carcinomas/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/carcinomas = 6)

/obj/item/storage/fancy/cigarettes/professionals
	name = "pack of Professional 120s"
	desc = "Let's face it - if you're smoking these, you're either trying to look upper-class or you're 80 years old. That's the only excuse. They taste disgusting, too."
	icon_state = "P100packet"
	icon = 'icons/obj/items/storage/cigpack/professionals.dmi'
	item_state = "Dpacket"

/obj/item/storage/fancy/cigarettes/professionals/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/professionals = 6)

//cigarellos
/obj/item/storage/fancy/cigarettes/cigarello
	name = "pack of Trident Original cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years."
	icon = 'icons/obj/items/storage/cigpack/cigarillo.dmi'
	icon_state = "CRpacket"
	item_state = "Dpacket"
	max_storage_space = 5
	key_type = /obj/item/clothing/mask/smokable/cigarette/trident

/obj/item/storage/fancy/cigarettes/cigarello/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/trident = 5)

/obj/item/storage/fancy/cigarettes/cigarello/variety
	name = "pack of Trident Fruit cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. This is a fruit variety pack."
	icon = 'icons/obj/items/storage/cigpack/cigarillo_fruity.dmi'
	icon_state = "CRFpacket"

/obj/item/storage/fancy/cigarettes/cigarello/variety/WillContain()
	return list(
				/obj/item/clothing/mask/smokable/cigarette/trident/watermelon,
				/obj/item/clothing/mask/smokable/cigarette/trident/orange,
				/obj/item/clothing/mask/smokable/cigarette/trident/grape,
				/obj/item/clothing/mask/smokable/cigarette/trident/cherry,
				/obj/item/clothing/mask/smokable/cigarette/trident/berry
			)

/obj/item/storage/fancy/cigarettes/cigarello/mint
	name = "pack of Trident Menthol cigars"
	desc = "The Trident brand's wood tipped little cigar, favored by the Sol corps diplomatique for their pleasant aroma. Machine made on Mars for over 100 years. These are the menthol variety."
	icon = 'icons/obj/items/storage/cigpack/cigarillo_menthol.dmi'
	icon_state = "CRMpacket"

/obj/item/storage/fancy/cigarettes/cigarello/mint/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/trident/mint = 5)
/*
 * Cigar
*/
/obj/item/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigpacket"
	icon = 'icons/obj/items/storage/cigarcase.dmi'
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	throwforce = 2
	slot_flags = SLOT_LOWER_BODY
	storage_slots = 7
	material = /decl/material/solid/wood/mahogany
	key_type = /obj/item/clothing/mask/smokable/cigarette/cigar
	atom_flags = ATOM_FLAG_NO_REACT | ATOM_FLAG_NO_TEMP_CHANGE

/obj/item/storage/fancy/cigar/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/storage/fancy/cigar/initialize_reagents(populate)
	create_reagents(10 * storage_slots)
	. = ..()

/obj/item/storage/fancy/cigar/WillContain()
	return list(/obj/item/clothing/mask/smokable/cigarette/cigar = 6)

/obj/item/storage/fancy/cigar/remove_from_storage(obj/item/W, atom/new_location)
	var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
	if(!istype(C))
		return
	reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	return ..()

/*
 * Vial Box
 */
/obj/item/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox"
	name = "vial storage box"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	storage_slots = 12
	material = /decl/material/solid/plastic
	key_type = /obj/item/chems/glass/beaker/vial

/obj/item/storage/fancy/vials/WillContain()
	return list(/obj/item/chems/glass/beaker/vial = 12)

/obj/item/storage/fancy/vials/on_update_icon()
	. = ..()
	var/key_count = count_by_type(contents, key_type)
	icon_state = "[initial(icon_state)][FLOOR(key_count/2)]"

/*
 * Not actually a "fancy" storage...
 */
/obj/item/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = null
	storage_slots = 12
	req_access = list(access_virology)
	material = /decl/material/solid/metal/stainlesssteel

/obj/item/storage/lockbox/vials/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/lockbox/vials/on_update_icon()
	. = ..()
	var/total_contents = count_by_type(contents, /obj/item/chems/glass/beaker/vial)
	icon_state = "vialbox[FLOOR(total_contents/2)]"
	if (!broken)
		add_overlay("led[locked]")
		if(locked)
			add_overlay("cover")
	else
		add_overlay("ledb")

/obj/item/storage/lockbox/vials/attackby(obj/item/W, mob/user)
	. = ..()
	update_icon()

////////////////////////////////////////////////////////////////////////////////
// Syndie Cigs
////////////////////////////////////////////////////////////////////////////////

// Flash Powder Pack
/obj/item/storage/fancy/cigarettes/flash_powder
	name = "pack of flash powder laced Trans-Stellar Duty-frees"

/obj/item/storage/fancy/cigarettes/flash_powder/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/fancy/cigarettes/C = /obj/item/storage/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'F' has been scribbled on it."

/obj/item/storage/fancy/cigarettes/flash_powder/populate_reagents()
	reagents.add_reagent(/decl/material/solid/metal/aluminium, max_storage_space)
	reagents.add_reagent(/decl/material/solid/potassium,       max_storage_space)
	reagents.add_reagent(/decl/material/solid/sulfur,          max_storage_space)

//Chemsmoke Pack
/obj/item/storage/fancy/cigarettes/chemsmoke
	name = "pack of smoke powder laced Trans-Stellar Duty-frees"

/obj/item/storage/fancy/cigarettes/chemsmoke/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/fancy/cigarettes/C = /obj/item/storage/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'S' has been scribbled on it."

/obj/item/storage/fancy/cigarettes/chemsmoke/populate_reagents()
	reagents.add_reagent(/decl/material/solid/potassium,        max_storage_space)
	reagents.add_reagent(/decl/material/liquid/nutriment/sugar, max_storage_space)
	reagents.add_reagent(/decl/material/solid/phosphorus,       max_storage_space)

//Mindbreak Pack (now called /decl/chemical_reaction/hallucinogenics)
/obj/item/storage/fancy/cigarettes/mindbreak
	name = "pack of mindbreak toxin laced Trans-Stellar Duty-frees" //#TODO: maybe fix the lore for that?

/obj/item/storage/fancy/cigarettes/mindbreak/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/fancy/cigarettes/C = /obj/item/storage/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'MB' has been scribbled on it." //#TODO: maybe fix the lore for that?

/obj/item/storage/fancy/cigarettes/mindbreak/populate_reagents()
	reagents.add_reagent(/decl/material/solid/silicon,         max_storage_space)
	reagents.add_reagent(/decl/material/liquid/fuel/hydrazine, max_storage_space)
	reagents.add_reagent(/decl/material/liquid/antitoxins,     max_storage_space)

//Tricord pack (now called /decl/material/liquid/regenerator)
/obj/item/storage/fancy/cigarettes/tricord
	name = "pack of tricordazine laced Trans-Stellar Duty-frees" //#TODO: maybe fix the lore for that?

/obj/item/storage/fancy/cigarettes/tricord/Initialize(ml, material_key)
	. = ..()
	//Reset the name to the default cig pack. Done for codex reasons, since it indexes things by initial names
	var/obj/item/storage/fancy/cigarettes/C = /obj/item/storage/fancy/cigarettes
	if(name == initial(name))
		SetName(initial(C.name))
	if(desc == initial(desc))
		desc = "[initial(desc)] 'T' has been scribbled on it." //#TODO: maybe fix the lore for that?

/obj/item/storage/fancy/cigarettes/tricord/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/regenerator, (4 * max_storage_space))
