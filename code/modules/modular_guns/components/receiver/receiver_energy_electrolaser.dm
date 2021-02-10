/obj/item/firearm_component/receiver/energy/electrolaser
	max_shots = 5
	safety_icon = "safety"
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock),
	)

/obj/item/firearm_component/receiver/energy/sidearm
	indicator_color = COLOR_CYAN
	max_shots = 10
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, indicator_color=COLOR_RED)
	)

/obj/item/firearm_component/receiver/energy/sidearm/small
	max_shots = 5
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/smalllaser,indicator_color=COLOR_RED)
	)

/obj/item/firearm_component/receiver/energy/sidearm/mounted
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE
	one_hand_penalty = 0
