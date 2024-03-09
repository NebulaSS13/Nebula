/obj/item/screwdriver
	name = "screwdriver"
	desc = "Your archetypal flathead screwdriver, with a nice, heavy polymer handle."
	icon = 'icons/obj/items/tool/screwdriver.dmi'
	icon_state = "preview"
	slot_flags = SLOT_LOWER_BODY | SLOT_EARS
	w_class = ITEM_SIZE_TINY
	material = /decl/material/solid/metal/steel
	center_of_mass = @'{"x":16,"y":7}'
	attack_verb = list("stabbed")
	lock_picking_level = 5
	sharp = TRUE
	material_alteration = MAT_FLAG_ALTERATION_COLOR
	drop_sound = 'sound/foley/singletooldrop2.ogg'

	var/static/valid_colours = list(COLOR_RED, COLOR_CYAN_BLUE, COLOR_PURPLE, COLOR_CHESTNUT, COLOR_ASSEMBLY_YELLOW, COLOR_BOTTLE_GREEN)
	var/handle_color

/obj/item/screwdriver/Initialize()
	if(prob(75))
		pixel_y = rand(0, 16)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_SCREWDRIVER = TOOL_QUALITY_DEFAULT))

/obj/item/screwdriver/on_update_icon()
	. = ..()
	if(!handle_color)
		handle_color = pick(valid_colours)
	add_overlay(mutable_appearance(icon, "[get_world_inventory_state()]_handle", handle_color))

/obj/item/screwdriver/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE, skip_offset = FALSE)
	if(overlay)
		overlay.color = handle_color
	. = ..()

/obj/item/screwdriver/get_on_belt_overlay()
	var/image/res = ..()
	if(res)
		res.color = handle_color
	return res

/obj/item/screwdriver/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M) || user.a_intent == I_HELP)
		return ..()
	if(user.get_target_zone() != BP_EYES && user.get_target_zone() != BP_HEAD)
		return ..()
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/screwdriver/gold
	material = /decl/material/solid/metal/gold
