/obj/structure/bed/sofa
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_preview"
	base_icon = "sofa"
	color = "#666666"
	buckle_dir = FALSE
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE
	material = /decl/material/solid/organic/wood

	var/has_special_overlay = FALSE

/obj/structure/bed/sofa/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/bed/sofa/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/attackby(obj/item/W, mob/user) //made to be able to rotate the sofa
	. = ..()
	if(.)
		return
	if(!IS_WRENCH(W))
		return
	playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
	anchored = !anchored
	if(anchored)
		to_chat(user, "You disanchored \the [src].")
	else
		to_chat(user, "You anchored \the [src].")

/obj/structure/bed/sofa/on_update_icon()

	..()

	var/use_mat_color   = (material_alteration & MAT_FLAG_ALTERATION_COLOR)
	var/use_base_color  = use_mat_color ? material?.color : null
	var/use_reinf_color = use_mat_color ? reinf_material?.color : null

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
	reinf_material = /decl/material/solid/organic/carpet
/obj/structure/bed/sofa/middle/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/middle/teal
	reinf_material = /decl/material/solid/organic/cloth/teal
/obj/structure/bed/sofa/middle/black
	reinf_material = /decl/material/solid/organic/cloth/black
/obj/structure/bed/sofa/middle/green
	reinf_material = /decl/material/solid/organic/cloth/green
/obj/structure/bed/sofa/middle/purple
	reinf_material = /decl/material/solid/organic/cloth/purple
/obj/structure/bed/sofa/middle/blue
	reinf_material = /decl/material/solid/organic/cloth/blue
/obj/structure/bed/sofa/middle/beige
	reinf_material = /decl/material/solid/organic/cloth/beige
/obj/structure/bed/sofa/middle/lime
	reinf_material = /decl/material/solid/organic/cloth/lime
/obj/structure/bed/sofa/middle/yellow
	reinf_material = /decl/material/solid/organic/cloth/yellow

/obj/structure/bed/sofa/right
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_r_preview"
	base_icon = "sofa_r"

/obj/structure/bed/sofa/right/unpadded
	reinf_material = null
/obj/structure/bed/sofa/right/red
	reinf_material = /decl/material/solid/organic/carpet
/obj/structure/bed/sofa/right/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/right/teal
	reinf_material = /decl/material/solid/organic/cloth/teal
/obj/structure/bed/sofa/right/black
	reinf_material = /decl/material/solid/organic/cloth/black
/obj/structure/bed/sofa/right/green
	reinf_material = /decl/material/solid/organic/cloth/green
/obj/structure/bed/sofa/right/purple
	reinf_material = /decl/material/solid/organic/cloth/purple
/obj/structure/bed/sofa/right/blue
	reinf_material = /decl/material/solid/organic/cloth/blue
/obj/structure/bed/sofa/right/beige
	reinf_material = /decl/material/solid/organic/cloth/beige
/obj/structure/bed/sofa/right/lime
	reinf_material = /decl/material/solid/organic/cloth/lime
/obj/structure/bed/sofa/right/yellow
	reinf_material = /decl/material/solid/organic/cloth/yellow

/obj/structure/bed/sofa/left
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_l_preview"
	base_icon = "sofa_l"

/obj/structure/bed/sofa/left/unpadded
	reinf_material = null
/obj/structure/bed/sofa/left/red
	reinf_material = /decl/material/solid/organic/carpet
/obj/structure/bed/sofa/left/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/sofa/left/teal
	reinf_material = /decl/material/solid/organic/cloth/teal
/obj/structure/bed/sofa/left/black
	reinf_material = /decl/material/solid/organic/cloth/black
/obj/structure/bed/sofa/left/green
	reinf_material = /decl/material/solid/organic/cloth/green
/obj/structure/bed/sofa/left/purple
	reinf_material = /decl/material/solid/organic/cloth/purple
/obj/structure/bed/sofa/left/blue
	reinf_material = /decl/material/solid/organic/cloth/blue
/obj/structure/bed/sofa/left/beige
	reinf_material = /decl/material/solid/organic/cloth/beige
/obj/structure/bed/sofa/left/lime
	reinf_material = /decl/material/solid/organic/cloth/lime
/obj/structure/bed/sofa/left/yellow
	reinf_material = /decl/material/solid/organic/cloth/yellow