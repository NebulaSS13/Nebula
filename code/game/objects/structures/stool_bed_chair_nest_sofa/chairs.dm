//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
/obj/structure/bed/chair
	name = "chair"
	desc = "You sit in this, either by will or force."
	icon_state = "chair_preview"
	color = "#666666"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_SUPPORT_MOB
	base_icon = "chair"
	user_comfort = 0.5

	var/propelled = 0 // Check for fire-extinguisher-driven chairs
	var/has_special_overlay = FALSE

/obj/structure/bed/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/chair/on_update_icon()
	..()
	icon_state = base_icon

	var/base_color = get_color()
	var/reinf_color = padding_color || reinf_material?.color

	var/image/I = image(icon, "[base_icon]_over")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material && (material_alteration & MAT_FLAG_ALTERATION_COLOR))
		I.appearance_flags |= RESET_COLOR
		I.color = base_color
	add_overlay(I)
	I = image(icon, "[base_icon]_armrest")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material && (material_alteration & MAT_FLAG_ALTERATION_COLOR))
		I.appearance_flags |= RESET_COLOR
		I.color = base_color
	add_overlay(I)
	if(reinf_material)
		I =  image(icon, "[base_icon]_padding_over")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_color
		add_overlay(I)
		I = image(icon, "[base_icon]_padding_armrest")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_color
		add_overlay(I)
	if(has_special_overlay)
		I = image(icon, "[base_icon]_special")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material && (material_alteration & MAT_FLAG_ALTERATION_COLOR))
			I.appearance_flags |= RESET_COLOR
			I.color = base_color
		add_overlay(I)

/obj/structure/bed/chair/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	set_dir(turn(dir, 90))
	update_icon()

/obj/structure/bed/chair/padded
	reinf_material = /decl/material/solid/organic/cloth
/obj/structure/bed/chair/padded/red
	padding_color = "#9d2300"
/obj/structure/bed/chair/padded/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/chair/padded/teal
	padding_color = "#00e1ff"
/obj/structure/bed/chair/padded/black
	padding_color = "#505050"
/obj/structure/bed/chair/padded/green
	padding_color = "#b7f27d"
/obj/structure/bed/chair/padded/purple
	padding_color = "#9933ff"
/obj/structure/bed/chair/padded/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/padded/beige
	padding_color = "#ceb689"
/obj/structure/bed/chair/padded/lime
	padding_color = "#62e36c"
/obj/structure/bed/chair/padded/yellow
	padding_color = "#ffbf00"

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"
	base_icon = "comfychair"
/obj/structure/bed/chair/comfy/unpadded
	reinf_material = null
/obj/structure/bed/chair/comfy/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/chair/comfy/red
	padding_color = "#9d2300"
/obj/structure/bed/chair/comfy/teal
	padding_color = "#00e1ff"
/obj/structure/bed/chair/comfy/black
	padding_color = "#505050"
/obj/structure/bed/chair/comfy/green
	padding_color = "#b7f27d"
/obj/structure/bed/chair/comfy/purple
	padding_color = "#9933ff"
/obj/structure/bed/chair/comfy/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/comfy/beige
	padding_color = "#ceb689"
/obj/structure/bed/chair/comfy/lime
	padding_color = "#62e36c"
/obj/structure/bed/chair/comfy/yellow
	padding_color = "#ffbf00"

/obj/structure/bed/chair/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair_preview"
	base_icon = "capchair"
	buckle_movable = 1
	material = /decl/material/solid/metal/steel
	reinf_material = /decl/material/solid/organic/cloth
	padding_color = "#46698c"
	has_special_overlay = TRUE

/obj/structure/bed/chair/armchair
	name = "armchair"
	desc = "It's an armchair. It looks comfy."
	icon_state = "armchair_preview"
	base_icon = "armchair"
	reinf_material = /decl/material/solid/organic/cloth

/obj/structure/bed/chair/armchair/unpadded
	reinf_material = null
/obj/structure/bed/chair/armchair/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/chair/armchair/red
	padding_color = "#9d2300"
/obj/structure/bed/chair/armchair/teal
	padding_color = "#00e1ff"
/obj/structure/bed/chair/armchair/black
	padding_color = "#505050"
/obj/structure/bed/chair/armchair/green
	padding_color = "#b7f27d"
/obj/structure/bed/chair/armchair/purple
	padding_color = "#9933ff"
/obj/structure/bed/chair/armchair/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/armchair/beige
	padding_color = "#ceb689"
/obj/structure/bed/chair/armchair/lime
	padding_color = "#62e36c"
/obj/structure/bed/chair/armchair/yellow
	padding_color = "#ffbf00"

/obj/structure/bed/chair/office
	name = "office chair"
	icon_state = "officechair_preview"
	base_icon = "officechair"
	anchored = FALSE
	buckle_movable = 1
	movable_flags = MOVABLE_FLAG_WHEELED
	reinf_material = /decl/material/solid/organic/cloth

