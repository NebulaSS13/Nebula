/obj/structure/bed/sofa
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_preview"
	base_icon = "sofa"
	color = "#666666"
	buckle_dir = FALSE
	buckle_lying = FALSE //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE
	material = /decl/material/solid/wood

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
	icon_state = base_icon
	var/image/I = image(icon, "[icon_state]_over")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = material.color
	add_overlay(I)
	I = image(icon, "[icon_state]_armrest")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = material.color
	add_overlay(I)
	if(reinf_material)
		I =  image(icon, "[icon_state]_padding_over")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_material.color
		add_overlay(I)
		I = image(icon, "[icon_state]_padding_armrest")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_material.color
		add_overlay(I)
	if(has_special_overlay && buckled_mob)
		I = image(icon, "[icon_state]_special")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = material.color
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

/obj/structure/bed/sofa/middle/red
	reinf_material = /decl/material/solid/carpet
/obj/structure/bed/sofa/middle/brown
	reinf_material = /decl/material/solid/leather
/obj/structure/bed/sofa/middle/teal
	reinf_material = /decl/material/solid/cloth/teal
/obj/structure/bed/sofa/middle/black
	reinf_material = /decl/material/solid/cloth/black
/obj/structure/bed/sofa/middle/green
	reinf_material = /decl/material/solid/cloth/green
/obj/structure/bed/sofa/middle/purple
	reinf_material = /decl/material/solid/cloth/purple
/obj/structure/bed/sofa/middle/blue
	reinf_material = /decl/material/solid/cloth/blue
/obj/structure/bed/sofa/middle/beige
	reinf_material = /decl/material/solid/cloth/beige
/obj/structure/bed/sofa/middle/lime
	reinf_material = /decl/material/solid/cloth/lime
/obj/structure/bed/sofa/middle/yellow
	reinf_material = /decl/material/solid/cloth/yellow

/obj/structure/bed/sofa/right
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_r_previewo"
	base_icon = "sofa_r"

/obj/structure/bed/sofa/right/red
	reinf_material = /decl/material/solid/carpet
/obj/structure/bed/sofa/right/brown
	reinf_material = /decl/material/solid/leather
/obj/structure/bed/sofa/right/teal
	reinf_material = /decl/material/solid/cloth/teal
/obj/structure/bed/sofa/right/black
	reinf_material = /decl/material/solid/cloth/black
/obj/structure/bed/sofa/right/green
	reinf_material = /decl/material/solid/cloth/green
/obj/structure/bed/sofa/right/purple
	reinf_material = /decl/material/solid/cloth/purple
/obj/structure/bed/sofa/right/blue
	reinf_material = /decl/material/solid/cloth/blue
/obj/structure/bed/sofa/right/beige
	reinf_material = /decl/material/solid/cloth/beige
/obj/structure/bed/sofa/right/lime
	reinf_material = /decl/material/solid/cloth/lime
/obj/structure/bed/sofa/right/yellow
	reinf_material = /decl/material/solid/cloth/yellow

/obj/structure/bed/sofa/left
	name = "sofa"
	desc = "A wide and comfy sofa - no one assistant was ate by it due production! It's made of wood and covered with colored cloth."
	icon_state = "sofa_l_preview"
	base_icon = "sofa_l"

/obj/structure/bed/sofa/left/red
	reinf_material = /decl/material/solid/carpet
/obj/structure/bed/sofa/left/brown
	reinf_material = /decl/material/solid/leather
/obj/structure/bed/sofa/left/teal
	reinf_material = /decl/material/solid/cloth/teal
/obj/structure/bed/sofa/left/black
	reinf_material = /decl/material/solid/cloth/black
/obj/structure/bed/sofa/left/green
	reinf_material = /decl/material/solid/cloth/green
/obj/structure/bed/sofa/left/purple
	reinf_material = /decl/material/solid/cloth/purple
/obj/structure/bed/sofa/left/blue
	reinf_material = /decl/material/solid/cloth/blue
/obj/structure/bed/sofa/left/beige
	reinf_material = /decl/material/solid/cloth/beige
/obj/structure/bed/sofa/left/lime
	reinf_material = /decl/material/solid/cloth/lime
/obj/structure/bed/sofa/left/yellow
	reinf_material = /decl/material/solid/cloth/yellow