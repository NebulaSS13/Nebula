//Power cells

/obj/item/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	w_class = ITEM_SIZE_NORMAL

	force = 5
	throwforce = 5
	throw_speed = 3
	throw_range = 5

	origin_tech = "{'powerstorage':1}"
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

	var/empmult = 1 //EMP charge loss multiplier
	var/charge = null //Current charge
	var/maxcharge = 250 //Capacity in Wh
	//GODDAMnit why does it have to be 1 kwh. 1 kwh is THE    HIGH   CAPACITY  CELL. ITS ALWAYS BEEN THIS WAY
	// WHICH MEANS THERE ARE 2 IDENTICAL CELLS . ABSOLUTELY NEGATING THE NEED FOR ADVANCED CELL. RED STRIPE HUH
	//. THIS HAS BUGGED ME FOR YEARS, like, from 2018
	//I changed it to 250 wh from 1 kwh

	//Non-rechargable cells bits
	var/list/active_mats = list() //If set, cell will be considered non-rechargable. These materials will be reduced as the cell discharges
	var/list/product_mats = list() //"waste" like depleted uranium and water. Yeah, this is petty but, well

/obj/item/cell/Initialize()
	. = ..()
	if(isnull(charge))
		charge = maxcharge
	if(active_mats.len)
		use(0) //just update mats if cell is dead
	update_icon()

/obj/item/cell/create_matter() //this is required to properly init materials for fabs and etc
	. = ..()
	for(var/mat in active_mats)
		matter[mat] = round(active_mats[mat] * get_matter_amount_modifier())

/obj/item/cell/examine(mob/user)
	. = ..()
	to_chat(user, "The label states it's capacity is [maxcharge] Wh.")
	to_chat(user, "The charge meter reads [round(src.percent(), 0.1)]%.")
	if(charge == 0 && active_mats)
		to_chat(user,SPAN_NOTICE("It's dead. Kicked the.. whatever batteries kick when they die. You can't recharge it."))

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
	add_overlay(overlay_state)

/obj/item/cell/drain_power(var/drain_check, var/surge, var/power = 0)
	if(drain_check)
		return 1
	if(charge <= 0)
		return 0
	var/cell_amt = power * CELLRATE
	return use(cell_amt) / CELLRATE

/obj/item/cell/emp_act(severity)
	//remove this once emp changes on dev are merged in //are they?..
	if(isrobot(loc))
		var/mob/living/silicon/robot/R = loc
		severity *= R.cell_emp_mult
	//Lose 1/2, 1/4, 1/6 of the current charge per hit or 1/4, 1/8, 1/12 of the max charge per hit, whichever is highest
	charge -= max(charge / (2 * severity), maxcharge/(4 * severity)) * empmult
	if(charge < 0)
		charge = 0
	..()

/obj/item/cell/proc/percent()
	return maxcharge && (100.0*charge/maxcharge)

/obj/item/cell/proc/fully_charged()
	return (charge == maxcharge)

/obj/item/cell/proc/check_charge(var/amount)
	return (charge >= amount)

/obj/item/cell/proc/checked_use(var/amount)
	if(!check_charge(amount))
		return 0
	use(amount)
	return 1

//Use power from a cell, returns the amount actually used
/obj/item/cell/proc/use(var/amount)
	var/used = min(charge, amount)
	charge -= used
	update_icon()
	. = used
	if(active_mats.len)
		for(var/mat in active_mats) //Just set mats according to current charge
			if(charge)
				matter[mat] = round(active_mats[mat] * charge/maxcharge, 5)
			else
				matter.Remove(mat)
		if(charge < maxcharge)
			for(var/mat in product_mats)
				matter[mat] = round(product_mats[mat] * 1-charge/maxcharge,5)

//Recharge a cell, returns the amount actually absorbed
/obj/item/cell/proc/give(var/amount)
	if(active_mats.len)
		if(maxcharge > 500 && prob(70) && (use(amount*2) || use(charge))) //No fireworks if it's dead or low power (for PDAs since they have tesla link)
			var/turf/T = get_turf(src)
			T.visible_message(SPAN_WARNING("\The [src] sparks violently!"))
			spark_at(T, amount=rand(1,3), cardinal_only = TRUE)
		return 0
	var/amount_used = min(maxcharge-charge,amount)
	charge += amount_used
	update_icon()
	return amount_used

