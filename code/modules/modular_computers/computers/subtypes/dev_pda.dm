/obj/item/modular_computer/pda
	name = "\improper PDA"
	base_name = "\improper PDA"
	desc = "A very compact computer, designed to keep its user always connected."
	icon = 'icons/obj/modular_computers/pda/pda.dmi'
	screen_icon = 'icons/obj/modular_computers/pda/screens.dmi'
	icon_state = ICON_STATE_WORLD
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic =     MATTER_AMOUNT_REINFORCEMENT,
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
	dark_screen_state = "blank_screen"
	var/owner_name = null
	var/label_assignment = null

/obj/item/modular_computer/pda/on_update_icon()
	. = ..()
	var/mob/living/human/H = loc
	if(istype(H) && H.get_equipped_item(slot_wear_id_str) == src)
		H.update_equipment_overlay(slot_wear_id_str)

/obj/item/modular_computer/pda/update_name()
	if(owner_name || label_assignment)
		var/used_name = owner_name || "Unknown"
		var/used_assignment = label_assignment || "Unknown"
		SetName("[base_name] - [used_name] ([used_assignment])")
	else
		SetName(base_name)

/obj/item/modular_computer/pda/proc/set_owner_rank_job(_owner_name, _label_assignment)
	owner_name = _owner_name
	label_assignment = _label_assignment
	update_name()

// PDA box
/obj/item/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon_state = "pdabox"

/obj/item/box/PDAs/WillContain()
	return list(/obj/item/modular_computer/pda = 5)