/obj/structure/bed/chair/office/Move()
	. = ..()
	if(buckled_mob)
		var/mob/living/occupant = buckled_mob
		if (occupant && (src.loc != occupant.loc))
			if (propelled)
				for (var/mob/O in src.loc)
					if (O != occupant)
						Bump(O)
			else
				unbuckle_mob()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!buckled_mob)	return

	if(propelled)
		var/mob/living/occupant = unbuckle_mob()

		var/def_zone = ran_zone()
		var/blocked = 100 * occupant.get_blocked_ratio(def_zone, BRUTE, damage = 10)
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked) //#TODO: geez that might be a bit overkill
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(isliving(A))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = 100 * victim.get_blocked_ratio(def_zone, BRUTE, damage = 10)
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)  //#TODO: geez that might be a bit overkill
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	padding_color = "#f0f0f0"
/obj/structure/bed/chair/office/dark
	padding_color = "#505050"

/obj/structure/bed/chair/office/comfy
	name = "comfy office chair"
	desc = "It's an office chair. It looks comfy."
	icon_state = "comfyofficechair_preview"
	base_icon = "comfyofficechair"

/obj/structure/bed/chair/office/comfy/unpadded
	reinf_material = null
/obj/structure/bed/chair/office/comfy/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/chair/office/comfy/red
	padding_color = "#9d2300"
/obj/structure/bed/chair/office/comfy/teal
	padding_color = "#00e1ff"
/obj/structure/bed/chair/office/comfy/black
	padding_color = "#505050"
/obj/structure/bed/chair/office/comfy/green
	padding_color = "#b7f27d"
/obj/structure/bed/chair/office/comfy/purple
	padding_color = "#9933ff"
/obj/structure/bed/chair/office/comfy/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/office/comfy/beige
	padding_color = "#ceb689"
/obj/structure/bed/chair/office/comfy/lime
	padding_color = "#62e36c"
/obj/structure/bed/chair/office/comfy/yellow
	padding_color = "#ffbf00"

/obj/structure/bed/chair/rounded
	name = "rounded chair"
	desc = "It's a rounded chair. It looks comfy."
	icon_state = "roundedchair_preview"
	base_icon = "roundedchair"

/obj/structure/bed/chair/rounded/brown
	reinf_material = /decl/material/solid/organic/leather
/obj/structure/bed/chair/rounded/red
	padding_color = "#9d2300"
/obj/structure/bed/chair/rounded/teal
	padding_color = "#00e1ff"
/obj/structure/bed/chair/rounded/black
	padding_color = "#505050"
/obj/structure/bed/chair/rounded/green
	padding_color = "#b7f27d"
/obj/structure/bed/chair/rounded/purple
	padding_color = "#9933ff"
/obj/structure/bed/chair/rounded/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/rounded/beige
	padding_color = "#ceb689"
/obj/structure/bed/chair/rounded/lime
	padding_color = "#62e36c"
/obj/structure/bed/chair/rounded/yellow
	padding_color = "#ffbf00"

/obj/structure/bed/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon_state = "shuttle_chair_preview"
	base_icon = "shuttle_chair"
	buckle_sound = 'sound/effects/metal_close.ogg'
	material = /decl/material/solid/metal/steel
	reinf_material = /decl/material/solid/organic/cloth
	has_special_overlay = TRUE

/obj/structure/bed/chair/shuttle/post_buckle_mob()
	if(buckled_mob)
		base_icon = "shuttle_chair-b"
	else
		base_icon = "shuttle_chair"
	..()

/obj/structure/bed/chair/shuttle/blue
	padding_color = "#46698c"
/obj/structure/bed/chair/shuttle/black
	padding_color = "#505050"
/obj/structure/bed/chair/shuttle/white
	padding_color = "#f0f0f0"

/obj/structure/bed/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair_preview"
	base_icon = "wooden_chair"
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/organic/wood

/obj/structure/bed/chair/wood/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/stack) || IS_WIRECUTTER(W))
		return
	..()

/obj/structure/bed/chair/wood/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/organic/wood/mahogany
/obj/structure/bed/chair/wood/maple
	color = WOOD_COLOR_PALE
	material = /decl/material/solid/organic/wood/maple
/obj/structure/bed/chair/wood/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/organic/wood/ebony
/obj/structure/bed/chair/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/organic/wood/walnut

/obj/structure/bed/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings_preview"
	base_icon = "wooden_chair_wings"

/obj/structure/bed/chair/wood/wings/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/organic/wood/mahogany
/obj/structure/bed/chair/wood/wings/maple
	color = WOOD_COLOR_PALE
	material = /decl/material/solid/organic/wood/maple
/obj/structure/bed/chair/wood/wings/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/organic/wood/ebony
/obj/structure/bed/chair/wood/wings/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/organic/wood/walnut
