// Power Cells
/obj/item/cell
	name = "power cell"
	desc = "A rechargeable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = @'{"powerstorage":1}'
	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)
	var/charge			                // Current charge
	var/maxcharge = 1000 // Capacity in Wh

/obj/item/cell/Initialize()
	. = ..()
	if(isnull(charge))
		charge = maxcharge
	update_icon()

/obj/item/cell/drain_power(var/drain_check, var/surge, var/power = 0)

	if(drain_check)
		return 1

	if(charge <= 0)
		return 0

	var/cell_amt = power * CELLRATE

	return use(cell_amt) / CELLRATE

/obj/item/cell/on_update_icon()
	. = ..()
	var/overlay_state = null
	switch(percent())
		if(95 to 100)
			overlay_state = "cell-o2"
		if(25 to 95)
			overlay_state = "cell-o1"
		if(0.05 to 25)
			overlay_state = "cell-o0"
	if(overlay_state)
		add_overlay(overlay_state)

/obj/item/cell/proc/percent()		// return % charge of cell
	return maxcharge && (100.0*charge/maxcharge)

/obj/item/cell/proc/fully_charged()
	return (charge == maxcharge)

// checks if the power cell is able to provide the specified amount of charge
/obj/item/cell/proc/check_charge(var/amount)
	return (charge >= amount)

// use power from a cell, returns the amount actually used
/obj/item/cell/proc/use(var/amount)
	var/used = min(charge, amount)
	charge -= used
	update_icon()
	return used

// Checks if the specified amount can be provided. If it can, it removes the amount
// from the cell and returns 1. Otherwise does nothing and returns 0.
/obj/item/cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return 0
	use(amount)
	return 1

/obj/item/cell/proc/give(var/amount)
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	update_icon()
	return amount_used

/obj/item/cell/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	. += "The label states it's capacity is [maxcharge] Wh."
	. += "The charge meter reads [round(src.percent(), 0.1)]%."

/obj/item/cell/emp_act(severity)
	// remove this if EMPs are ever rebalanced so that they don't instantly drain borg cells
	// todo: containers (partially) shielding contents?
	if(isrobot(loc))
		var/mob/living/silicon/robot/robot = loc
		severity *= robot.cell_emp_mult

	// Lose 1/2, 1/4, 1/6 of the current charge per hit or 1/4, 1/8, 1/12 of the max charge per hit, whichever is highest
	charge -= max(charge / (2 * severity), maxcharge/(4 * severity))
	if (charge < 0)
		charge = 0
	..()


/obj/item/cell/proc/get_electrocute_damage()
	switch (charge)
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1)//Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/obj/item/cell/get_cell()
	return src //no shit Sherlock

// SUBTYPES BELOW

// Smaller variant, used by energy guns and similar small devices.
/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "device"
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 7
	maxcharge = 100
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/cell/device/variable/Initialize(ml, material_key, charge_amount)
	if(!isnull(charge_amount))
		maxcharge = charge_amount
	return ..(ml, material_key)

/obj/item/cell/device/standard
	name = "standard device power cell"
	maxcharge = 25

/obj/item/cell/device/high
	name = "advanced device power cell"
	desc = "A small power cell designed to power more energy-demanding devices."
	icon_state = "hdevice"
	maxcharge = 100
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT)
	origin_tech = @'{"powerstorage":2}'

/obj/item/cell/device/infinite
	name = "experimental device power cell"
	desc = "This special experimental power cell has both very large capacity, and ability to recharge itself with zero-point energy."
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 3000
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/device/infinite/percent()
	return 100

/obj/item/cell/device/infinite/fully_charged()
	return TRUE

/obj/item/cell/device/infinite/check_charge(var/amount)
	return (maxcharge >= amount)

/obj/item/cell/device/infinite/use(var/amount)
	return min(maxcharge, amount)

/obj/item/cell/device/infinite/checked_use(var/amount)
	return check_charge(amount)

