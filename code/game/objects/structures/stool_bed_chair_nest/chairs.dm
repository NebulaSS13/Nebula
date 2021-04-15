/obj/structure/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this, either by will or force."
	icon_state = "chair"
	color = "#666666"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	obj_flags = OBJ_FLAG_ROTATABLE

	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/chair/on_update_icon()
	..()
	var/mat_color = get_primary_material_color()
	var/new_overlays
	var/image/I = image(icon, "[icon_state]_over")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = mat_color
	LAZYADD(new_overlays, I)
	I = image(icon, "[icon_state]_armrest")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = mat_color
	LAZYADD(new_overlays, I)

	var/decl/material/reinf_material = get_reinforcing_material() 
	if(reinf_material)
		mat_color = get_reinforcing_material_color()
		I =  image(icon, "[icon_state]_padding_over")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = mat_color
		LAZYADD(new_overlays, I)
		I = image(icon, "[icon_state]_padding_armrest")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = mat_color
		LAZYADD(new_overlays, I)
	overlays += new_overlays

/obj/structure/bed/chair/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	set_dir(turn(dir, 90))
	update_icon()

/obj/structure/bed/chair/set_dir()
	..()
	if(buckled_mob)
		buckled_mob.set_dir(dir)

/obj/structure/bed/chair/padded/red
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/carpet = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/brown
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/leather = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/teal
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/teal = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/black
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/green
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/green = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/purple
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/purple = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/blue
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/beige
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/beige = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/lime
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/lime = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/padded/yellow
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/yellow = MATTER_AMOUNT_SECONDARY
	)

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair"

/obj/structure/bed/chair/comfy/brown
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/leather = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/red
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/carpet = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/teal
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/teal = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/black
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/green
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/green = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/purple
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/purple = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/blue
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/beige
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/beige = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/lime
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/lime = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/comfy/yellow
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/yellow = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair"
	buckle_movable = 1
	material_composition = list(
		/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/comfy/captain/on_update_icon()
	..()
	if(buckled_mob)
		var/image/I = image(icon, "[icon_state]_special")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = get_primary_material_color()
		overlays |= I

/obj/structure/bed/chair/armchair
	name = "armchair"
	desc = "It's an armchair. It looks comfy."
	icon_state = "armchair"

/obj/structure/bed/chair/armchair/brown
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/leather = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/red
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/carpet = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/teal
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/teal = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/black
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/green
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/green = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/purple
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/purple = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/blue
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/beige
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/beige = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/lime
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/lime = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/armchair/yellow
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/yellow = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/office
	name = "office chair"
	icon_state = "officechair"
	anchored = 0
	buckle_movable = 1

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
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = 100 * victim.get_blocked_ratio(def_zone, BRUTE, damage = 10)
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/dark
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/office/comfy
	name = "comfy office chair"
	desc = "It's an office chair. It looks comfy."
	icon_state = "comfyofficechair"

/obj/structure/bed/chair/office/comfy/brown
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/leather = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/red
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/carpet = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/teal
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/teal = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/black
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/green
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/green = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/purple
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/purple = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/blue
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/beige
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/beige = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/lime
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/lime = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/office/comfy/yellow
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/yellow = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon_state = "shuttle_chair"
	buckle_sound = 'sound/effects/metal_close.ogg'
	material_composition = list(/decl/material/solid/metal/steel = MATTER_AMOUNT_PRIMARY)

/obj/structure/bed/chair/shuttle/post_buckle_mob()
	if(buckled_mob)
		icon_state = "shuttle_chair-b"
	else
		icon_state = "shuttle_chair"
	..()

/obj/structure/bed/chair/shuttle/on_update_icon()
	..()
	if(buckled_mob)
		var/image/I = image(icon, "[icon_state]_special")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = get_primary_material_color()
		overlays |= I

/obj/structure/bed/chair/shuttle/blue
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/blue = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/shuttle/black
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth/black = MATTER_AMOUNT_SECONDARY
	)
/obj/structure/bed/chair/shuttle/white
	material_composition = list(
		DEFAULT_FURNITURE_MATERIAL = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/cloth = MATTER_AMOUNT_SECONDARY
	)

/obj/structure/bed/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	color = WOOD_COLOR_GENERIC
	var/chair_material = /decl/material/solid/wood

/obj/structure/bed/chair/wood/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/wirecutters))
		return
	..()

/obj/structure/bed/chair/wood/mahogany
	color = WOOD_COLOR_RICH
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/maple
	color = WOOD_COLOR_PALE
	material_composition = list(/decl/material/solid/wood/maple = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/ebony
	color = WOOD_COLOR_BLACK
	material_composition = list(/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)

/obj/structure/bed/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings"
/obj/structure/bed/chair/wood/wings/mahogany
	color = WOOD_COLOR_RICH
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/wings/maple
	color = WOOD_COLOR_PALE
	material_composition = list(/decl/material/solid/wood/maple = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/wings/ebony
	color = WOOD_COLOR_BLACK
	material_composition = list(/decl/material/solid/wood/ebony = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/wood/wings/walnut
	color = WOOD_COLOR_CHOCOLATE
	material_composition = list(/decl/material/solid/wood/walnut = MATTER_AMOUNT_PRIMARY)

/obj/structure/bed/chair/pew
	name = "pew"
	desc = "A long, simple bench with a backboard, commonly found in places of worship, courtrooms and so on. Not known for being particularly comfortable."
	icon_state = "pew"
	color = WOOD_COLOR_GENERIC
	material_composition = list(/decl/material/solid/wood = MATTER_AMOUNT_PRIMARY)
	obj_flags = 0
/obj/structure/bed/chair/pew/left
	icon_state = "pew_left"
/obj/structure/bed/chair/pew/mahogany
	color = WOOD_COLOR_RICH
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)
/obj/structure/bed/chair/pew/left/mahogany
	color = WOOD_COLOR_RICH
	material_composition = list(/decl/material/solid/wood/mahogany = MATTER_AMOUNT_PRIMARY)