/obj/item/clothing/mask/smokable/ecig
	name = "electronic cigarette"
	desc = "A device with a modern approach to smoking."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic.dmi'
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_FACE
	attack_verb = list("attacked", "poked", "battered")
	body_parts_covered = 0
	chem_volume = 0 //ecig has no storage on its own but has reagent container created by parent obj

	var/brightness_on = 1
	var/obj/item/cell/cigcell
	var/cartridge_type = /obj/item/chems/ecig_cartridge/med_nicotine
	var/obj/item/chems/ecig_cartridge/ec_cartridge
	var/cell_type = /obj/item/cell/device/standard
	var/icon_off
	var/icon_empty
	var/power_usage = 450 //value for simple ecig, enough for about 1 cartridge, in JOULES!
	var/ecig_colors = list(null, COLOR_DARK_GRAY, COLOR_RED_GRAY, COLOR_BLUE_GRAY, COLOR_GREEN_GRAY, COLOR_PURPLE_GRAY)
	var/idle = 0
	var/idle_treshold = 30

/obj/item/clothing/mask/smokable/ecig/Initialize()
	if(ispath(cell_type))
		cigcell = new cell_type
	ec_cartridge = new cartridge_type(src)
	. = ..()

/obj/item/clothing/mask/smokable/ecig/get_cell()
	return cigcell

/obj/item/clothing/mask/smokable/ecig/simple
	name = "cheap electronic cigarette"
	desc = "A cheap Lucky 1337 electronic cigarette, styled like a traditional cigarette."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic_cheap.dmi'

/obj/item/clothing/mask/smokable/ecig/simple/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,"<span class='notice'>There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining.</span>")
	else
		to_chat(user,"<span class='notice'>There's no cartridge connected.</span>")

/obj/item/clothing/mask/smokable/ecig/util
	name = "electronic cigarette"
	desc = "A popular utilitarian model electronic cigarette, the ONI-55. Comes in a variety of colors."
	cell_type = /obj/item/cell/device/high //enough for four cartridges

/obj/item/clothing/mask/smokable/ecig/util/Initialize()
	. = ..()
	color = pick(ecig_colors)

obj/item/clothing/mask/smokable/ecig/util/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,"<span class='notice'>There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining.</span>")
	else
		to_chat(user,"<span class='notice'>There's no cartridge connected.</span>")
	if(cigcell)
		to_chat(user,"<span class='notice'>The power meter shows that there's about [round(cigcell.percent(), 25)]% power remaining.</span>")
	else
		to_chat(user,"<span class='notice'>There's no cartridge connected.</span>")

/obj/item/clothing/mask/smokable/ecig/deluxe
	name = "deluxe electronic cigarette"
	desc = "A premium model eGavana MK3 electronic cigarette, shaped like a cigar."
	icon = 'icons/clothing/mask/smokables/cigarette_electronic_deluxe.dmi'
	cell_type = /obj/item/cell/device/high //enough for four catridges

/obj/item/clothing/mask/smokable/ecig/deluxe/examine(mob/user)
	. = ..()
	if(ec_cartridge)
		to_chat(user,"<span class='notice'>There are [round(ec_cartridge.reagents.total_volume, 1)] units of liquid remaining.</span>")
	else
		to_chat(user,"<span class='notice'>There's no cartridge connected.</span>")
	if(cigcell)
		to_chat(user,"<span class='notice'>The power meter shows that there's about [round(cigcell.percent(), 1)]% power remaining.</span>")
	else
		to_chat(user,"<span class='notice'>There's no cartridge connected.</span>")

/obj/item/clothing/mask/smokable/ecig/proc/Deactivate()
	lit = 0
	STOP_PROCESSING(SSobj, src)
	update_icon()

/obj/item/clothing/mask/smokable/ecig/Process()
	if(!cigcell)
		Deactivate()
		return
	if(!ec_cartridge)
		Deactivate()
		return

	if(idle >= idle_treshold) //idle too long -> automatic shut down
		idle = 0
		visible_message("<span class='notice'>\The [src] powers down automatically.</span>", null, 2)
		Deactivate()
		return

	idle ++

	if(ishuman(loc))
		var/mob/living/carbon/human/C = loc

		if (!lit || !ec_cartridge || !ec_cartridge.reagents.total_volume)//no cartridge
			if(!ec_cartridge.reagents.total_volume)
				to_chat(C, "<span class='notice'>There's no liquid left in \the [src], so you shut it down.</span>")
			Deactivate()
			return

		if (src == C.wear_mask && C.check_has_mouth()) //transfer, but only when not disabled
			idle = 0
			//here we'll reduce battery by usage, and check powerlevel - you only use batery while smoking
			if(!cigcell.checked_use(power_usage * CELLRATE)) //if this passes, there's not enough power in the battery
				Deactivate()
				to_chat(C,"<span class='notice'>\The [src]'s power meter flashes a low battery warning and shuts down.</span>")
				return
			ec_cartridge.reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.4) // Most of it is not inhaled... balance reasons.

/obj/item/clothing/mask/smokable/ecig/on_update_icon()
	..()
	if(lit)
		set_light(0.6, 0.5, brightness_on)
	else
		set_light(0)
	if(ec_cartridge && check_state_in_icon("[icon_state]-loaded", icon))
		add_overlay("[icon_state]-loaded")
	if(ismob(loc))
		var/mob/living/M = loc
		M.update_inv_wear_mask(0)
		M.update_inv_hands()

