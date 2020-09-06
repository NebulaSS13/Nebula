/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon_state = "muzzle"
	item_state = "muzzle"
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/mask/muzzle/Initialize()
	. = ..()
	say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
	say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user)
	if(user.get_equipped_item(BP_MOUTH) == src && !user.check_dexterity(DEXTERITY_GRIP))
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon_state = "sterile"
	item_state = "sterile"
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = SLOT_FACE
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.01
	armor = list(
		bio = ARMOR_BIO_RESISTANT
		)
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_icon_state = "steriledown"
	pull_mask = 1

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon_state = "fake-moustache"
	item_state = "fake-moustache"
	flags_inv = HIDEFACE
	body_parts_covered = 0
	visible_name = "Scoundrel"

/obj/item/clothing/mask/snorkel
	name = "Snorkel"
	desc = "For the Swimming Savant."
	icon_state = "snorkel"
	item_state = "snorkel"
	flags_inv = HIDEFACE
	body_parts_covered = 0

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon_state = "pig"
	item_state = "pig"
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon_state = "horsehead"
	item_state = "horsehead"
	flags_inv = HIDEFACE|BLOCKHAIR
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9

/obj/item/clothing/mask/horsehead/Initialize()
	. = ..()
	// The horse mask doesn't cause voice changes by default, the wizard spell changes the flag as necessary
	say_messages = list("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
	say_verbs = list("whinnies", "neighs", "says")


/obj/item/clothing/mask/ai
	name = "camera MIU"
	desc = "Allows for direct mental connection to accessible camera networks."
	icon_state = "s-ninja"
	item_state = "s-ninja"
	flags_inv = HIDEFACE
	body_parts_covered = SLOT_FACE|SLOT_EYES
	action_button_name = "Toggle MUI"
	origin_tech = "{'programming':5,'engineering':5}"

/obj/item/clothing/mask/ai/Initialize()
	. = ..()
	set_extension(src, /datum/extension/eye/cameranet)

/obj/item/clothing/mask/ai/attack_self(var/mob/user)
	if(user.incapacitated())
		return
	if(user.get_equipped_item(BP_MOUTH) != src)
		to_chat(user, SPAN_WARNING("You must be wearing \the [src] to activate it!"))
		return
	var/datum/extension/eye/cameranet/CN = get_extension(src, /datum/extension/eye)
	if(!CN)
		to_chat(user, SPAN_WARNING("\The [src] doesn't respond!"))
		return
	if(CN.current_looker)
		CN.unlook()
		to_chat(user, SPAN_NOTICE("You deactivate \the [src]."))
	else
		CN.look(user)
		to_chat(user, SPAN_NOTICE("You activate \the [src]."))

/obj/item/clothing/mask/rubber
	name = "rubber mask"
	desc = "A rubber mask."
	icon_state = "balaclava"
	flags_inv = HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.9
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/rubber/barros
	name = "Amaya Barros mask"
	desc = "Current Secretary-General of Sol Cental Government. Not that the real thing would visit this pigsty."
	icon_state = "barros"
	visible_name = "Amaya Barros"

/obj/item/clothing/mask/rubber/admiral
	name = "Admiral Diwali mask"
	desc = "Admiral that led the infamous last stand at Helios against the Independent Navy in the Gaia conflict. For bridge officers who wish they'd achieve a fraction of that."
	icon_state = "admiral"
	visible_name = "Admiral Diwali"

/obj/item/clothing/mask/rubber/turner
	name = "Charles Turner mask"
	desc = "Premier of the Gilgamesh Colonial Confederation. Probably shouldn't wear this in front of your veteran uncle."
	icon_state = "turner"
	visible_name = "Charles Turner"

/obj/item/clothing/mask/rubber/species
	name = "human mask"
	desc = "A rubber human mask."
	icon_state = "manmet"
	var/species = SPECIES_HUMAN

/obj/item/clothing/mask/rubber/species/Initialize()
	. = ..()
	visible_name = species
	var/datum/species/S = get_species_by_key(species)
	if(istype(S))
		var/decl/cultural_info/C = SSlore.get_culture(S.default_cultural_info[TAG_CULTURE])
		if(istype(C))
			visible_name = C.get_random_name(pick(MALE,FEMALE))

/obj/item/clothing/mask/rubber/species/cat
	name = "cat mask"
	desc = "A rubber cat mask."
	icon_state = "catmet"

/obj/item/clothing/mask/spirit
	name = "spirit mask"
	desc = "An eerie mask of ancient, pitted wood."
	icon_state = "spirit_mask"
	item_state = "spirit_mask"
	flags_inv = HIDEFACE
	body_parts_covered = SLOT_FACE|SLOT_EYES

// Bandanas below
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine bandana with nanotech lining. Can be worn on the head or face."
	flags_inv = HIDEFACE
	slot_flags = SLOT_FACE|SLOT_HEAD
	body_parts_covered = SLOT_FACE
	icon_state = "bandblack"
	item_state = "bandblack"
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	switch(slot)
		if(BP_MOUTH) //Mask is the default for all the settings
			flags_inv = initial(flags_inv)
			body_parts_covered = initial(body_parts_covered)
			icon_state = initial(icon_state)
		if(BP_HEAD)
			flags_inv = 0
			body_parts_covered = SLOT_HEAD
			icon_state = "[initial(icon_state)]_up"
			sprite_sheets = list()

	return ..()

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	icon_state = "bandred"
	item_state = "bandred"

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	icon_state = "bandblue"
	item_state = "bandblue"

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	icon_state = "bandgreen"
	item_state = "bandgreen"

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	icon_state = "bandgold"
	item_state = "bandgold"

/obj/item/clothing/mask/bandana/orange
	name = "orange bandana"
	icon_state = "bandorange"
	item_state = "bandorange"

/obj/item/clothing/mask/bandana/purple
	name = "purple bandana"
	icon_state = "bandpurple"
	item_state = "bandpurple"

/obj/item/clothing/mask/bandana/botany
	name = "botany bandana"
	icon_state = "bandbotany"
	item_state = "bandbotany"

/obj/item/clothing/mask/bandana/camo
	name = "camo bandana"
	icon_state = "bandcamo"
	item_state = "bandcamo"

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	desc = "A fine black bandana with nanotech lining and a skull emblem. Can be worn on the head or face."
	icon_state = "bandskull"
	item_state = "bandskull"

