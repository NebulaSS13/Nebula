/obj/item/gun/energy/particle
	name = "particle lance"
	desc = "A long, thick-bodied energy rifle of some kind, clad in a curious indigo polymer and lit from within by Cherenkov radiation. The grip is clearly not designed for human hands."
	icon = 'mods/species/ascent/icons/particle_rifle/rifle.dmi'
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_BACK
	force = 25 // Heavy as Hell.
	projectile_type = /obj/item/projectile/beam/particle
	max_shots = 18
	self_recharge = 1
	w_class = ITEM_SIZE_HUGE
	one_hand_penalty = 6
	multi_aim = 1
	burst_delay = 3
	burst = 3
	accuracy = -1
	charge_meter = 0
	has_safety = FALSE
	firemodes = list(
		list(mode_name="stun",   projectile_type = /obj/item/projectile/beam/stun),
		list(mode_name="shock",  projectile_type = /obj/item/projectile/beam/stun/shock),
		list(mode_name="lethal", projectile_type = /obj/item/projectile/beam/particle)
		)
	sprite_sheets = list(
		BODYTYPE_MANTID_LARGE = 'mods/species/ascent/icons/particle_rifle/inhands_gyne.dmi',
		BODYTYPE_SNAKE =        'mods/species/ascent/icons/particle_rifle/inhands_serpentid.dmi'
		)

/obj/item/gun/energy/particle/small
	name = "particle projector"
	desc = "A smaller variant on the Ascent particle lance, usually carried by drones and alates."
	icon = 'mods/species/ascent/icons/particle_rifle/rifle_small.dmi'
	force = 12
	max_shots = 9
	burst = 1
	one_hand_penalty = 0
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_HOLSTER
	projectile_type = /obj/item/projectile/beam/particle/small
	firemodes = list(
		list(mode_name="stun",   projectile_type = /obj/item/projectile/beam/stun),
		list(mode_name="shock",  projectile_type = /obj/item/projectile/beam/stun/shock),
		list(mode_name="lethal", projectile_type = /obj/item/projectile/beam/particle/small)
		)


/obj/item/gun/energy/particle/on_update_icon()
	. = ..()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	overlays = list(
		image(icon, "[get_world_inventory_state()]-[istype(current_mode) ? current_mode.name : "lethal"]"),
		image(icon, "[get_world_inventory_state()]-charge-[istype(power_supply) ? FLOOR(power_supply.percent()/20) : 0]")
	)

/obj/item/gun/magnetic/railgun/flechette/ascent
	name = "mantid flechette rifle"
	desc = "A viciously pronged rifle-like weapon."
	has_safety = FALSE
	one_hand_penalty = 6
	var/charge_per_shot = 10

/obj/item/gun/magnetic/railgun/flechette/ascent/get_cell()
	if(isrobot(loc) || istype(loc, /obj/item/rig_module))
		return loc.get_cell()

/obj/item/gun/magnetic/railgun/flechette/ascent/show_ammo(var/mob/user)
	var/obj/item/cell/cell = get_cell()
	to_chat(user, "<span class='notice'>There are [cell ? FLOOR(cell.charge/charge_per_shot) : 0] shot\s remaining.</span>")

/obj/item/gun/magnetic/railgun/flechette/ascent/check_ammo()
	var/obj/item/cell/cell = get_cell()
	return cell && cell.charge >= charge_per_shot

/obj/item/gun/magnetic/railgun/flechette/ascent/use_ammo()
	var/obj/item/cell/cell = get_cell()
	if(cell) cell.use(charge_per_shot)