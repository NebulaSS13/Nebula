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
