//I just realied these things are too star trekky, are we in star trek wtf

/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "A versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"

	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/glass        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold   = MATTER_AMOUNT_REINFORCEMENT
	)

	firemodes = list(
		list(mode_name="stun",  projectile_type=/obj/item/projectile/beam/stun,       indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy, indicator_color=COLOR_YELLOW),
		list(mode_name="kill",  projectile_type=/obj/item/projectile/beam,            indicator_color=COLOR_RED)
		)

/obj/item/gun/energy/gun/secure
	name = "smartgun"
	icon = 'icons/obj/guns/energy_gun_secure.dmi'
	item_state = null
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED, ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge      = TRUE
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/gun/energy/gun/secure/mounted
	name = "robot energy gun"
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	self_recharge      = TRUE
	use_external_power = TRUE
	has_safety = FALSE

/obj/item/gun/energy/gun/secure/mounted/Initialize()
	var/mob/borg = get_recursive_loc_of_type(/mob/living/silicon/robot)
	if(!borg)
		. = INITIALIZE_HINT_QDEL
		CRASH("Invalid spawn location.")
	registered_owner = borg.name
	global.registered_cyborg_weapons += src
	. = ..()

//Small

/obj/item/gun/energy/gun/small
	name = "small energy gun"
	desc = "An energy gun which packs considerable utility in a smaller package. Best used in situations where full-sized sidearms are inappropriate."
	icon = 'icons/obj/guns/small_egun.dmi'
	w_class = ITEM_SIZE_SMALL

	force = 2 //it's the size of a car key, what did you expect?
	max_shots = 5

/obj/item/gun/energy/gun/small/secure
	name = "compact smartgun"
	icon = 'icons/obj/guns/small_egun_secure.dmi'
	item_state = null
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED, ALWAYS_AUTHORIZED, AUTHORIZED)

//Nuclear

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/adv_egun.dmi'
	w_class = ITEM_SIZE_LARGE
	slot_flags = SLOT_LOWER_BODY

	force = 8
	self_recharge = TRUE

	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/glass            = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/uranium    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT
	)

	firemodes = list(
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam),
		)

	var/fail_counter = 0

/obj/item/gun/energy/gun/nuclear/Process()
	if(fail_counter > 0)
		SSradiation.radiate(src, (fail_counter * 2))
		fail_counter--
	return ..()

/obj/item/gun/energy/gun/nuclear/emp_act(severity)
	..()
	switch(severity)
		if(1)
			fail_counter = max(fail_counter, 30)
			visible_message("\The [src]'s reactor overloads!")
		if(2)
			fail_counter = max(fail_counter, 10)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feels pleasantly warm.</span>")

/obj/item/gun/energy/gun/nuclear/on_update_icon()
	indicator_color = get_charge_color()
	. = ..()
	var/reactor_icon = fail_counter ? "danger" : "clean"
	add_overlay("[get_world_inventory_state()]_[reactor_icon]")
	var/datum/firemode/current_mode = firemodes[sel_mode]
	if(current_mode)
		add_overlay("[get_world_inventory_state()]_[current_mode.name]")
	var/charge_color = COLOR_BLACK
	switch(get_charge_ratio())
		if(25)
			charge_color = COLOR_RED
		if(50)
			charge_color = COLOR_ORANGE
		if(75)
			charge_color = COLOR_CIVIE_GREEN
		if(100)
			charge_color = COLOR_LIME
	add_overlay(mutable_appearance(icon,"[get_world_inventory_state()]_charge",charge_color))