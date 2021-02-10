/obj/item/gun/long/ion
	name = "ion gun"
	desc = "The Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats. Not the best of its type."
	icon = 'icons/obj/guns/ion_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':2,'magnets':4}"
	w_class = ITEM_SIZE_HUGE
	force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	fire_delay = 30
	barrel = /obj/item/firearm_component/barrel/energy/ionrifle
	receiver = /obj/item/firearm_component/receiver/energy/ionrifle

/obj/item/gun/long/ion/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/gun/hand/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':5,'materials':4,'powerstorage':3}"
	barrel = /obj/item/firearm_component/barrel/energy/decloner
	receiver = /obj/item/firearm_component/receiver/energy/decloner
	material = /decl/material/solid/metal/gold
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/gun/hand/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon = 'icons/obj/guns/floral.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'materials':2,'biotech':3,'powerstorage':3}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)
	barrel =   /obj/item/firearm_component/barrel/energy/floral
	receiver = /obj/item/firearm_component/receiver/energy/floral

/obj/item/gun/hand/radpistol
	name = "radpistol"
	desc = "A specialized firearm designed to fire lethal bursts of radiation."
	icon = 'icons/obj/guns/toxgun.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':5,'exoticmatter':4}"
	barrel = /obj/item/firearm_component/barrel/energy/radpistol
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	) 

/obj/item/gun/hand/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	icon = 'icons/obj/guns/plasmacutter.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_NORMAL
	force = 8
	origin_tech = "{'materials':4,'exoticmatter':4,'engineering':6,'combat':3}"
	material = /decl/material/solid/metal/steel
	material = /decl/material/solid/metal/steel
	receiver = /obj/item/firearm_component/receiver/energy/plasmacutter
	barrel =   /obj/item/firearm_component/barrel/energy/plasmacutter
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/hand/plasmacutter/get_heat()
	. = max(..(), 3800)

/obj/item/gun/hand/plasmacutter/mounted
	name = "mounted plasma cutter"
	barrel =   /obj/item/firearm_component/barrel/energy/plasmacutter/mounted
	receiver = /obj/item/firearm_component/receiver/energy/plasmacutter/mounted

/obj/item/gun/hand/plasmacutter/proc/slice(var/mob/M = null)
	var/obj/item/firearm_component/receiver/energy/rec = receiver
	var/obj/item/firearm_component/barrel/energy/bar = barrel
	if(istype(rec) && istype(bar) && rec.safety() && rec.power_supply?.checked_use(bar.charge_cost)) //consumes a shot per use
		if(M)
			M.welding_eyecheck()//Welding tool eye check
			if(check_accidents(M, "[M] loses grip on [src] from its sudden recoil!",SKILL_CONSTRUCTION, 60, SKILL_ADEPT))
				return 0
		spark_at(src, amount = 5, holder = src)
		return 1
	handle_click_empty()
	return 0

/obj/item/gun/hand/plasmacutter/is_special_cutting_tool()
	return TRUE

/obj/item/gun/long/incendiary
	name = "dispersive blaster"
	desc = "The A&M 'Shayatin' was the first of a now-banned class of dispersive laser weapons which, instead of firing a focused beam, scan over a target rapidly with the goal of setting it ablaze."
	icon = 'icons/obj/guns/incendiary_laser.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':7,'magnets':4,'esoteric':4}"
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	receiver = /obj/item/firearm_component/receiver/energy/incendiary
	barrel =   /obj/item/firearm_component/barrel/energy/incendiary
