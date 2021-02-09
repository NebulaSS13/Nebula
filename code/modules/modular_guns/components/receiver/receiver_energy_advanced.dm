/obj/item/firearm_component/receiver/energy/advanced
	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam),
	)
	var/fail_counter = 0

/*
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

/obj/item/gun/energy/gun/nuclear/proc/get_charge_color()
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
	var/list/new_overlays = list()

	var/reactor_icon = fail_counter ? "danger" : "clean"
	new_overlays += mutable_appearance(icon, "[get_world_inventory_state()]_[reactor_icon]")
	var/datum/firemode/current_mode = firemodes[sel_mode]
	new_overlays += mutable_appearance(icon, "[get_world_inventory_state()]_[current_mode.name]")

	overlays += new_overlays

/obj/item/gun/energy/gun/nuclear/add_onmob_charge_meter(image/I)
	I.overlays += mutable_appearance(icon, "[I.icon_state]_charge", get_charge_color())
	return I
*/