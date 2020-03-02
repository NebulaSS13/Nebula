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

/obj/structure/bed/chair/attackby(obj/item/W, mob/user)
	..()
	if(!reinf_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
		if(!SK.status)
			to_chat(user, SPAN_NOTICE("\The [SK] is not ready to be attached!"))
			return
		if(!user.unEquip(SK))
			return
		var/obj/structure/bed/chair/e_chair/E = new (src.loc, material.type)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.set_dir(dir)
		E.part = SK
		SK.forceMove(E)
		SK.master = E
		qdel(src)

/obj/structure/bed/chair/post_buckle_mob()
	update_icon()
	return ..()

/obj/structure/bed/chair/on_update_icon()
	..()
	var/new_overlays
	var/image/I = image(icon, "[icon_state]_over")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = material.icon_colour
	LAZYADD(new_overlays, I)
	I = image(icon, "[icon_state]_armrest")
	I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
	if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
		I.appearance_flags |= RESET_COLOR
		I.color = material.icon_colour
	LAZYADD(new_overlays, I)
	if(reinf_material)
		I =  image(icon, "[icon_state]_padding_over")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_material.icon_colour
		LAZYADD(new_overlays, I)
		I = image(icon, "[icon_state]_padding_armrest")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = reinf_material.icon_colour
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
	reinf_material = MAT_CARPET
/obj/structure/bed/chair/padded/brown
	reinf_material = MAT_LEATHER_GENERIC
/obj/structure/bed/chair/padded/teal
	reinf_material = MAT_CLOTH_TEAL
/obj/structure/bed/chair/padded/black
	reinf_material = MAT_CLOTH_BLACK
/obj/structure/bed/chair/padded/green
	reinf_material = MAT_CLOTH_GREEN
/obj/structure/bed/chair/padded/purple
	reinf_material = MAT_CLOTH_PURPLE
/obj/structure/bed/chair/padded/blue
	reinf_material = MAT_CLOTH_BLUE
/obj/structure/bed/chair/padded/beige
	reinf_material = MAT_CLOTH_BEIGE
/obj/structure/bed/chair/padded/lime
	reinf_material = MAT_CLOTH_LIME
/obj/structure/bed/chair/padded/yellow
	reinf_material = MAT_CLOTH_YELLOW

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair"

/obj/structure/bed/chair/comfy/brown
	reinf_material = MAT_LEATHER_GENERIC
/obj/structure/bed/chair/comfy/red
	reinf_material = MAT_CARPET
/obj/structure/bed/chair/comfy/teal
	reinf_material = MAT_CLOTH_TEAL
/obj/structure/bed/chair/comfy/black
	reinf_material = MAT_CLOTH_BLACK
/obj/structure/bed/chair/comfy/green
	reinf_material = MAT_CLOTH_GREEN
/obj/structure/bed/chair/comfy/purple
	reinf_material = MAT_CLOTH_PURPLE
/obj/structure/bed/chair/comfy/blue
	reinf_material = MAT_CLOTH_BLUE
/obj/structure/bed/chair/comfy/beige
	reinf_material = MAT_CLOTH_BEIGE
/obj/structure/bed/chair/comfy/lime
	reinf_material = MAT_CLOTH_LIME
/obj/structure/bed/chair/comfy/yellow
	reinf_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon_state = "capchair"
	buckle_movable = 1
	material = MAT_STEEL
	reinf_material = MAT_CLOTH_BLUE

/obj/structure/bed/chair/comfy/captain/on_update_icon()
	..()
	if(buckled_mob)
		var/image/I = image(icon, "[icon_state]_special")
		I.layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER
		if(material_alteration & MAT_FLAG_ALTERATION_COLOR)
			I.appearance_flags |= RESET_COLOR
			I.color = material.icon_colour
		overlays |= I

/obj/structure/bed/chair/armchair
	name = "armchair"
	desc = "It's an armchair. It looks comfy."
	icon_state = "armchair"

/obj/structure/bed/chair/armchair/brown
	reinf_material = MAT_LEATHER_GENERIC
/obj/structure/bed/chair/armchair/red
	reinf_material = MAT_CARPET
/obj/structure/bed/chair/armchair/teal
	reinf_material = MAT_CLOTH_TEAL
/obj/structure/bed/chair/armchair/black
	reinf_material = MAT_CLOTH_BLACK
/obj/structure/bed/chair/armchair/green
	reinf_material = MAT_CLOTH_GREEN
/obj/structure/bed/chair/armchair/purple
	reinf_material = MAT_CLOTH_PURPLE
/obj/structure/bed/chair/armchair/blue
	reinf_material = MAT_CLOTH_BLUE
/obj/structure/bed/chair/armchair/beige
	reinf_material = MAT_CLOTH_BEIGE
/obj/structure/bed/chair/armchair/lime
	reinf_material = MAT_CLOTH_LIME
/obj/structure/bed/chair/armchair/yellow
	reinf_material = MAT_CLOTH_YELLOW

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
	reinf_material = MAT_CLOTH
/obj/structure/bed/chair/office/dark
	reinf_material = MAT_CLOTH_BLACK

/obj/structure/bed/chair/office/comfy
	name = "comfy office chair"
	desc = "It's an office chair. It looks comfy."
	icon_state = "comfyofficechair"

/obj/structure/bed/chair/office/comfy/brown
	reinf_material = MAT_LEATHER_GENERIC
/obj/structure/bed/chair/office/comfy/red
	reinf_material = MAT_CARPET
/obj/structure/bed/chair/office/comfy/teal
	reinf_material = MAT_CLOTH_TEAL
/obj/structure/bed/chair/office/comfy/black
	reinf_material = MAT_CLOTH_BLACK
/obj/structure/bed/chair/office/comfy/green
	reinf_material = MAT_CLOTH_GREEN
/obj/structure/bed/chair/office/comfy/purple
	reinf_material = MAT_CLOTH_PURPLE
/obj/structure/bed/chair/office/comfy/blue
	reinf_material = MAT_CLOTH_BLUE
/obj/structure/bed/chair/office/comfy/beige
	reinf_material = MAT_CLOTH_BEIGE
/obj/structure/bed/chair/office/comfy/lime
	reinf_material = MAT_CLOTH_LIME
/obj/structure/bed/chair/office/comfy/yellow
	reinf_material = MAT_CLOTH_YELLOW

/obj/structure/bed/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon_state = "shuttle_chair"
	buckling_sound = 'sound/effects/metal_close.ogg'
	material = MAT_STEEL

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
			I.color = material.icon_colour
		overlays |= I

/obj/structure/bed/chair/shuttle/blue
	reinf_material = MAT_CLOTH_BLUE
/obj/structure/bed/chair/shuttle/black
	reinf_material = MAT_CLOTH_BLACK
/obj/structure/bed/chair/shuttle/white
	reinf_material = MAT_CLOTH

/obj/structure/bed/chair/wood
	name = "classic chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	color = WOOD_COLOR_GENERIC
	var/chair_material = MAT_WOOD

/obj/structure/bed/chair/wood/attackby(obj/item/W, mob/user)
	if(istype(W,/obj/item/stack) || istype(W, /obj/item/wirecutters))
		return
	..()

/obj/structure/bed/chair/wood/mahogany
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY
/obj/structure/bed/chair/wood/maple
	color = WOOD_COLOR_PALE
	material = MAT_MAPLE
/obj/structure/bed/chair/wood/ebony
	color = WOOD_COLOR_BLACK
	material = MAT_EBONY
/obj/structure/bed/chair/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = MAT_WALNUT

/obj/structure/bed/chair/wood/wings
	name = "winged chair"
	icon_state = "wooden_chair_wings"
/obj/structure/bed/chair/wood/wings/mahogany
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY
/obj/structure/bed/chair/wood/wings/maple
	color = WOOD_COLOR_PALE
	material = MAT_MAPLE
/obj/structure/bed/chair/wood/wings/ebony
	color = WOOD_COLOR_BLACK
	material = MAT_EBONY
/obj/structure/bed/chair/wood/wings/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = MAT_WALNUT

/obj/structure/bed/chair/pew
	name = "pew"
	desc = "A long, simple bench with a backboard, commonly found in places of worship, courtrooms and so on. Not known for being particularly comfortable."
	icon_state = "pew"
	color = WOOD_COLOR_GENERIC
	material = MAT_WOOD
	obj_flags = 0
/obj/structure/bed/chair/pew/left
	icon_state = "pew_left"
/obj/structure/bed/chair/pew/mahogany
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY
/obj/structure/bed/chair/pew/left/mahogany
	color = WOOD_COLOR_RICH
	material = MAT_MAHOGANY