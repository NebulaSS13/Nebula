/obj/structure/bed/sofa
	name = "sofa"
	desc = "A wide and comfy sofa - no assistants were harmed to produce it!"
	icon = 'icons/obj/structures/furniture/sofa_middle.dmi'
	color = "#666666"
	buckle_dir = FALSE
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_ANCHORABLE
	material = /decl/material/solid/organic/wood/oak
	initial_padding_material = /decl/material/solid/organic/cloth
	material_alteration = MAT_FLAG_ALTERATION_ALL

	var/has_special_overlay = FALSE

/obj/structure/bed/sofa/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/bed/sofa/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/sofa/on_update_icon()
	..()
	var/use_base_color  = get_color()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/use_padding_color = padding_extension?.get_padding_color(material_alteration & MAT_FLAG_ALTERATION_COLOR)

	var/list/overlays_to_add = list(
		"_over"    = use_base_color,
		"_armrest" = use_base_color
	)
	if(padding_extension?.get_padding_material())
		overlays_to_add["_padding_over"]    = use_padding_color
		overlays_to_add["_padding_armrest"] = use_padding_color
	if(has_special_overlay && buckled_mob)
		overlays_to_add["_special"] = use_base_color

	for(var/overlay in overlays_to_add)
		var/overlay_state = "[icon_state][overlay]"
		if(check_state_in_icon(overlay_state, icon))
			var/overlay_color = overlays_to_add[overlay]
			var/image/I
			if(isnull(overlay_color))
				I = overlay_image(icon, overlay_state)
			else
				I = overlay_image(icon, overlay_state, overlay_color, RESET_COLOR)
			I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
			add_overlay(I)

/obj/structure/bed/sofa/rotate(mob/user)
	if(!CanPhysicallyInteract(user) || anchored)
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return
	set_dir(turn(dir, 90))
	update_icon()

/obj/structure/bed/sofa/middle/rotate(mob/user)
	if(!CanPhysicallyInteract(user) || anchored)
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return
	set_dir(turn(dir, 45))
	update_icon()
/obj/structure/bed/sofa/middle/unpadded
	initial_padding_material = null

/obj/structure/bed/sofa/middle/red
	initial_padding_color = "#9d2300"
/obj/structure/bed/sofa/middle/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/middle/teal
	initial_padding_color = "#00e1ff"
/obj/structure/bed/sofa/middle/black
	initial_padding_color = "#505050"
/obj/structure/bed/sofa/middle/green
	initial_padding_color = "#b7f27d"
/obj/structure/bed/sofa/middle/purple
	initial_padding_color = "#9933ff"
/obj/structure/bed/sofa/middle/blue
	initial_padding_color = "#46698c"
/obj/structure/bed/sofa/middle/beige
	initial_padding_color = "#ceb689"
/obj/structure/bed/sofa/middle/lime
	initial_padding_color = "#62e36c"
/obj/structure/bed/sofa/middle/yellow
	paint_color = "#ffbf00"

/obj/structure/bed/sofa/right
	icon = 'icons/obj/structures/furniture/sofa_right.dmi'
/obj/structure/bed/sofa/right/unpadded
	initial_padding_material = null
/obj/structure/bed/sofa/right/red
	initial_padding_color = "#9d2300"
/obj/structure/bed/sofa/right/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/right/teal
	initial_padding_color = "#00e1ff"
/obj/structure/bed/sofa/right/black
	initial_padding_color = "#505050"
/obj/structure/bed/sofa/right/green
	initial_padding_color = "#b7f27d"
/obj/structure/bed/sofa/right/purple
	initial_padding_color = "#9933ff"
/obj/structure/bed/sofa/right/blue
	initial_padding_color = "#46698c"
/obj/structure/bed/sofa/right/beige
	initial_padding_color = "#ceb689"
/obj/structure/bed/sofa/right/lime
	initial_padding_color = "#62e36c"
/obj/structure/bed/sofa/right/yellow
	initial_padding_color = "#ffbf00"

/obj/structure/bed/sofa/left
	name = "sofa"
	icon = 'icons/obj/structures/furniture/sofa_left.dmi'
/obj/structure/bed/sofa/left/unpadded
	initial_padding_material = null
/obj/structure/bed/sofa/left/red
	initial_padding_color = "#9d2300"
/obj/structure/bed/sofa/left/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/left/teal
	initial_padding_color = "#00e1ff"
/obj/structure/bed/sofa/left/black
	initial_padding_color = "#505050"
/obj/structure/bed/sofa/left/green
	initial_padding_color = "#b7f27d"
/obj/structure/bed/sofa/left/purple
	initial_padding_color = "#9933ff"
/obj/structure/bed/sofa/left/blue
	initial_padding_color = "#46698c"
/obj/structure/bed/sofa/left/beige
	initial_padding_color = "#ceb689"
/obj/structure/bed/sofa/left/lime
	initial_padding_color = "#62e36c"
/obj/structure/bed/sofa/left/yellow
	initial_padding_color = "#ffbf00"