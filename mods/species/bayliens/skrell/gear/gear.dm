/obj/item/tank/skrell
	name = "skrellian gas synthesizer"
	desc = "A skrellian gas processing plant that continuously synthesises oxygen."
	var/charge_cost = 12
	var/refill_gas_type = /decl/material/gas/oxygen
	var/gas_regen_amount = 0.05
	var/gas_regen_cap = 50

/obj/item/tank/skrell/Initialize()
	starting_pressure = list(refill_gas_type = 6 ATM)
	. = ..()


/obj/item/tank/skrell/Process()
	..()
	var/obj/item/rig/holder = loc
	if(air_contents.total_moles < gas_regen_cap && istype(holder) && holder.cell && holder.cell.use(charge_cost))
		air_contents.adjust_gas(refill_gas_type, gas_regen_amount)

// Self-charging power cell.
/obj/item/cell/skrell
	name = "skrellian microfusion cell"
	desc = "An impossibly tiny fusion power engine of Skrell design."
	icon = 'mods/species/bayliens/skrell/icons/gear/gear.dmi'
	icon_state = "skrellcell"
	maxcharge = 1500
	w_class = ITEM_SIZE_NORMAL
	var/recharge_amount = 12

/obj/item/cell/skrell/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/skrell/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/skrell/Process()
	if(charge < maxcharge)
		give(recharge_amount)

//Weaponry and combat-oriented gear
/obj/item/shield/energy/skrell
	name = "skrellian combat shield"
	desc = "An alien shield capable of stopping most projectile and melee attacks. It can be retracted, expanded, and stored anywhere."
	icon = 'mods/species/bayliens/skrell/icons/gear/e_shield.dmi'
	icon_state = "skrellshield"
	shield_light_color = "#bf7efc"

//All skrell weapons need testing, as they were ported directly from bay and not properly configured for nebula YET

/obj/item/gun/energy/gun/skrell
	name = "skrellian handgun"
	desc = "A common Skrellian side-arm, the Xuxquu*'Voom-5, or XV-5, is a more traditional energy weapon, tuned to dispense beams in three different wavelengths."
	w_class = ITEM_SIZE_NORMAL
	icon_state = ICON_STATE_WORLD
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	icon = 'mods/species/bayliens/skrell/icons/gear/skrell_pistol.dmi'
	max_shots = 10
	fire_delay = 6
	one_hand_penalty = 1
	self_recharge = 1
	projectile_type = /obj/item/projectile/beam/stun

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, indicator_color=COLOR_RED),
		)

/obj/item/gun/magnetic/railgun/skrell
	name = "ZT-8 Railgun"
	desc = "The Zquiv*Tzuuli-8, or ZT-8, is a railgun rarely seen by anyone other than those within Skrellian SDTF ranks. The rotary magazine houses a cylinder with individual chambers, that press against the barrel when loaded."
	icon = 'mods/species/bayliens/skrell/icons/gear/skrell_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = "skrell_rifle"
	one_hand_penalty = 3
	fire_delay = 10
	slowdown_held = 1
	slowdown_worn = 1
	removable_components = FALSE
	cell = /obj/item/cell/hyper
	capacitor = /obj/item/stock_parts/capacitor/adv
	load_type = /obj/item/magnetic_ammo/skrell
	loaded = /obj/item/magnetic_ammo/skrell
	projectile_type = /obj/item/projectile/bullet/magnetic/slug
	slot_flags = SLOT_BACK
	power_cost = 100
	firemodes = list()

/obj/item/gun/energy/pulse_rifle/skrell
	name = "VT-3 Carbine"
	icon = 'mods/species/bayliens/skrell/icons/gear/skrell_carbine.dmi'
	icon_state = ICON_STATE_WORLD
	item_state = "skrell_carbine"
	slot_flags = SLOT_BACK|SLOT_LOWER_BODY
	desc = "The Vuu'Xqu*ix T-3, known as 'VT-3' by SolGov. Rarely seen out in the wild by anyone outside of a Skrellian SDTF."
	accepts_cell_type = /obj/item/cell/high
	self_recharge = 1
	projectile_type=/obj/item/projectile/beam/pulse/skrell/single
	charge_cost=120
	one_hand_penalty = 3
	burst=1
	burst_delay=null
	accuracy = 1

	firemodes = list(
		list(mode_name="single", projectile_type=/obj/item/projectile/beam/pulse/skrell/single, charge_cost=120, burst=1, burst_delay=null),
		list(mode_name="heavy", projectile_type=/obj/item/projectile/beam/pulse/skrell/heavy, charge_cost=55, burst=2, burst_delay=3),
		list(mode_name="light", projectile_type=/obj/item/projectile/beam/pulse/skrell, charge_cost=40, burst=3, burst_delay=2)
		)

/obj/item/projectile/beam/pulse/skrell
	icon_state = "pu_laser"
	damage = 20
	muzzle_type = /obj/effect/projectile/laser/pulse/skrell/muzzle
	tracer_type = /obj/effect/projectile/laser/pulse/skrell/tracer
	impact_type = /obj/effect/projectile/laser/pulse/skrell/impact

/obj/item/projectile/beam/pulse/skrell/heavy
	damage = 30

/obj/item/projectile/beam/pulse/skrell/single
	damage = 50

/obj/effect/projectile/laser/pulse/skrell
	icon = 'icons/effects/projectiles/tracer.dmi' //God, nebula, why must you separate them in three?
	light_color = "#4c00ff"

/obj/effect/projectile/laser/pulse/skrell/tracer
	icon_state = "hcult" //Plan is to make those weapons psionically-fed, and Hcult fits that style.

/obj/effect/projectile/laser/pulse/skrell/muzzle
	icon = 'icons/effects/projectiles/muzzle.dmi'
	icon_state = "muzzle_hcult"

/obj/effect/projectile/laser/pulse/skrell/impact
	icon = 'icons/effects/projectiles/impact.dmi'
	icon_state = "impact_hcult"