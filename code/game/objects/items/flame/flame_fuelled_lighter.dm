/obj/item/flame/fuelled/lighter
	name             = "lighter"
	desc             = "A cheap-as-free lighter."
	icon             = 'icons/obj/items/flame/lighter.dmi'
	slot_flags       = SLOT_LOWER_BODY
	attack_verb      = list("burnt", "singed")
	material         = /decl/material/solid/organic/plastic
	start_fuelled    = TRUE
	obj_flags        = OBJ_FLAG_CONDUCTIBLE
	lit_heat         = 1500
	lit_light_range  = 2
	lit_light_color  = COLOR_PALE_ORANGE
	matter           = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_REINFORCEMENT
	)

/obj/item/flame/fuelled/lighter/light(mob/user, no_message)
	if(submerged())
		to_chat(user, SPAN_WARNING("You cannot light \the [src] underwater."))
		return FALSE
	. = ..()
	if(. && user)
		light_effects(user)

/obj/item/flame/fuelled/lighter/proc/light_effects(mob/living/user)
	if(prob(95))
		user.visible_message(SPAN_NOTICE("After a few attempts, [user] manages to light the [src]."))
	else
		to_chat(user, SPAN_DANGER("You burn yourself while lighting the lighter."))
		var/hand_tag = user.get_held_slot_for_item(src)
		if(hand_tag)
			user.apply_damage(2, BURN, hand_tag)
		user.visible_message(SPAN_NOTICE("After a few attempts, \the [user] manages to light \the [src], burning their finger in the process."))
	playsound(src.loc, "light_bic", 100, 1, -4)

/obj/item/flame/fuelled/lighter/extinguish(var/mob/user, var/no_message)
	if(!no_message && user)
		no_message = TRUE
	. = ..()
	if(. && user)
		shutoff_effects(user)

/obj/item/flame/fuelled/lighter/proc/shutoff_effects(mob/user)
	user.visible_message(SPAN_NOTICE("\The [user] quietly shuts off the [src]."))

/obj/item/flame/fuelled/lighter/on_update_icon()
	. = ..()
	icon_state = get_world_inventory_state()
	if(lit)
		add_overlay(overlay_image(icon, "[icon_state]_flame", flags=RESET_COLOR))
	else
		add_overlay(overlay_image(icon, "[icon_state]_striker", flags=RESET_COLOR))

/obj/item/flame/fuelled/lighter/red
	color = COLOR_RED
	name = "red lighter"

/obj/item/flame/fuelled/lighter/yellow
	color = COLOR_YELLOW
	name = "yellow lighter"

/obj/item/flame/fuelled/lighter/cyan
	color = COLOR_CYAN
	name = "cyan lighter"

/obj/item/flame/fuelled/lighter/green
	color = COLOR_GREEN
	name = "green lighter"

/obj/item/flame/fuelled/lighter/pink
	color = COLOR_PINK
	name = "pink lighter"

/obj/item/flame/fuelled/lighter/random
	var/static/list/available_colors = list(
		COLOR_WHITE,
		COLOR_BLUE_GRAY,
		COLOR_GREEN_GRAY,
		COLOR_BOTTLE_GREEN,
		COLOR_DARK_GRAY,
		COLOR_RED_GRAY,
		COLOR_GUNMETAL,
		COLOR_RED,
		COLOR_YELLOW,
		COLOR_CYAN,
		COLOR_GREEN,
		COLOR_VIOLET,
		COLOR_NAVY_BLUE,
		COLOR_PINK
	)

/obj/item/flame/fuelled/lighter/random/Initialize(ml, material_key)
	. = ..()
	set_color(pick(available_colors))
