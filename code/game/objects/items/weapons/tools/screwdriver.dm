/obj/item/screwdriver
	name = "screwdriver"
	desc = "Your archetypal flathead screwdriver, with a nice, heavy polymer handle."
	icon = 'icons/obj/items/tool/screwdriver.dmi'
	icon_state = "screwdriver_preview"
	item_state = "screwdriver"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT | SLOT_EARS
	force = 4.0
	w_class = ITEM_SIZE_TINY
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	material = MAT_STEEL
	center_of_mass = @"{'x':16,'y':7}"
	attack_verb = list("stabbed")
	lock_picking_level = 5
	sharp = TRUE
	applies_material_colour = TRUE

	var/build_from_parts = TRUE
	var/valid_colours = list(COLOR_RED, COLOR_CYAN_BLUE, COLOR_PURPLE, COLOR_CHESTNUT, COLOR_GREEN, COLOR_TEAL, COLOR_ASSEMBLY_YELLOW, COLOR_BOTTLE_GREEN, COLOR_VIOLET, COLOR_GRAY80, COLOR_GRAY20)
	var/handle_color

/obj/item/screwdriver/Initialize()
	if (prob(75))
		src.pixel_y = rand(0, 16)
	. = ..()

/obj/item/screwdriver/on_update_icon()
	..()
	if(build_from_parts)
		icon_state = "hardware"
		if(!handle_color)
			handle_color = pick(valid_colours)
		overlays += overlay_image(icon, "handle", handle_color, flags=RESET_COLOR)

/obj/item/screwdriver/attack(mob/living/carbon/M, mob/living/carbon/user)
	if(!istype(M) || user.a_intent == "help")
		return ..()
	if(user.zone_sel.selecting != BP_EYES && user.zone_sel.selecting != BP_HEAD)
		return ..()
	if((MUTATION_CLUMSY in user.mutations) && prob(50))
		M = user
	return eyestab(M,user)

/obj/item/screwdriver/gold
	material = MAT_GOLD
