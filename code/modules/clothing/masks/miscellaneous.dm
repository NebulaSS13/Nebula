/obj/item/clothing/mask/muzzle
	name = "muzzle"
	desc = "To stop that awful noise."
	icon = 'icons/clothing/mask/muzzle.dmi'
	icon_state = ICON_STATE_WORLD
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	voicechange = 1

/obj/item/clothing/mask/muzzle/tape
	name = "length of tape"
	desc = "It's a robust DIY muzzle!"
	icon = 'icons/clothing/mask/muzzle_tape.dmi'
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/mask/muzzle/Initialize()
	. = ..()
	say_messages = list("Mmfph!", "Mmmf mrrfff!", "Mmmf mnnf!")
	say_verbs = list("mumbles", "says")

// Clumsy folks can't take the mask off themselves.
/obj/item/clothing/mask/muzzle/attack_hand(mob/user)
	if(user.wear_mask == src && !user.check_dexterity(DEXTERITY_GRIP))
		return 0
	..()

/obj/item/clothing/mask/surgical
	name = "sterile mask"
	desc = "A sterile mask designed to help prevent the spread of diseases."
	icon = 'icons/clothing/mask/sterile.dmi'
	icon_state = ICON_STATE_WORLD
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
	pull_mask = 1
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/fakemoustache
	name = "fake moustache"
	desc = "Warning: moustache is fake."
	icon = 'icons/clothing/mask/moustache.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE
	body_parts_covered = 0
	visible_name = "Scoundrel"

/obj/item/clothing/mask/snorkel
	name = "snorkel"
	desc = "For the swimming savant."
	icon = 'icons/clothing/mask/snorkel.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE
	body_parts_covered = 0
	material = /decl/material/solid/plastic

/obj/item/clothing/mask/pig
	name = "pig mask"
	desc = "A rubber pig mask."
	icon = 'icons/clothing/mask/pig.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE|BLOCKHAIR
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 0.9
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES

/obj/item/clothing/mask/horsehead
	name = "horse head mask"
	desc = "A mask made of soft vinyl and latex, representing the head of a horse."
	icon = 'icons/clothing/mask/horsehead.dmi'
	icon_state = ICON_STATE_WORLD
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
	icon = 'icons/clothing/mask/ninja.dmi'
	icon_state = ICON_STATE_WORLD
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
	if(user.get_equipped_item(slot_wear_mask_str) != src)
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
	icon = 'icons/clothing/mask/balaclava.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE|BLOCKHAIR
	siemens_coefficient = 0.9
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/rubber/barros
	name = "Amaya Barros mask"
	desc = "Current Secretary-General of Sol Cental Government. Not that the real thing would visit this pigsty."
	icon = 'icons/clothing/mask/barros.dmi'
	visible_name = "Amaya Barros"

/obj/item/clothing/mask/rubber/admiral
	name = "Admiral Diwali mask"
	desc = "Admiral that led the infamous last stand at Helios against the Independent Navy in the Gaia conflict. For bridge officers who wish they'd achieve a fraction of that."
	icon = 'icons/clothing/mask/admiral.dmi'
	visible_name = "Admiral Diwali"

/obj/item/clothing/mask/rubber/turner
	name = "Charles Turner mask"
	desc = "Premier of the Gilgamesh Colonial Confederation. Probably shouldn't wear this in front of your veteran uncle."
	icon = 'icons/clothing/mask/turner.dmi'
	visible_name = "Charles Turner"

/obj/item/clothing/mask/rubber/species
	name = "human mask"
	desc = "A rubber human mask."
	icon = 'icons/clothing/mask/human.dmi'
	var/species = SPECIES_HUMAN

/obj/item/clothing/mask/rubber/species/Initialize()
	. = ..()
	visible_name = species
	var/decl/species/S = get_species_by_key(species)
	if(istype(S))
		var/decl/cultural_info/C = SSlore.get_culture(S.default_cultural_info[TAG_CULTURE])
		if(istype(C))
			visible_name = C.get_random_name(pick(MALE,FEMALE))

/obj/item/clothing/mask/rubber/species/cat
	name = "cat mask"
	desc = "A rubber cat mask."
	icon = 'icons/clothing/mask/cat.dmi'

/obj/item/clothing/mask/spirit
	name = "spirit mask"
	desc = "An eerie mask of ancient, pitted wood."
	icon = 'icons/clothing/mask/spirit.dmi'
	flags_inv = HIDEFACE
	body_parts_covered = SLOT_FACE|SLOT_EYES
	material = /decl/material/solid/cloth

// Bandanas below
/obj/item/clothing/mask/bandana
	name = "black bandana"
	desc = "A fine bandana. Can be worn on the head or face."
	icon = 'icons/clothing/head/bandana.dmi'
	icon_state = ICON_STATE_WORLD
	color = COLOR_BLACK
	flags_inv = HIDEFACE
	slot_flags = SLOT_FACE|SLOT_HEAD
	body_parts_covered = SLOT_FACE
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/bandana/equipped(var/mob/user, var/slot)
	if(slot == slot_head_str)
		flags_inv = 0
		body_parts_covered = SLOT_HEAD
	else
		flags_inv = initial(flags_inv)
		body_parts_covered = initial(body_parts_covered)

/obj/item/clothing/mask/bandana/red
	name = "red bandana"
	color = COLOR_RED

/obj/item/clothing/mask/bandana/blue
	name = "blue bandana"
	color = COLOR_BLUE

/obj/item/clothing/mask/bandana/green
	name = "green bandana"
	color = COLOR_GREEN

/obj/item/clothing/mask/bandana/gold
	name = "gold bandana"
	color = COLOR_GOLD

/obj/item/clothing/mask/bandana/orange
	name = "orange bandana"
	color = COLOR_ORANGE

/obj/item/clothing/mask/bandana/purple
	name = "purple bandana"
	color = COLOR_PURPLE

/obj/item/clothing/mask/bandana/botany
	name = "botany bandana"
	color = null
	icon = 'icons/clothing/head/bandana_botany.dmi'

/obj/item/clothing/mask/bandana/camo
	name = "camo bandana"
	color = null
	icon = 'icons/clothing/head/bandana_camo.dmi'

/obj/item/clothing/mask/bandana/skull
	name = "skull bandana"
	color = null
	desc = "A fine black bandana with a skull emblem. Can be worn on the head or face."
	icon = 'icons/clothing/head/bandana_skull.dmi'
