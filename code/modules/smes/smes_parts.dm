//MAGNETIC COILS - These things actually store and transmit power within the SMES. Different types have different
/obj/item/stock_parts/smes_coil
	name = "superconductive magnetic coil"
	desc = "Standard superconductive magnetic coil with average capacity and I/O rating."
	icon = 'icons/obj/items/stock_parts/stock_parts.dmi'
	icon_state = "smes_coil"
	w_class = ITEM_SIZE_LARGE							// It's LARGE (backpack size)
	origin_tech = @'{"materials":7,"powerstorage":7,"engineering":5}'
	base_type = /obj/item/stock_parts/smes_coil
	part_flags = PART_FLAG_HAND_REMOVE
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_TRACE
	)

	var/ChargeCapacity = 50 KILOWATTS
	var/IOCapacity = 250 KILOWATTS

// 20% Charge Capacity, 60% I/O Capacity. Used for substation/outpost SMESs.
/obj/item/stock_parts/smes_coil/weak
	name = "basic superconductive magnetic coil"
	desc = "Cheaper model of standard superconductive magnetic coil. It's capacity and I/O rating are considerably lower."
	icon_state = "smes_coil_weak"
	ChargeCapacity = 10 KILOWATTS
	IOCapacity = 150 KILOWATTS

// 500% Charge Capacity, 40% I/O Capacity. Holds a lot of energy, but charges slowly if not combined with other coils. Ideal for backup storage.
/obj/item/stock_parts/smes_coil/super_capacity
	name = "superconductive capacitance coil"
	desc = "Specialised version of standard superconductive magnetic coil. This one has significantly stronger containment field, allowing for significantly larger power storage. Its IO rating is much lower, however."
	icon_state = "smes_coil_capacitance"
	ChargeCapacity = 250 KILOWATTS
	IOCapacity = 100 KILOWATTS
	rating = 2

// 40% Charge Capacity, 500% I/O Capacity. Technically turns SMES into large super capacitor. Ideal for shields.
/obj/item/stock_parts/smes_coil/super_io
	name = "superconductive transmission coil"
	desc = "Specialised version of standard superconductive magnetic coil. While this one won't store almost any power, it rapidly transfers current, making it useful in systems which require large throughput."
	icon_state = "smes_coil_transmission"
	ChargeCapacity = 20 KILOWATTS
	IOCapacity = 1.25 MEGAWATTS
	rating = 2