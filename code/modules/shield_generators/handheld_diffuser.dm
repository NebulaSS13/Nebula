/obj/item/shield_diffuser
	name = "portable shield diffuser"
	desc = "A small handheld device designed to disrupt energy barriers."
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "hdiffuser_off"
	origin_tech = @'{"magnets":5,"powerstorage":5,"esoteric":2}'
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/fiberglass = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/gold = MATTER_AMOUNT_TRACE,
		/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE
	)
	var/enabled = 0

/obj/item/shield_diffuser/on_update_icon()
	. = ..()
	if(enabled)
		icon_state = "hdiffuser_on"
	else
		icon_state = "hdiffuser_off"

/obj/item/shield_diffuser/Initialize()
	set_extension(src, /datum/extension/loaded_cell/unremovable, /obj/item/cell/device, /obj/item/cell/device/standard)
	. = ..()

/obj/item/shield_diffuser/Destroy()
	if(enabled)
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/shield_diffuser/Process()
	var/obj/item/cell/cell = get_cell()
	if(!enabled || !cell)
		return

	for(var/direction in global.cardinal)
		var/turf/shielded_tile = get_step(get_turf(src), direction)
		if(shielded_tile?.simulated)
			for(var/obj/effect/shield/S in shielded_tile)
				// 10kJ per pulse, but gap in the shield lasts for longer than regular diffusers.
				if(istype(S) && !S.diffused_for && !S.disabled_for && cell.checked_use(10 KILOWATTS * CELLRATE))
					S.diffuse(20)

/obj/item/shield_diffuser/attack_self()
	enabled = !enabled
	update_icon()
	if(enabled)
		START_PROCESSING(SSobj, src)
	else
		STOP_PROCESSING(SSobj, src)
	to_chat(usr, "You turn \the [src] [enabled ? "on" : "off"].")

/obj/item/shield_diffuser/examine(mob/user)
	. = ..()
	to_chat(user, "It is [enabled ? "enabled" : "disabled"].")
