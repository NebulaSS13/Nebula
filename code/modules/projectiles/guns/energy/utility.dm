//Tasers

/obj/item/gun/energy/taser
	name = "electrolaser"
	desc = "A small, low capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	item_state = null //so the human update icon uses the icon_state instead.

	max_shots = 10

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy)
	)

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/fiberglass      = MATTER_AMOUNT_SECONDARY
	) //things that dont kill should be cheap (less people killed?)

/obj/item/gun/energy/taser/mounted
	name = "mounted electrolaser"
	self_recharge      = TRUE
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/gun/energy/taser/light
	name = "soft taser"
	desc = "A small, low capacity, and short-ranged energy projector intended for personal defense with minimal risk of permanent damage or cross-fire."
	icon = 'icons/obj/guns/confuseray.dmi'
	w_class = ITEM_SIZE_SMALL
	max_shots = 5
	projectile_type = /obj/item/projectile/beam/stun/light
	firemodes = list()

//Ion

/obj/item/gun/energy/ionrifle
	name = "ion gun"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats."
	icon = 'icons/obj/guns/ion_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK

	force = 10
	charge_cost = 350
	fire_delay = 30
	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/nuclear
	projectile_type = /obj/item/projectile/ion

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/gas/hydrogen         = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/uranium  = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/gold     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/platinum = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/ionrifle/empty
	starts_loaded = FALSE

/obj/item/gun/energy/ionrifle/emp_act(severity)
	return

//Plasmacutter

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	icon = 'icons/obj/guns/plasmacutter.dmi'
	icon_state = ICON_STATE_WORLD
	charge_meter = 0
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK

	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 10
	self_recharge = TRUE

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/fiberglass    = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/plasmacutter/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_BAD))

/obj/item/gun/energy/plasmacutter/get_heat()
	. = max(..(), 3800)

/obj/item/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/gun/energy/plasmacutter/proc/slice(var/mob/M = null)
	if(!safety() && power_supply.checked_use(charge_cost)) //consumes a shot per use
		if(M)
			M.welding_eyecheck()//Welding tool eye check
			if(check_accidents(M, "[M] loses grip on [src] from its sudden recoil!",SKILL_CONSTRUCTION, 60, SKILL_ADEPT))
				return 0
		spark_at(src, amount = 5, holder = src)
		return 1
	handle_click_empty(M)
	return 0

/obj/item/gun/energy/plasmacutter/is_special_cutting_tool(var/high_power)
	return TRUE