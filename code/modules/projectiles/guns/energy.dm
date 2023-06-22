var/global/list/registered_weapons = list()
var/global/list/registered_cyborg_weapons = list()

/obj/item/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/guns/basic_energy.dmi'
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"
	accuracy = 1

	var/obj/item/cell/power_supply // What type of power cell this starts with. Uses accepts_cell_type or variable cell if unset.
	var/charge_cost = 20           // How much energy is needed to fire.
	var/max_shots = 10             // Determines the capacity of the weapon's power cell. Setting power_supply or accepts_cell_type will override this value.
	var/modifystate                // Changes the icon_state used for the charge overlay.
	var/charge_meter = 1           // If set, the icon state will be chosen based on the current charge
	var/indicator_color            // Color used for overlay based charge meters
	var/self_recharge = 0          // If set, the weapon will recharge itself
	var/use_external_power = 0     // If set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4          // How many ticks between recharges.
	var/charge_tick = 0            // Current charge tick tracker.
	var/accepts_cell_type          // Specifies a cell type that can be loaded into this weapon.

	// Which projectile type to create when firing.
	var/projectile_type = /obj/item/projectile/beam/practice

/obj/item/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/gun/energy/Initialize()

	if(ispath(power_supply))
		power_supply = new power_supply(src)
	else if(accepts_cell_type)
		power_supply = new accepts_cell_type(src)
	else
		power_supply = new /obj/item/cell/device/variable(src, max_shots*charge_cost)

	. = ..()

	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	QDEL_NULL(power_supply)
	return ..()

/obj/item/gun/energy/get_cell()
	return power_supply

/obj/item/gun/energy/Process()
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

/obj/item/gun/energy/consume_next_projectile()
	if(!power_supply)
		return null
	if(!ispath(projectile_type))
		return null
	if(!power_supply.checked_use(charge_cost))
		return null
	return new projectile_type(src)

/obj/item/gun/energy/proc/get_external_power_supply()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module) || istype(loc, /obj/item/mech_equipment))
		return loc.get_cell()

/obj/item/gun/energy/proc/get_shots_remaining()
	. = round(power_supply.charge / charge_cost)

/obj/item/gun/energy/examine(mob/user)
	. = ..(user)
	if(!power_supply)
		to_chat(user, "Seems like it's dead.")
		return
	if (charge_cost == 0)
		to_chat(user, "This gun seems to have an unlimited number of shots.")
	else
		to_chat(user, "Has [get_shots_remaining()] shot\s remaining.")

/obj/item/gun/energy/proc/get_charge_ratio()
	. = 0
	if(power_supply)
		var/ratio = power_supply.percent()
		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		// Also make sure cells adminbussed with higher-than-max charge don't break sprites
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = clamp(round(ratio, 25), 25, 100)
		return ratio

/obj/item/gun/energy/on_update_icon()
	..()
	if(charge_meter)
		update_charge_meter()

/obj/item/gun/energy/adjust_mob_overlay(var/mob/living/user_mob, var/bodytype,  var/image/overlay, var/slot, var/bodypart)
	if(overlay && charge_meter)
		var/charge_state = get_charge_state(overlay.icon_state)
		if(charge_state && check_state_in_icon(charge_state, overlay.icon))
			overlay.overlays += mutable_appearance(overlay.icon, charge_state, get_charge_color())
	. = ..()

/obj/item/gun/energy/proc/get_charge_state(var/initial_state)
	return "[initial_state][get_charge_ratio()]"

/obj/item/gun/energy/proc/get_charge_color()
	return indicator_color

/obj/item/gun/energy/proc/update_charge_meter()
	if(use_single_icon)
		overlays += mutable_appearance(icon, "[get_world_inventory_state()][get_charge_ratio()]", indicator_color)
		return
	if(power_supply)
		if(modifystate)
			icon_state = "[modifystate][get_charge_ratio()]"
		else
			icon_state = "[initial(icon_state)][get_charge_ratio()]"


//For removable cells.
/obj/item/gun/energy/attack_hand(mob/user)
	if(!user.is_holding_offhand(src) || isnull(accepts_cell_type) || isnull(power_supply) || !user.check_dexterity(DEXTERITY_GRIP, TRUE))
		return ..()
	user.put_in_hands(power_supply)
	power_supply = null
	user.visible_message(SPAN_NOTICE("\The [user] unloads \the [src]."))
	playsound(src,'sound/weapons/guns/interaction/smg_magout.ogg' , 50)
	update_icon()
	return TRUE

/obj/item/gun/energy/attackby(var/obj/item/A, mob/user)

	if(istype(A, /obj/item/cell))

		if(isnull(accepts_cell_type))
			to_chat(user, SPAN_WARNING("\The [src] cannot accept a cell."))
			return TRUE

		if(!istype(A, accepts_cell_type))
			var/obj/cell_dummy = accepts_cell_type
			to_chat(user, SPAN_WARNING("\The [src]'s cell bracket can only accept \a [initial(cell_dummy.name)]."))
			return TRUE

		if(!user.is_holding_offhand(src))
			to_chat(user, SPAN_WARNING("You must hold \the [src] in your hands to load it."))
			return TRUE

		if(istype(power_supply) )
			to_chat(user, SPAN_NOTICE("\The [src] already has \a [power_supply] loaded."))
			return TRUE

		if(!do_after(user, 5, A, can_move = TRUE))
			return TRUE

		if(user.try_unequip(A, src))
			power_supply = A
			user.visible_message(SPAN_WARNING("\The [user] loads \the [A] into \the [src]!"))
			playsound(src, 'sound/weapons/guns/interaction/energy_magin.ogg', 80)
			update_icon()
		return TRUE

	return ..()
