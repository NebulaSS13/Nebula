//these things are too star trekk-ish :c

/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "A versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = ICON_STATE_WORLD
	safety_icon = "safety"
	max_shots = 10
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = "{'combat':3,'magnets':3,'materials':3,'powerstorage':3}"
	indicator_color = COLOR_CYAN
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass   = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/glass        = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold   = MATTER_AMOUNT_REINFORCEMENT
	)

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, indicator_color=COLOR_RED),
		)

/obj/item/gun/energy/gun/secure
	name = "smartgun"
	icon = 'icons/obj/guns/energy_gun_secure.dmi'
	item_state = null	//so the human update icon uses the icon_state instead.
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/gun/secure/mounted
	name = "robot energy gun"
	self_recharge = 1
	use_external_power = 1
	one_hand_penalty = 0
	has_safety = FALSE
	item_flags = ITEM_FLAG_INVALID_FOR_CHAMELEON
	is_spawnable_type = FALSE // Do not manually spawn this, it will runtime/break.

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
	icon_state = ICON_STATE_WORLD
	max_shots = 5
	w_class = ITEM_SIZE_SMALL
	force = 2 //it's the size of a car key, what did you expect?

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, indicator_color=COLOR_CYAN),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/heavy, indicator_color=COLOR_YELLOW),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/small,indicator_color=COLOR_RED),
		)

/obj/item/gun/energy/gun/small/secure
	name = "compact smartgun"
	icon = 'icons/obj/guns/small_egun_secure.dmi'
	req_access = list(list(access_brig, access_bridge))
	authorized_modes = list(ALWAYS_AUTHORIZED, AUTHORIZED)

//Nuclear

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/adv_egun.dmi'
	origin_tech = "{'combat':4,'magnets':4,'materials':4,'powerstorage':4}"
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	force = 8 //looks heavier than a pistol
	self_recharge = 1
	one_hand_penalty = 1 //bulkier than an e-gun, but not quite the size of a carbine
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver     = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold       = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/gemstone/diamond = MATTER_AMOUNT_REINFORCEMENT
	) //its a self recharge op shit

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam),
		)

	var/fail_counter = 0

//override for failcheck behaviour
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

/obj/item/gun/energy/gun/nuclear/get_charge_color()
	switch(get_charge_ratio())
		if(25)
			return COLOR_RED
		if(50)
			return COLOR_ORANGE
		if(75)
			return COLOR_CIVIE_GREEN
		if(100)
			return COLOR_LIME

/obj/item/gun/energy/gun/nuclear/on_update_icon()
	indicator_color = get_charge_color()
	. = ..()
	var/reactor_icon = fail_counter ? "danger" : "clean"
	add_overlay("[get_world_inventory_state()]_[reactor_icon]")
	var/datum/firemode/current_mode = firemodes[sel_mode]
	add_overlay("[get_world_inventory_state()]_[current_mode.name]")

/obj/item/gun/energy/gun/nuclear/get_charge_state(var/initial_state)
	return "[initial_state]_charge"
