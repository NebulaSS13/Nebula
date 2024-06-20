/obj/item/clothing/mask/smokable/ecig
	name = "electronic cigarette"
	desc = "A device with a modern approach to smoking."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_FACE
	attack_verb = list("attacked", "poked", "battered")
	body_parts_covered = 0
	chem_volume = 0 //ecig has no storage on its own but has reagent container created by parent obj
	material = /decl/material/solid/organic/plastic

	var/brightness_on = 1
	var/cartridge_type = /obj/item/chems/ecig_cartridge/med_nicotine
	var/obj/item/chems/ecig_cartridge/ec_cartridge
	var/power_usage = 450 //value for simple ecig, enough for about 1 cartridge, in JOULES!
	var/ecig_colors = list(null, COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_PURPLE_GRAY)
	var/idle = 0
	var/idle_treshold = 30

/obj/item/clothing/mask/smokable/ecig/Initialize()
	setup_power_supply()
	ec_cartridge = new cartridge_type(src)
	. = ..()

/obj/item/clothing/mask/smokable/ecig/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type   = loaded_cell_type   || /obj/item/cell/device/standard
	accepted_cell_type = accepted_cell_type || /obj/item/cell/device
	return ..(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)

/obj/item/clothing/mask/smokable/ecig/simple
	name = "cheap electronic cigarette"
	desc = "A cheap Lucky 1337 electronic cigarette, styled like a traditional cigarette."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic_cheap.dmi'

/obj/item/clothing/mask/smokable/ecig/simple/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))

/obj/item/clothing/mask/smokable/ecig/util
	name = "electronic cigarette"
	desc = "A popular utilitarian model electronic cigarette, the ONI-55. Comes in a variety of colors."

/obj/item/clothing/mask/smokable/ecig/util/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type = loaded_cell_type || /obj/item/cell/device/high
	return ..(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value) //enough for four cartridges

/obj/item/clothing/mask/smokable/ecig/util/Initialize()
	. = ..()
	set_color(pick(ecig_colors))

/obj/item/clothing/mask/smokable/ecig/util/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))

/obj/item/clothing/mask/smokable/ecig/deluxe
	name = "deluxe electronic cigarette"
	desc = "A premium model eGavana MK3 electronic cigarette, shaped like a cigar."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic_deluxe.dmi'

/obj/item/clothing/mask/smokable/ecig/deluxe/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	loaded_cell_type = loaded_cell_type || /obj/item/cell/device/high
	return ..(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value) //enough for four cartridges

/obj/item/clothing/mask/smokable/ecig/deluxe/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,SPAN_NOTICE("There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining."))
	else
		to_chat(user,SPAN_NOTICE("There's no cartridge connected."))

/obj/item/clothing/mask/smokable/ecig/proc/Deactivate()
	lit = FALSE
	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/item/clothing/mask/smokable/ecig/Process()
	if(!get_cell())
		Deactivate()
		return
	if(!ec_cartridge)
		Deactivate()
		return

	if(idle >= idle_treshold) //idle too long -> automatic shut down
		idle = 0
		visible_message(SPAN_NOTICE("\The [src] powers down automatically."), null, 2)
		Deactivate()
		return

	idle ++

	if(ishuman(loc))
		var/mob/living/human/user = loc

		if (!lit || !ec_cartridge || !ec_cartridge.reagents.total_volume)//no cartridge
			if(!ec_cartridge.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("There's no liquid left in \the [src], so you shut it down."))
			Deactivate()
			return

		if (src == user.get_equipped_item(slot_wear_mask_str) && user.check_has_mouth()) //transfer, but only when not disabled
			idle = 0
			//here we'll reduce battery by usage, and check powerlevel - you only use batery while smoking
			var/obj/item/cell/cell = get_cell()
			if(!cell?.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				Deactivate()
				to_chat(user,SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and shuts down."))
				return
			ec_cartridge.reagents.trans_to_mob(user, REM, CHEM_INHALE, 0.4) // Most of it is not inhaled... balance reasons.

/obj/item/clothing/mask/smokable/ecig/on_update_icon()
	. = ..()
	if(lit)
		set_light(brightness_on)
	else
		set_light(0)
	if(ec_cartridge && check_state_in_icon("[icon_state]-loaded", icon))
		add_overlay("[icon_state]-loaded")
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_equipment_overlay(slot_wear_mask_str, redraw_mob = FALSE)
		M.update_inhand_overlays()

/obj/item/clothing/mask/smokable/ecig/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems/ecig_cartridge))
		if (ec_cartridge)//can't add second one
			to_chat(user, SPAN_NOTICE("A cartridge has already been installed."))
		else if(user.try_unequip(I, src))//fits in new one
			ec_cartridge = I
			update_icon()
			to_chat(user, SPAN_NOTICE("You insert \the [I] into \the [src]."))
		return TRUE
	return ..()

