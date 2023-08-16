//This file needs revisiting

//Fires bursts of weaker projs

/obj/item/gun/energy/pulse_pistol
	name = "pulse pistol"
	desc = "A weapon that uses advanced pulse-based beam generation technology to emit powerful laser blasts. Even smaller than the carbine."
	icon = 'icons/obj/guns/pulse_pistol.dmi'
	icon_state = ICON_STATE_WORLD
	indicator_color = COLOR_LUMINOL
	slot_flags = SLOT_LOWER_BODY|SLOT_HOLSTER
	force = 6
	projectile_type = /obj/item/projectile/beam/pulse
	max_shots = 21
	w_class = ITEM_SIZE_NORMAL
	one_hand_penalty=1 //a bit heavy
	burst_delay = 1
	burst_delay = 3
	burst = 3
	accuracy = -1
	bulk = 0

/obj/item/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon = 'icons/obj/guns/floral.dmi'
	icon_state = ICON_STATE_WORLD
	charge_cost = 10
	max_shots = 10
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = "{'materials':2,'biotech':3,'powerstorage':3}"
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
	var/decl/plantgene/gene = null

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

	var/genemask = input("Choose a gene to modify.") as null|anything in SSplants.plant_gene_datums

	if(!genemask)
		return

	gene = SSplants.plant_gene_datums[genemask]

	to_chat(usr, "<span class='info'>You set the [src]'s targeted genetic area to [genemask].</span>")

	return

/obj/item/gun/energy/floragun/consume_next_projectile()
	. = ..()
	var/obj/item/projectile/energy/floramut/gene/G = .
	if(istype(G))
		G.gene = gene

/obj/item/gun/energy/toxgun
	name = "toxin gun"
	desc = "A specialized firearm designed to fire lethal bursts of radiation and toxins."
	icon = 'icons/obj/guns/toxgun.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':5,'exoticmatter':4}"
	projectile_type = /obj/item/projectile/energy/toxin
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

/obj/item/gun/energy/incendiary_laser
	name = "dispersive blaster"
	desc = "A prototype of dispersive-type laser weapons which, instead of firing a focused beam, scan over a target rapidly with the goal of setting it ablaze."
	icon = 'icons/obj/guns/incendiary_laser.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	origin_tech = "{'combat':7,'magnets':4,'esoteric':4}"
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_TRACE
	)
//	projectile_type = /obj/item/projectile/beam/incendiary_laser
	max_shots = 4

/obj/item/gun/energy/crossbow
	name = "mini energy-crossbow"
	desc = "A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy_crossbow.dmi'
	icon_state = ICON_STATE_WORLD
	w_class = ITEM_SIZE_NORMAL
	origin_tech = "{'combat':2,'magnets':2,'esoteric':5}"
	material = /decl/material/solid/metal/steel
	slot_flags = SLOT_LOWER_BODY
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
//	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 8
	self_recharge = 1
	charge_meter = 0
	combustion = 0

/obj/item/gun/energy/crossbow/ninja
	name = "energy dart thrower"
//	projectile_type = /obj/item/projectile/energy/dart
	max_shots = 5

/obj/item/gun/energy/crossbow/ninja/mounted
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/crossbow/largecrossbow
	name = "energy crossbow"
	desc = "A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_LARGE
	force = 10
	one_hand_penalty = 1
	material = /decl/material/solid/metal/steel
//	projectile_type = /obj/item/projectile/energy/bolt/large

/*

/obj/item/gun/energy/plasmastun
	name = "plasma pulse projector"
	desc = "An energy weapon that uses a laser pulse to ionise the local atmosphere, creating a disorienting pulse of plasma and deafening shockwave as the wave expands."
	icon = 'icons/obj/guns/plasma_stun.dmi'
	icon_state = ICON_STATE_WORLD
	origin_tech = "{'combat':2,'materials':2,'powerstorage':3}"
	fire_delay = 20
	max_shots = 4
	projectile_type = /obj/item/projectile/energy/plasmastun
	combustion = 0
	indicator_color = COLOR_VIOLET

*/