/obj/item/cell/proc/get_electrocute_damage()
	switch(charge)
		if (1000000 to INFINITY)
			return min(rand(50,160),rand(50,160))
		if (200000 to 1000000-1)
			return min(rand(25,80),rand(25,80))
		if (100000 to 200000-1) //Ave powernet
			return min(rand(20,60),rand(20,60))
		if (50000 to 100000-1)
			return min(rand(15,40),rand(15,40))
		if (1000 to 50000-1)
			return min(rand(10,20),rand(10,20))
		else
			return 0

/obj/item/cell/get_cell()
	return src //no shit Sherlock

//CELL SUBTYPES

/obj/item/cell/empty
	charge = 0

//Old

/obj/item/cell/crap
	name = "old power cell"
	icon_state = "cell_crap"
	desc = "A cheap old power cell. It's probably been in use for quite some time now."
	maxcharge = 150

/obj/item/cell/crap/empty
	charge = 0

//APC cell

/obj/item/cell/apc
	name = "apc power cell"
	desc = "A power cell designed for heavy-duty use in area power controllers and other electrical systems."
	icon_state = "cell_heavy"
	maxcharge = 500
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY * 2,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT * 2,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/cell/apc/empty
	charge = 0

//Device cells

/obj/item/cell/device
	name = "device power cell"
	desc = "A small power cell designed to power handheld devices."
	icon_state = "device"
	w_class = ITEM_SIZE_SMALL
	force = 0
	throw_speed = 5
	throw_range = 7
	maxcharge = 25
	//LITERALLY THE SAME FUCKING THING, TWO IDENTICAL CELLS. WHY DOES THIS KEEPS HAPPENING. Changed to 25 wh
	//actually 25 wh is really close to real life cells, this is like a generic laptop cell, but now it's in your pocket, literally

/obj/item/cell/device/empty
	charge = 0

//Variable

/obj/item/cell/device/variable/Initialize(mapload, charge_amount)
	maxcharge = charge_amount
	return ..(mapload)

//High

/obj/item/cell/device/high
	name = "advanced device power cell"
	desc = "A small power cell designed to power more energy-demanding devices."
	icon_state = "device_high"
	origin_tech = "{'powerstorage':2}"
	maxcharge = 100
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/device/high/empty
	charge = 0

//Super

/obj/item/cell/device/super
	name = "enhanced device power cell"
	desc = "A small power cell designed to power miniature critical systems."
	icon_state = "device_super"
	origin_tech = "{'powerstorage':3}"
	maxcharge = 200 //eh, it's okay. gold and silver, remember?
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold      = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/device/super/empty
	charge = 0

//Fuel device cells (finally, nuclear AA cells!)
//don't even try to UNDERSTAND how this is even possible, it just works.

/obj/item/cell/device/fuel
	name = "fission device cell"
	desc = "A cheap miniature fission power cell."
	icon_state = "device_nuclear"
	maxcharge = 150
	empmult = 3 //no space for shielding
	active_mats = list(/decl/material/solid/metal/neptunium = MATTER_AMOUNT_PRIMARY)
	product_mats = list(/decl/material/solid/metal/fission_byproduct = MATTER_AMOUNT_PRIMARY * 0.2)
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY) //cheap!

/obj/item/cell/device/fuel/empty
	charge = 0

/obj/item/cell/device/fuel/on_update_icon() //pls remove once there's a better icon
	return

//High

/obj/item/cell/device/fuel/high
	name = "advanced fission device cell"
	desc = "A miniature fission device cell."
	icon_state = "device_nuclear_high"
	maxcharge = 250
	active_mats = list(/decl/material/solid/metal/plutonium = MATTER_AMOUNT_PRIMARY)
	product_mats = list(/decl/material/solid/metal/fission_byproduct = MATTER_AMOUNT_PRIMARY * 0.5)
	matter = list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,
				/decl/material/solid/metal/copper = MATTER_AMOUNT_SECONDARY)

/obj/item/cell/device/fuel/high/empty
	charge = 0

//High

