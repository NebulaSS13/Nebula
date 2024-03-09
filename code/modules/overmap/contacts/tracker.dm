/obj/item/ship_tracker
	name = "long range tracker"
	desc = "A complex device that transmits conspicuous signals, easily locked onto by modern sensors hardware."
	icon = 'icons/obj/ship_tracker.dmi'
	icon_state = "disabled"
	w_class = ITEM_SIZE_SMALL

	origin_tech = @'{"magnets":3, "programming":2}'
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/silver = MATTER_AMOUNT_TRACE, /decl/material/solid/metal/gold = MATTER_AMOUNT_REINFORCEMENT)
	var/enabled = FALSE

/obj/item/ship_tracker/Initialize()
	. = ..()
	set_extension(src, /datum/extension/interactive/multitool/store)

/obj/item/ship_tracker/attack_self(var/mob/user)
	enabled = !enabled
	to_chat(user, SPAN_NOTICE("You [enabled ? "enable" : "disable"] \the [src]"))
	update_icon()

/obj/item/ship_tracker/on_update_icon()
	. = ..()
	icon_state = enabled ? "enabled" : "disabled"

/obj/item/ship_tracker/examine(var/mob/user)
	. = ..()
	to_chat(user, "It appears to be [enabled ? "enabled" : "disabled"]")