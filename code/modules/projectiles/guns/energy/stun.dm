/obj/item/gun/energy/taser
	name = "electrolaser"
	desc = "The Mk30 NL is a small, low capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	item_state = null	//so the human update icon uses the icon_state instead.
	max_shots = 5
	projectile_type = /obj/item/projectile/beam/stun
	combustion = 0
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock),
		)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
	)

/obj/item/gun/energy/taser/mounted
	name = "mounted electrolaser"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/taser/mounted/cyborg
	name = "electrolaser"
	max_shots = 6
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/plasmastun
	name = "plasma pulse projector"
	desc = "The Mars Military Industries MA21 Selkie is a weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon = 'icons/obj/guns/plasma_stun.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = @'{"combat":2,"materials":2,"powerstorage":3}'
	fire_delay = 20
	max_shots = 4
	projectile_type = /obj/item/projectile/energy/plasmastun
	combustion = 0
	indicator_color = COLOR_VIOLET

/obj/item/gun/energy/confuseray
	name = "disorientator"
	desc = "The W-T Mk. 4 Disorientator is a small, low capacity, and short-ranged energy projector intended for personal defense with minimal risk of permanent damage or cross-fire."
	icon = 'icons/obj/guns/confuseray.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	origin_tech = @'{"combat":2,"materials":2,"powerstorage":2}'
	w_class = ITEM_SIZE_SMALL
	max_shots = 4
	projectile_type = /obj/item/projectile/beam/confuseray
	combustion = 0
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)