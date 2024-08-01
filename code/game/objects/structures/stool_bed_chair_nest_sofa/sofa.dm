/obj/structure/bed/sofa
	name = "sofa"
	desc = "A wide and comfy sofa - no assistants were harmed to produce it!"
	icon_state = "sofa_preview"
	base_icon = "sofa"
	color = "#666666"
	buckle_dir = FALSE
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_ANCHORABLE
	material = /decl/material/solid/organic/wood
	reinf_material = /decl/material/solid/organic/cloth
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC

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
	var/use_reinf_color = padding_color || ((material_alteration & MAT_FLAG_ALTERATION_COLOR) ? reinf_material?.color : null)

	var/list/overlays_to_add = list(
		"_over"    = use_base_color,
		"_armrest" = use_base_color
	)
	if(reinf_material)
		overlays_to_add["_padding_over"]    = use_reinf_color
		overlays_to_add["_padding_armrest"] = use_reinf_color
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
	reinf_material = null

/obj/structure/bed/sofa/middle/red
	padding_color = "#9d2300"
/obj/structure/bed/sofa/middle/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/middle/teal
	padding_color = "#00e1ff"
/obj/structure/bed/sofa/middle/black
	padding_color = "#505050"
/obj/structure/bed/sofa/middle/green
	padding_color = "#b7f27d"
/obj/structure/bed/sofa/middle/purple
	padding_color = "#9933ff"
/obj/structure/bed/sofa/middle/blue
	padding_color = "#46698c"
/obj/structure/bed/sofa/middle/beige
	padding_color = "#ceb689"
/obj/structure/bed/sofa/middle/lime
	padding_color = "#62e36c"
/obj/structure/bed/sofa/middle/yellow
	paint_color = "#ffbf00"

/obj/structure/bed/sofa/right
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_r_preview"
	base_icon = "sofa_r"
/obj/structure/bed/sofa/right/unpadded
	reinf_material = null
/obj/structure/bed/sofa/right/red
	padding_color = "#9d2300"
/obj/structure/bed/sofa/right/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/right/teal
	padding_color = "#00e1ff"
/obj/structure/bed/sofa/right/black
	padding_color = "#505050"
/obj/structure/bed/sofa/right/green
	padding_color = "#b7f27d"
/obj/structure/bed/sofa/right/purple
	padding_color = "#9933ff"
/obj/structure/bed/sofa/right/blue
	padding_color = "#46698c"
/obj/structure/bed/sofa/right/beige
	padding_color = "#ceb689"
/obj/structure/bed/sofa/right/lime
	padding_color = "#62e36c"
/obj/structure/bed/sofa/right/yellow
	padding_color = "#ffbf00"

/obj/structure/bed/sofa/left
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_l_preview"
	base_icon = "sofa_l"
/obj/structure/bed/sofa/left/unpadded
	reinf_material = null
/obj/structure/bed/sofa/left/red
	padding_color = "#9d2300"
/obj/structure/bed/sofa/left/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/left/teal
	padding_color = "#00e1ff"
/obj/structure/bed/sofa/left/black
	padding_color = "#505050"
/obj/structure/bed/sofa/left/green
	padding_color = "#b7f27d"
/obj/structure/bed/sofa/left/purple
	padding_color = "#9933ff"
/obj/structure/bed/sofa/left/blue
	padding_color = "#46698c"
/obj/structure/bed/sofa/left/beige
	padding_color = "#ceb689"
/obj/structure/bed/sofa/left/lime
	padding_color = "#62e36c"
/obj/structure/bed/sofa/left/yellow
	padding_color = "#ffbf00"