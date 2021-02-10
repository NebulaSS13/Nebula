/obj/item/firearm_component/receiver/energy
	var/modifystate
	var/obj/item/cell/power_supply //What type of power cell this uses
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge
	var/indicator_color		// color used for overlay based charge meters
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0

/*
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1
*/

/obj/item/firearm_component/receiver/energy/plasmacutter
	max_shots = 10
	self_recharge = 1
	charge_meter = 0

/obj/item/firearm_component/receiver/energy/plasmacutter/mounted
	use_external_power = TRUE
	has_safety = FALSE
	max_shots = 4

/obj/item/firearm_component/receiver/energy/plasmacutter/mech
	has_safety = FALSE

/obj/item/firearm_component/receiver/energy/incendiary
	safety_icon = "safety"
	max_shots = 4

/obj/item/firearm_component/receiver/energy/plasma
	max_shots = 4
	combustion = 0
	indicator_color = COLOR_VIOLET

/obj/item/firearm_component/receiver/energy/confusion
	safety_icon = "safety"
	max_shots = 4
	combustion = 0

/*
/obj/item/gun/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/Initialize()
	. = ..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/gun/get_cell()
	return power_supply

/obj/item/gun/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/gun/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/gun/proc/get_external_power_supply()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module) || istype(loc, /obj/item/mech_equipment))
		return loc.get_cell()

/obj/item/gun/proc/get_shots_remaining()
	. = round(power_supply.charge / charge_cost)

/obj/item/gun/examine(mob/user)
	. = ..(user)
	if(!power_supply)
		to_chat(user, "Seems like it's dead.")
		return
	if (charge_cost == 0)
		to_chat(user, "This gun seems to have an unlimited number of shots.")
	else
		to_chat(user, "Has [get_shots_remaining()] shot\s remaining.")

/obj/item/gun/proc/get_charge_ratio()
	. = 0
	if(power_supply)
		var/ratio = power_supply.percent()
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		// Also make sure cells adminbussed with higher-than-max charge don't break sprites
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = Clamp(round(ratio, 25), 25, 100)
		return ratio

/obj/item/gun/on_update_icon()
	..()
	if(charge_meter)
		update_charge_meter()

/obj/item/gun/experimental_mob_overlay(mob/user_mob, slot, bodypart)
	var/image/I = ..()
	if(charge_meter)
		I = add_onmob_charge_meter(I)
	return I

/obj/item/gun/proc/add_onmob_charge_meter(image/I)
	I.overlays += mutable_appearance(icon, "[I.icon_state][get_charge_ratio()]", indicator_color)
	return I

/obj/item/gun/proc/update_charge_meter()
	if(use_single_icon)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()][get_charge_ratio()]", indicator_color)
		return
	if(power_supply)
		if(modifystate)
			icon_state = "[modifystate][get_charge_ratio()]"
		else
			icon_state = "[initial(icon_state)][get_charge_ratio()]"
*/

/obj/item/firearm_component/receiver/energy/chameleon
	charge_meter = 0
	max_shots = 50

/obj/item/firearm_component/receiver/energy/decloner
	max_shots = 10

/obj/item/firearm_component/receiver/energy/ionrifle
	max_shots = 8
	combustion = 0

/obj/item/firearm_component/receiver/energy/sniper
	max_shots = 4
	fire_delay = 35

/obj/item/firearm_component/receiver/energy/pulse
	indicator_color = COLOR_LUMINOL
	max_shots = 21
	one_hand_penalty=1 //a bit heavy
	bulk = 0
	burst_delay = 1
	burst_delay = 3
	burst = 3

/obj/item/firearm_component/receiver/energy/lasertag
	self_recharge = 1
	var/required_vest

/obj/item/firearm_component/receiver/energy/lasertag/blue
	required_vest = /obj/item/clothing/suit/bluetag

/obj/item/firearm_component/receiver/energy/lasertag/red
	required_vest = /obj/item/clothing/suit/redtag

/*
/obj/item/gun/long/lasertag/special_check(var/mob/living/carbon/human/M)
	if(ishuman(M))
		if(!istype(M.wear_suit, required_vest))
			to_chat(M, "<span class='warning'>You need to be wearing your laser tag vest!</span>")
			return 0
	return ..()
*/

/obj/item/firearm_component/receiver/energy/temperature
	combustion = 0
	cell_type = /obj/item/cell/high
	indicator_color = COLOR_GREEN
