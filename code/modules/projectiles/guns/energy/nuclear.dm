/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/adv_egun.dmi'
	origin_tech = @'{"combat":3,"materials":5,"powerstorage":3}'
	slot_flags = SLOT_LOWER_BODY
	w_class = ITEM_SIZE_LARGE
	_base_attack_force = 8 //looks heavier than a pistol
	self_recharge = 1
	one_hand_penalty = 1 //bulkier than an e-gun, but not quite the size of a carbine
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/uranium = MATTER_AMOUNT_TRACE
	)

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