/obj/item/cell/high
	name = "advanced power cell"
	desc = "An advanced high-grade power cell, for use in important systems."
	icon_state = "cell_high"
	origin_tech = "{'powerstorage':2}"
	maxcharge = 1000
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/high/empty
	charge = 0

//Exosuit

/obj/item/cell/exosuit
	name = "exosuit power cell"
	desc = "A power cell designed for heavy-duty use in industrial exosuits."
	icon_state = "cell_exosuit"
	origin_tech = "{'powerstorage':3}"
	maxcharge = 1500
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY * 2,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT * 2,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/cell/exosuit/empty
	charge = 0

//Super

/obj/item/cell/super
	name = "enhanced power cell"
	desc = "A very advanced power cell with increased energy density, for use in critical applications."
	icon_state = "cell_super"
	origin_tech = "{'powerstorage':5}"
	maxcharge = 2000
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/gold      = MATTER_AMOUNT_TRACE
	)

/obj/item/cell/super/empty
	charge = 0

//Hyper

/obj/item/cell/hyper
	name = "superior power cell"
	desc = "Pinnacle of power storage technology, this very expensive power cell provides the best energy density reachable with conventional electrochemical cells."
	icon_state = "cell_hyper"
	origin_tech = "{'powerstorage':6}"
	maxcharge = 3000
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_SECONDARY * 2,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT * 2,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_SECONDARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold      = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/cell/hyper/empty
	charge = 0

//Gun cell

/obj/item/cell/gun
	name = "weapon energy cell"
	desc = "A military grade high-density battery, expected to deplete after tens of thousands of complete charge cycles."
	icon_state = "gunbattery"
	w_class = ITEM_SIZE_SMALL //Perhaps unwise. //yeah, it is
	origin_tech = "{'combat':2,'materials':2,'powerstorage': 2}"
	maxcharge = 750
	matter = list(
		/decl/material/liquid/acid           = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT
	)

#if DM_VERSION < 514
/proc/gradient(var/colour_one, var/colour_two, var/percentage)
	return colour_two
#endif

/obj/item/cell/gun/on_update_icon()
	. = ..()
	 //Color the battery charging overlay against the percentage of the battery capacity. However the index of gradient() is set to 1, instead of 100, so we divide it by 100. Colors were chosen by the sprite artist.
	add_overlay(overlay_image(icon, "gunbattery_charge", gradient("#fa6a0a", "#9cdb43", clamp(percent(), 0, 100) )))

/obj/item/cell/gun/empty
	charge = 0

//Fuel cells (non-rechargable)

/obj/item/cell/fuel
	name = "hydrogen cell"
	desc = "A non-rechargable hydrogen fuel cell."
	icon_state = "cell_fuel"
	maxcharge = 1500
	origin_tech = "{'materials':1,'engineering': 1,'powerstorage': 1}"
	active_mats = list(/decl/material/gas/hydrogen = MATTER_AMOUNT_PRIMARY * 2,/decl/material/gas/oxygen = MATTER_AMOUNT_PRIMARY)
	product_mats = list(/decl/material/liquid/water = MATTER_AMOUNT_PRIMARY * 3)
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY
	)

/obj/item/cell/fuel/empty
	charge = 0

//Crap

/obj/item/cell/fuel/crap
	name = "old hydrogen cell"
	desc = "A non-rechargable hydrogen fuel cell. This one is a older, non-efficient model."
	icon_state = "cell_fuel_crap"
	maxcharge = 1000

/obj/item/cell/fuel/crap/empty
	charge = 0

//High

/obj/item/cell/fuel/high
	name = "advanced hydrogen cell"
	desc = "An efficient one-use hydrogen fuel cell. This one has a layer of EMP protection."
	icon_state = "cell_fuel_high"
	maxcharge = 2500
	empmult = 0.5
	origin_tech = "{'materials':2,'engineering': 2,'powerstorage': 2}"
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_PRIMARY
	)

/obj/item/cell/fuel/high/empty
	charge = 0

//Nuclear