/obj/item/cell/device/infinite/give()
	return 0

/obj/item/cell/device/infinite/get_electrocute_damage()
	charge = maxcharge
	return ..()

/obj/item/cell/crap
	name = "old power cell"
	desc = "A cheap old power cell. It's probably been in use for quite some time now."
	origin_tech = @'{"powerstorage":1}'
	maxcharge = 100
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/crap/empty
	charge = 0

/obj/item/cell/standard
	name = "standard power cell"
	desc = "A standard and relatively cheap power cell, commonly used."
	origin_tech = @'{"powerstorage":1}'
	maxcharge = 250
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/apc
	name = "APC power cell"
	desc = "A special power cell designed for heavy-duty use in area power controllers."
	origin_tech = @'{"powerstorage":1}'
	maxcharge = 500
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)


/obj/item/cell/high
	name = "advanced power cell"
	desc = "An advanced high-grade power cell, for use in important systems."
	origin_tech = @'{"powerstorage":2}'
	icon_state = "hcell"
	maxcharge = 1000
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/high/empty
	charge = 0

/obj/item/cell/exosuit
	name = "exosuit power cell"
	desc = "A special power cell designed for heavy-duty use in industrial exosuits."
	origin_tech = @'{"powerstorage":3}'
	icon_state = "hcell"
	maxcharge = 1500
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)


/obj/item/cell/super
	name = "enhanced power cell"
	desc = "A very advanced power cell with increased energy density, for use in critical applications."
	origin_tech = @'{"powerstorage":5}'
	icon_state = "scell"
	maxcharge = 2000
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/super/empty
	charge = 0

/obj/item/cell/hyper
	name = "superior power cell"
	desc = "Pinnacle of power storage technology, this very expensive power cell provides the best energy density reachable with conventional electrochemical cells."
	origin_tech = @'{"powerstorage":6}'
	icon_state = "hpcell"
	maxcharge = 3000
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/fiberglass = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/hyper/empty
	charge = 0

/obj/item/cell/infinite
	name = "experimental power cell"
	desc = "This special experimental power cell has both very large capacity, and ability to recharge itself with zero-point energy."
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 3000
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/infinite/percent()
	return 100

/obj/item/cell/infinite/fully_charged()
	return TRUE

/obj/item/cell/infinite/check_charge(var/amount)
	return (maxcharge >= amount)

/obj/item/cell/infinite/use(var/amount)
	return min(maxcharge, amount)

/obj/item/cell/infinite/checked_use(var/amount)
	return check_charge(amount)

/obj/item/cell/infinite/give()
	return 0

/obj/item/cell/infinite/get_electrocute_damage()
	charge = maxcharge
	return ..()

/obj/item/cell/potato
	name = "potato battery"
	desc = "A rechargeable starch based power cell."
	origin_tech = @'{"powerstorage":1}'
	icon = 'icons/obj/power.dmi'
	icon_state = "potato_cell"
	maxcharge = 20

//Generic battery cell for guns with rechargeable batteries.
/obj/item/cell/gun
	name = "weapon energy cell"
	desc = "A military grade high-density battery, expected to deplete after tens of thousands of complete charge cycles."
	origin_tech = @'{"combat":2,"materials":2,"powerstorage": 2}'
	icon_state = "gunbattery"
	maxcharge = 500
	w_class = ITEM_SIZE_SMALL //Perhaps unwise.

/obj/item/cell/gun/empty
	charge = 0

/obj/item/cell/gun/on_update_icon()
	. = ..()
	 //Color the battery charging overlay against the percentage of the battery capacity. However the index of gradient() is set to 1, instead of 100, so we divide it by 100. Colors were chosen by the sprite artist.
	add_overlay(overlay_image(icon, "gunbattery_charge", gradient("#fa6a0a", "#9cdb43", clamp(percent(), 0, 100) )))
