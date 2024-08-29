/obj/item/gun/energy/ionrifle
	name = "ion gun"
	desc = "The Mk60 EW Halicon is a man portable anti-armor weapon designed to disable mechanical threats. Not the best of its type."
	icon = 'icons/obj/guns/ion_rifle.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = @'{"combat":2,"magnets":4}'
	w_class = ITEM_SIZE_HUGE
	_base_attack_force = 10
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BACK
	one_hand_penalty = 4
	charge_cost = 30
	max_shots = 8
	fire_delay = 30
	projectile_type = /obj/item/projectile/ion
	combustion = 0
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/gun/energy/ionrifle/mounted
	name = "mounted ion gun"
	self_recharge = TRUE
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon = 'icons/obj/guns/decloner.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = @'{"combat":5,"materials":4,"powerstorage":3}'
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/declone
	combustion = 0
	material = /decl/material/solid/metal/gold
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon = 'icons/obj/guns/floral.dmi'
	icon_state = ICON_STATE_WORLD
	charge_cost = 10
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = @'{"materials":2,"biotech":3,"powerstorage":3}'
	self_recharge = 1
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)
	combustion = 0
	firemodes = list(
		list(mode_name="induce mutations", projectile_type=/obj/item/projectile/energy/floramut, indicator_color=COLOR_LIME),
		list(mode_name="increase yield", projectile_type=/obj/item/projectile/energy/florayield, indicator_color=COLOR_YELLOW),
		list(mode_name="induce specific mutations", projectile_type=/obj/item/projectile/energy/floramut/gene, indicator_color=COLOR_LIME),
		)
	var/decl/plant_gene/gene = null

/obj/item/gun/energy/floragun/get_charge_state(var/initial_state)
	return "[initial_state]100"

/obj/item/gun/energy/floragun/resolve_attackby(atom/A)
	if(istype(A,/obj/machinery/portable_atmospherics/hydroponics))
		return FALSE // do afterattack, i.e. fire, at pointblank at trays.
	return ..()

/obj/item/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/gun/energy/floragun/verb/select_gene()
	set name = "Select Gene"
	set category = "Object"
	set src in view(1)

	var/decl/plant_gene/new_gene = input("Choose a gene to modify.") as null|anything in decls_repository.get_decls_of_type_unassociated(/decl/plant_gene)
	if(istype(new_gene))
		gene = new_gene
		to_chat(usr, SPAN_INFO("You set the \the [src]'s targeted genetic area to [gene.name]."))

/obj/item/gun/energy/floragun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/energy/floramut/gene/G = .
	if(istype(G))
		G.gene = gene

/obj/item/gun/energy/toxgun
	name = "radpistol"
	desc = "A specialized firearm designed to fire lethal bursts of radiation."
	icon = 'icons/obj/guns/toxgun.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = @'{"combat":5,"exoticmatter":4}'
	projectile_type = /obj/item/projectile/energy/radiation
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/plasmacutter
	name = "plasma cutter"
	desc = "A mining tool capable of expelling concentrated plasma bursts. You could use it to cut limbs off of xenos! Or, you know, mine stuff."
	charge_meter = 0
	icon = 'icons/obj/guns/plasmacutter.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/plasma_cutter.ogg'
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_NORMAL
	_base_attack_force = 8
	origin_tech = @'{"materials":4,"exoticmatter":4,"engineering":6,"combat":3}'
	material = /decl/material/solid/metal/steel
	projectile_type = /obj/item/projectile/beam/plasmacutter
	max_shots = 10
	self_recharge = 1
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
	var/obj/item/cell/power_supply = get_cell()
	if(!safety() && power_supply?.checked_use(charge_cost)) //consumes a shot per use
		if(M)
			M.welding_eyecheck()//Welding tool eye check
			if(check_accidents(M, "[M] loses grip on [src] from its sudden recoil!",SKILL_CONSTRUCTION, 60, SKILL_ADEPT))
				return FALSE
		spark_at(src, amount = 5, holder = src)
		return TRUE
	handle_click_empty(M)
	return FALSE

/obj/item/gun/energy/plasmacutter/is_special_cutting_tool(var/high_power)
	return TRUE

/obj/item/gun/energy/incendiary_laser
	name = "dispersive blaster"
	desc = "The A&M 'Shayatin' was the first of a now-banned class of dispersive laser weapons which, instead of firing a focused beam, scan over a target rapidly with the goal of setting it ablaze."
	icon = 'icons/obj/guns/incendiary_laser.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	origin_tech = @'{"combat":7,"magnets":4,"esoteric":4}'
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
	projectile_type = /obj/item/projectile/beam/incendiary_laser
	max_shots = 4