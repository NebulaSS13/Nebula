/obj/item/gun/energy/taser
	name = "electrolaser"
	desc = "A small, low capacity gun used for non-lethal takedowns. It can switch between high and low intensity stun shots."
	icon = 'icons/obj/guns/taser.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	item_state = null	//so the human update icon uses the icon_state instead.
	accepts_cell_type = /obj/item/cell
	power_supply = /obj/item/cell/gun
	charge_cost = 150
	projectile_type = /obj/item/projectile/beam/stun
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy),
		)
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY
	) //things that dont kill should be cheap (less people killed?)
	origin_tech = "{'combat':1,'magnets':1}" //and easy to research too

/obj/item/gun/energy/taser/empty
	power_supply = null

/obj/item/gun/energy/taser/mounted
	name = "mounted electrolaser"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/taser/mounted/cyborg
	name = "electrolaser"
	max_shots = 6
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/taser/light
	name = "light taser"
	desc = "A small, low capacity, and short-ranged energy projector intended for personal defense with minimal risk of permanent damage or cross-fire."
	icon = 'icons/obj/guns/confuseray.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	origin_tech = "{'combat':1,'magnets':2}"
	w_class = ITEM_SIZE_SMALL
	accepts_cell_type = null
	power_supply = null
	max_shots = 4
	projectile_type = /obj/item/projectile/beam/stun/light
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_SECONDARY)
	firemodes = list()

//Ion

/obj/item/gun/energy/ionrifle
	name = "ion gun"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats."
	icon = 'icons/obj/guns/ion_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':3,'magnets':4}"
	w_class = ITEM_SIZE_HUGE
	force = 10
	charge_cost = 375
	accepts_cell_type = /obj/item/cell/fuel
	power_supply = /obj/item/cell/fuel/nuclear/
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	one_hand_penalty = 4
	charge_cost = 30
	fire_delay = 30
	projectile_type = /obj/item/projectile/ion
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/ionrifle/empty
	power_supply = null

/obj/item/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	charge_meter = 0
	icon = 'icons/obj/guns/plasmacutter.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_NORMAL
	force = 8
	origin_tech = "{'materials':4,'exoticmatter':4,'engineering':6,'combat':3}"
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 10
	self_recharge = 1
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/plasmacutter/Initialize()
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SAW = TOOL_QUALITY_BAD))

/obj/item/gun/energy/plasmacutter/get_heat()
	. = max(..(), 3800)

/obj/item/gun/energy/plasmacutter/mounted
	name = "mounted plasma cutter"
	use_external_power = 1
	max_shots = 4
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