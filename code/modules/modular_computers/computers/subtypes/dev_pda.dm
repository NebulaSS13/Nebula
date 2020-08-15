/obj/item/modular_computer/pda
	name = "\improper PDA"
	desc = "A very compact computer, designed to keep its user always connected."
	icon = 'icons/obj/modular_computers/pda/pda.dmi'
	screen_icon = 'icons/obj/modular_computers/pda/screens.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/plastic =     MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass =       MATTER_AMOUNT_TRACE
	)
	w_class = ITEM_SIZE_SMALL
	light_strength = 2
	slot_flags = SLOT_ID | SLOT_LOWER_BODY
	stores_pen = TRUE
	stored_pen = /obj/item/pen/retractable
	interact_sounds = list('sound/machines/pda_click.ogg')
	interact_sound_volume = 20
	item_flags = ITEM_FLAG_NO_BLUDGEON
	computer_type = /datum/extension/assembly/modular_computer/pda
	color = COLOR_GRAY80

/obj/item/modular_computer/pda/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	var/datum/extension/assembly/assembly = get_extension(src, /datum/extension/assembly)
	var/obj/item/stock_parts/computer/card_slot/card_slot = assembly.get_component(PART_CARD)
	if(card_slot && istype(card_slot.stored_card))
		card_slot.eject_id(user)
	else
		..()

/obj/item/modular_computer/pda/on_update_icon()
	. = ..()
	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_id == src)
		H.update_inv_wear_id()

// PDA box
/obj/item/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon_state = "pdabox"

/obj/item/storage/box/PDAs/Initialize()
	. = ..()
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