/obj/item/clothing/mask/smokable/ecig/attack_self(mob/user)
	if(lit)
		Deactivate()
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
	else
		var/obj/item/cell/cell = get_cell()
		if(cell)
			if (!ec_cartridge)
				to_chat(user, SPAN_NOTICE("You can't use \the [src] with no cartridge installed!"))
				return
			else if(!ec_cartridge.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("You can't use \the [src] with no liquid left!"))
				return
			else if(!cell.check_charge(power_usage * CELLRATE))
				to_chat(user, SPAN_NOTICE("\The [src]'s power meter flashes a low battery warning and refuses to operate."))
				return
			lit = TRUE
			START_PROCESSING(SSobj, src)
			to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
			update_icon()

		else
			to_chat(user, SPAN_WARNING("\The [src] does not have a battery installed."))

/obj/item/clothing/mask/smokable/ecig/attack_hand(mob/user)//eject cartridge
	if(!user.is_holding_offhand(src) || !ec_cartridge || !user.check_dexterity(DEXTERITY_HOLD_ITEM))
		return ..()
	lit = FALSE
	user.put_in_hands(ec_cartridge)
	to_chat(user, SPAN_NOTICE("You remove \the [ec_cartridge] from \the [src]."))
	ec_cartridge = null
	update_icon()
	return TRUE

/obj/item/chems/ecig_cartridge
	name = "tobacco flavour cartridge"
	desc = "A small metal cartridge, used with electronic cigarettes, which contains an atomizing coil and a solution to be atomized."
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/items/ecig.dmi'
	icon_state = "ecartridge"
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	volume = 20
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

/obj/item/chems/ecig_cartridge/examine(mob/user)//to see how much left
	. = ..()
	to_chat(user, "The cartridge has [reagents.total_volume] units of liquid remaining.")

//flavours
/obj/item/chems/ecig_cartridge/blank
	name = "ecigarette cartridge"
	desc = "A small metal cartridge which contains an atomizing coil."

/obj/item/chems/ecig_cartridge/blanknico
	name = "flavorless nicotine cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says you can add whatever flavoring agents you want."

/obj/item/chems/ecig_cartridge/blanknico/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,  5)
	add_to_reagents(/decl/material/liquid/water,         10)

/obj/item/chems/ecig_cartridge/med_nicotine
	name = "tobacco flavour cartridge"
	desc =  "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored."

/obj/item/chems/ecig_cartridge/med_nicotine/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,  5)
	add_to_reagents(/decl/material/liquid/water,         15)

/obj/item/chems/ecig_cartridge/high_nicotine
	name = "high nicotine tobacco flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored, with extra nicotine."

/obj/item/chems/ecig_cartridge/high_nicotine/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid, 10)
	add_to_reagents(/decl/material/liquid/water,         10)

/obj/item/chems/ecig_cartridge/orange
	name = "orange flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its orange flavored."

/obj/item/chems/ecig_cartridge/orange/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,      5)
	add_to_reagents(/decl/material/liquid/water,             10)
	add_to_reagents(/decl/material/liquid/drink/juice/orange, 5)

/obj/item/chems/ecig_cartridge/mint
	name = "mint flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its mint flavored."

/obj/item/chems/ecig_cartridge/mint/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,  5)
	add_to_reagents(/decl/material/liquid/water,         10)
	add_to_reagents(/decl/material/liquid/menthol,        5)

/obj/item/chems/ecig_cartridge/watermelon
	name = "watermelon flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its watermelon flavored."

/obj/item/chems/ecig_cartridge/watermelon/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,          5)
	add_to_reagents(/decl/material/liquid/water,                  10)
	add_to_reagents(/decl/material/liquid/drink/juice/watermelon, 5)

/obj/item/chems/ecig_cartridge/grape
	name = "grape flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its grape flavored."

/obj/item/chems/ecig_cartridge/grape/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,     5)
	add_to_reagents(/decl/material/liquid/water,            10)
	add_to_reagents(/decl/material/liquid/drink/juice/grape, 5)

/obj/item/chems/ecig_cartridge/lemonlime
	name = "lemon-lime flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its lemon-lime flavored."

/obj/item/chems/ecig_cartridge/lemonlime/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,    5)
	add_to_reagents(/decl/material/liquid/water,            10)
	add_to_reagents(/decl/material/liquid/drink/lemon_lime, 5)

/obj/item/chems/ecig_cartridge/coffee
	name = "coffee flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its coffee flavored."

/obj/item/chems/ecig_cartridge/coffee/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/liquid,  5)
	add_to_reagents(/decl/material/liquid/water,         10)
	add_to_reagents(/decl/material/liquid/drink/coffee,   5)