/obj/item/clothing/mask/smokable/ecig/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/chems/ecig_cartridge))
		if (ec_cartridge)//can't add second one
			to_chat(user, "<span class='notice'>A cartridge has already been installed.</span> ")
		else if(user.unEquip(I, src))//fits in new one
			ec_cartridge = I
			update_icon()
			to_chat(user, "<span class='notice'>You insert \the [I] into \the [src].</span> ")

	if(istype(I, /obj/item/screwdriver))
		if(cigcell) //if contains powercell
			cigcell.update_icon()
			cigcell.dropInto(loc)
			cigcell = null
			to_chat(user, "<span class='notice'>You remove \the [cigcell] from \the [src].</span>")
		else //does not contains cell
			to_chat(user, "<span class='notice'>There's no battery in \the [src].</span>")

	if(istype(I, /obj/item/cell/device))
		if(!cigcell && user.unEquip(I))
			I.forceMove(src)
			cigcell = I
			to_chat(user, "<span class='notice'>You install \the [cigcell] into \the [src].</span>")
			update_icon()
		else
			to_chat(user, "<span class='notice'>\The [src] already has a battery installed.</span>")


/obj/item/clothing/mask/smokable/ecig/attack_self(mob/user)
	if(lit)
		Deactivate()
		to_chat(user, "<span class='notice'>You turn off \the [src].</span> ")
	else
		if(cigcell)
			if (!ec_cartridge)
				to_chat(user, "<span class='notice'>You can't use \the [src] with no cartridge installed!</span> ")
				return
			else if(!ec_cartridge.reagents.total_volume)
				to_chat(user, "<span class='notice'>You can't use \the [src] with no liquid left!</span> ")
				return
			else if(!cigcell.check_charge(power_usage * CELLRATE))
				to_chat(user, "<span class='notice'>\The [src]'s power meter flashes a low battery warning and refuses to operate.</span> ")
				return
			lit = TRUE
			START_PROCESSING(SSobj, src)
			to_chat(user, "<span class='notice'>You turn on \the [src].</span> ")
			update_icon()

		else
			to_chat(user, "<span class='warning'>\The [src] does not have a battery installed.</span>")

/obj/item/clothing/mask/smokable/ecig/attack_hand(mob/user)//eject cartridge
	if(user.is_holding_offhand(src) && ec_cartridge)
		lit = FALSE
		user.put_in_hands(ec_cartridge)
		to_chat(user, SPAN_NOTICE("You remove \the [ec_cartridge] from \the [src]."))
		ec_cartridge = null
		update_icon()
	else
		..()

/obj/item/chems/ecig_cartridge
	name = "tobacco flavour cartridge"
	desc = "A small metal cartridge, used with electronic cigarettes, which contains an atomizing coil and a solution to be atomized."
	w_class = ITEM_SIZE_TINY
	icon = 'icons/obj/items/ecig.dmi'
	icon_state = "ecartridge"
	material = /decl/material/solid/metal/aluminium
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)
	volume = 20
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER

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

/obj/item/chems/ecig_cartridge/blanknico/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/ecig_cartridge/med_nicotine
	name = "tobacco flavour cartridge"
	desc =  "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored."

/obj/item/chems/ecig_cartridge/med_nicotine/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco, 5)
	reagents.add_reagent(/decl/material/liquid/water, 15)

/obj/item/chems/ecig_cartridge/high_nicotine
	name = "high nicotine tobacco flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its tobacco flavored, with extra nicotine."

/obj/item/chems/ecig_cartridge/high_nicotine/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco, 10)
	reagents.add_reagent(/decl/material/liquid/water, 10)

/obj/item/chems/ecig_cartridge/orange
	name = "orange flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its orange flavored."

/obj/item/chems/ecig_cartridge/orange/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/drink/juice/orange, 5)

/obj/item/chems/ecig_cartridge/mint
	name = "mint flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its mint flavored."

/obj/item/chems/ecig_cartridge/mint/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/menthol, 5)

/obj/item/chems/ecig_cartridge/watermelon
	name = "watermelon flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its watermelon flavored."

/obj/item/chems/ecig_cartridge/watermelon/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/drink/juice/watermelon, 5)

/obj/item/chems/ecig_cartridge/grape
	name = "grape flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its grape flavored."

/obj/item/chems/ecig_cartridge/grape/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/drink/juice/grape, 5)

/obj/item/chems/ecig_cartridge/lemonlime
	name = "lemon-lime flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its lemon-lime flavored."

/obj/item/chems/ecig_cartridge/lemonlime/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/drink/lemon_lime, 5)

/obj/item/chems/ecig_cartridge/coffee
	name = "coffee flavour cartridge"
	desc = "A small metal cartridge which contains an atomizing coil and a solution to be atomized. The label says its coffee flavored."

/obj/item/chems/ecig_cartridge/coffee/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/solid/tobacco/liquid, 5)
	reagents.add_reagent(/decl/material/liquid/water, 10)
	reagents.add_reagent(/decl/material/liquid/drink/coffee, 5)