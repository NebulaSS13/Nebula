/obj/item/debris/salvage
	abstract_type = /obj/item/debris/salvage
	icon_state = ICON_STATE_WORLD
	material_alteration = MAT_FLAG_ALTERATION_NONE
	is_spawnable_type = TRUE

/obj/item/debris/salvage/metal
	name = "fragment"
	desc = "A large, ragged chunk of some worked material."
	icon = 'icons/obj/debris_metal.dmi'
	material_alteration = MAT_FLAG_ALTERATION_ALL
	material = /decl/material/solid/metal/steel

/obj/item/debris/salvage/metal/Initialize(ml, material_key)
	. = ..()
	icon_state = "[icon_state][rand(0, 4)]"

/obj/item/debris/salvage/metal/plasteel
	material = /decl/material/solid/metal/plasteel

/obj/item/debris/salvage/circuit
	name = "broken circuit"
	desc = "A burned-out circuitboard. Only good for the base materials now."
	icon = 'icons/obj/debris_circuit.dmi'
	material = /decl/material/solid/fiberglass
	matter = list(
		/decl/material/solid/organic/plastic = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold      = MATTER_AMOUNT_TRACE
	)

/obj/item/debris/salvage/circuit/Initialize(ml, material_key)
	. = ..()
	icon_state = "[icon_state][rand(0, 3)]"

/obj/item/debris/salvage/device
	name = "broken device"
	desc = "A destroyed device of some kind. Only good for recycling now."
	icon = 'icons/obj/debris_device.dmi'
	material = /decl/material/solid/metal/aluminium
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE
	)

/obj/item/debris/salvage/device/Initialize(ml, material_key)
	. = ..()
	icon_state = "[icon_state][rand(0, 3)]"
