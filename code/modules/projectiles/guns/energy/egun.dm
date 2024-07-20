
/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	max_shots = 10
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = @'{"combat":3,"magnets":2}'
	indicator_color = COLOR_CYAN

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, indicator_color=COLOR_RED),
		)

/obj/item/gun/energy/gun/small
	name = "small energy gun"
	desc = "A smaller model of the versatile LAEP90 Perun, the LAEP90-C packs considerable utility in a smaller package. Best used in situations where full-sized sidearms are inappropriate."
	icon = 'icons/obj/guns/small_egun.dmi'
	icon_state = ICON_STATE_WORLD
	max_shots = 5
	w_class = ITEM_SIZE_SMALL
	_base_attack_force = 2 //it's the size of a car key, what did you expect?

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/smalllaser,indicator_color=COLOR_RED),
		)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/gun/reloadable
	name = "reloadable energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."

/obj/item/gun/energy/gun/reloadable/setup_power_supply(loaded_cell_type, accepted_cell_type, power_supply_extension_type, charge_value)
	return ..(/obj/item/cell/gun, /obj/item/cell/gun, /datum/extension/loaded_cell, charge_value)