/obj/item/cell/fuel/nuclear
	name = "fission cell"
	desc = "A non-rechargable nuclear fission power cell.\nA warning label on the side reads: <span class='warning'>IONIZIING RADIATION</span>"
	icon_state = "cell_nuclear"
	maxcharge = 3500
	origin_tech = "{'materials':3,'engineering': 3,'powerstorage': 3}"
	active_mats = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_PRIMARY)
	product_mats = list(/decl/material/solid/metal/depleted_uranium = MATTER_AMOUNT_PRIMARY * 0.6,
					/decl/material/solid/metal/fission_byproduct = MATTER_AMOUNT_PRIMARY * 0.4)
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_PRIMARY)

/obj/item/cell/fuel/nuclear/use(var/amount)
	. = ..()
	if(. < 500) return . //No party
	if(prob(round(. / 10)))
		SSradiation.radiate(src, . / 20)
		audible_message(SPAN_DANGER("\The [src] hums faintly."))

/obj/item/cell/fuel/nuclear/empty
	charge = 0

//Crap

/obj/item/cell/fuel/nuclear/crap
	name = "old fission cell"
	desc = "A non-rechargable nuclear fission power cell. This one looks old.\nA warning label on the side reads: <span class='warning'>IONIZIING RADIATION</span>"
	icon_state = "cell_nuclear_crap"
	maxcharge = 3000

/obj/item/cell/fuel/nuclear/crap/empty
	charge = 0

//High

/obj/item/cell/fuel/nuclear/high
	name = "advanced fission cell"
	desc = "A powerful one-use nuclear fission power cell.\nA warning label on the side reads: <span class='warning'>IONIZIING RADIATION</span>"
	icon_state = "cell_nuclear_high"
	maxcharge = 4500
	empmult = 0.4
	origin_tech = "{'materials':4,'engineering': 4,'powerstorage': 4}"
	active_mats = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_PRIMARY * 2)
	product_mats = list(/decl/material/solid/metal/depleted_uranium = MATTER_AMOUNT_PRIMARY * 0.6 * 2,
					/decl/material/solid/metal/fission_byproduct = MATTER_AMOUNT_PRIMARY * 0.4 * 2)
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/lead      = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_PRIMARY)

/obj/item/cell/fuel/nuclear/high/empty
	charge = 0

//Fusion

/obj/item/cell/fuel/fusion
	name = "microfusion cell"
	desc = "A self-contained fusion cell. Alkaline batteries walked so this could run."
	icon_state = "cell_fusion"
	maxcharge = 5500
	empmult = 0.3
	origin_tech = "{'materials':6,'engineering': 6,'powerstorage': 6}"
	active_mats = list(/decl/material/gas/hydrogen  = MATTER_AMOUNT_SECONDARY,
					/decl/material/gas/hydrogen/deuterium = MATTER_AMOUNT_SECONDARY) //doesn't have to be realistic, we'll have a realistic one when we have fusion chemistry
				//but this one is probably is cuz h2+h2>helium; deut+deut=energy, deut+helium=energy, all products are consumed
	product_mats = list()
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/titanium  = MATTER_AMOUNT_PRIMARY)

/obj/item/cell/fuel/fusion/empty
	charge = 0

//High

/obj/item/cell/fuel/fusion/high
	name = "advanced microfusion cell"
	desc = "An advanced self-contained fusion cell."
	icon_state = "cell_fusion_high"
	maxcharge = 6500
	empmult = 0.2
	origin_tech = "{'materials':7,'engineering': 7,'powerstorage': 7}"
	active_mats = list(/decl/material/gas/hydrogen  = MATTER_AMOUNT_PRIMARY,
					/decl/material/gas/hydrogen/deuterium = MATTER_AMOUNT_PRIMARY)
	matter = list(
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/titanium  = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/silver    = MATTER_AMOUNT_PRIMARY)

/obj/item/cell/fuel/fusion/high/empty
	charge = 0

//Shitspawn

/obj/item/cell/infinite
	name = "experimental power cell"
	desc = "This special experimental power cell has both very large capacity, and ability to recharge itself with zero-point energy."
	icon_state = "cell_inf"
	maxcharge = 3000
	origin_tech =  null
	material = null
	matter = list()

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
	desc = "A rechargable starch based power cell."
	icon_state = "potato_cell"
	maxcharge = 20
	material = null
	matter = list()