/obj/structure/chair
	name = "chair"
	desc = "You sit in this, either by will or force."
	icon = 'icons/obj/structures/furniture/chair.dmi'
	icon_state = ICON_STATE_WORLD + "_preview"
	anchored = TRUE
	can_buckle = TRUE
	buckle_lying = FALSE // force people to sit up in chairs when buckled
	buckle_sound = 'sound/effects/buckle.ogg'
	material = DEFAULT_FURNITURE_MATERIAL
	material_alteration = MAT_FLAG_ALTERATION_ALL
	tool_interaction_flags = TOOL_INTERACTION_DECONSTRUCT
	parts_amount = 2
	parts_type = /obj/item/stack/material/rods
	color = "#666666"
	obj_flags = OBJ_FLAG_ROTATABLE | OBJ_FLAG_SUPPORT_MOB
	user_comfort = 0.5
	monetary_worth_multiplier = 2.5 // Utility structures should be worth more than their matter (wheelchairs, rollers, etc).

	var/propelled = 0 // Check for fire-extinguisher-driven chairs
	var/has_special_overlay = FALSE
	/// The padding extension type for this chair. If null, no extension is created and this chair cannot be padded.
	var/padding_extension_type = /datum/extension/padding
	var/decl/material/initial_padding_material
	var/initial_padding_color

/obj/structure/chair/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	if(padding_extension_type && initial_padding_material)
		get_or_create_extension(src, padding_extension_type, initial_padding_material, initial_padding_color)

/obj/structure/chair/do_simple_ranged_interaction(var/mob/user)
	if(!buckled_mob && user)
		rotate(user)
	return TRUE

/obj/structure/chair/post_buckle_mob()
	update_icon()
	return ..()

// Allow self-buckling even without dexterity.
// Copied from beds; do we actually want this?
/obj/structure/chair/user_can_mousedrop_onto(mob/user, atom/being_dropped, incapacitation_flags, params)
	if(user == being_dropped)
		return user.Adjacent(src) && !user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_KNOCKOUT)
	return ..()

/// Returns an alternate icon based on our material.
/// Mostly used by benches.
/// TODO: Refactor to eliminate?
/obj/structure/chair/proc/get_material_icon()
	return icon

/obj/structure/chair/update_materials()
	. = ..()
	var/icon/material_icon = get_material_icon()
	if(material_icon)
		icon = material_icon

/obj/structure/chair/proc/get_base_icon()
	return ICON_STATE_WORLD

/obj/structure/chair/on_update_icon()
	..()
	icon_state = get_base_icon()
	var/base_color = get_color()
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/use_padding_color = padding_extension?.get_padding_color(material_alteration & MAT_FLAG_ALTERATION_COLOR)
	var/use_layer = buckled_mob ? ABOVE_HUMAN_LAYER : FLOAT_LAYER

	var/image/I = overlay_image(icon, "[icon_state]_over", base_color, RESET_COLOR)
	I.layer = use_layer
	add_overlay(I)
	I = overlay_image(icon, "[icon_state]_armrest", base_color, RESET_COLOR)
	I.layer = use_layer
	add_overlay(I)
	if(padding_extension?.get_padding_material())
		add_overlay(overlay_image(icon, "[icon_state]_padding", padding_extension.get_padding_color(material_alteration & MAT_FLAG_ALTERATION_COLOR), RESET_COLOR|RESET_ALPHA))
		I = overlay_image(icon, "[icon_state]_padding_over", use_padding_color, RESET_COLOR)
		I.layer = use_layer
		add_overlay(I)
		I = overlay_image(icon, "[icon_state]_padding_armrest", use_padding_color, RESET_COLOR)
		I.layer = use_layer
		add_overlay(I)
	if(has_special_overlay)
		I = overlay_image(icon, "[icon_state]_special", base_color, RESET_COLOR)
		I.layer = use_layer
		add_overlay(I)

// No name override, a cotton-padded metal chair shouldn't be a cotton chair, it should be a metal chair.

/obj/structure/chair/update_material_desc(override_desc)
	var/base_desc = override_desc || initial(desc)
	var/datum/extension/padding/padding_extension = get_extension(src, __IMPLIED_TYPE__)
	var/decl/material/padding_material = padding_extension?.get_padding_material()
	if(padding_material)
		desc = "[base_desc] It's made of [material.use_name] and padded with [padding_material.use_name]."
	else
		desc = "[base_desc] It's made of [material.use_name]."

/obj/structure/chair/rotate(mob/user)
	if(!CanPhysicallyInteract(user))
		to_chat(user, SPAN_NOTICE("You can't interact with \the [src] right now!"))
		return

	set_dir(turn(dir, 90))
	update_icon()

/obj/structure/chair/padded
	initial_padding_material = /decl/material/solid/organic/cloth
/obj/structure/chair/padded/red
	initial_padding_color = "#9d2300"
/obj/structure/chair/padded/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/chair/padded/teal
	initial_padding_color = "#00e1ff"
/obj/structure/chair/padded/black
	initial_padding_color = "#505050"
/obj/structure/chair/padded/green
	initial_padding_color = "#b7f27d"
/obj/structure/chair/padded/purple
	initial_padding_color = "#9933ff"
/obj/structure/chair/padded/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/padded/beige
	initial_padding_color = "#ceb689"
/obj/structure/chair/padded/lime
	initial_padding_color = "#62e36c"
/obj/structure/chair/padded/yellow
	initial_padding_color = "#ffbf00"

// Leaving this in for the sake of compilation.
/obj/structure/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon = 'icons/obj/structures/furniture/chair_comfy.dmi'
	initial_padding_material = /decl/material/solid/organic/cloth

/obj/structure/chair/comfy/unpadded
	initial_padding_material = null
/obj/structure/chair/comfy/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/chair/comfy/red
	initial_padding_color = "#9d2300"
/obj/structure/chair/comfy/teal
	initial_padding_color = "#00e1ff"
/obj/structure/chair/comfy/black
	initial_padding_color = "#505050"
/obj/structure/chair/comfy/green
	initial_padding_color = "#b7f27d"
/obj/structure/chair/comfy/purple
	initial_padding_color = "#9933ff"
/obj/structure/chair/comfy/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/comfy/beige
	initial_padding_color = "#ceb689"
/obj/structure/chair/comfy/lime
	initial_padding_color = "#62e36c"
/obj/structure/chair/comfy/yellow
	initial_padding_color = "#ffbf00"

/obj/structure/chair/comfy/captain
	name = "captain chair"
	desc = "It's a chair. Only for the highest ranked asses."
	icon = 'icons/obj/structures/furniture/chair_captain.dmi'
	buckle_movable = 1
	material = /decl/material/solid/metal/steel
	initial_padding_material = /decl/material/solid/organic/cloth
	initial_padding_color = "#46698c"
	has_special_overlay = TRUE

/obj/structure/chair/armchair
	name = "armchair"
	desc = "It's an armchair. It looks comfy."
	icon = 'icons/obj/structures/furniture/armchair.dmi'
	initial_padding_material = /decl/material/solid/organic/cloth

/obj/structure/chair/armchair/unpadded
	initial_padding_material = null
/obj/structure/chair/armchair/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/chair/armchair/red
	initial_padding_color = "#9d2300"
/obj/structure/chair/armchair/teal
	initial_padding_color = "#00e1ff"
/obj/structure/chair/armchair/black
	initial_padding_color = "#505050"
/obj/structure/chair/armchair/green
	initial_padding_color = "#b7f27d"
/obj/structure/chair/armchair/purple
	initial_padding_color = "#9933ff"
/obj/structure/chair/armchair/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/armchair/beige
	initial_padding_color = "#ceb689"
/obj/structure/chair/armchair/lime
	initial_padding_color = "#62e36c"
/obj/structure/chair/armchair/yellow
	initial_padding_color = "#ffbf00"

/obj/structure/chair/office
	name = "office chair"
	icon = 'icons/obj/structures/furniture/chair_office.dmi'
	anchored = FALSE
	buckle_movable = 1
	movable_flags = MOVABLE_FLAG_WHEELED
	initial_padding_material = /decl/material/solid/organic/cloth

/obj/structure/chair/office/Move()
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

/obj/structure/chair/office/Bump(atom/A)
	..()
	if(!buckled_mob)
		return

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

/obj/structure/chair/office/light
	initial_padding_color = "#f0f0f0"
/obj/structure/chair/office/dark
	initial_padding_color = "#505050"

/obj/structure/chair/office/comfy
	name = "comfy office chair"
	desc = "It's an office chair. It looks comfy."
	icon = 'icons/obj/structures/furniture/chair_comfy_office.dmi'

/obj/structure/chair/office/comfy/unpadded
	initial_padding_material = null
/obj/structure/chair/office/comfy/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/chair/office/comfy/red
	initial_padding_color = "#9d2300"
/obj/structure/chair/office/comfy/teal
	initial_padding_color = "#00e1ff"
/obj/structure/chair/office/comfy/black
	initial_padding_color = "#505050"
/obj/structure/chair/office/comfy/green
	initial_padding_color = "#b7f27d"
/obj/structure/chair/office/comfy/purple
	initial_padding_color = "#9933ff"
/obj/structure/chair/office/comfy/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/office/comfy/beige
	initial_padding_color = "#ceb689"
/obj/structure/chair/office/comfy/lime
	initial_padding_color = "#62e36c"
/obj/structure/chair/office/comfy/yellow
	initial_padding_color = "#ffbf00"

/obj/structure/chair/rounded
	name = "rounded chair"
	desc = "It's a rounded chair. It looks comfy."
	icon = 'icons/obj/structures/furniture/chair_rounded.dmi'

/obj/structure/chair/rounded/brown
	initial_padding_material = /decl/material/solid/organic/leather
/obj/structure/chair/rounded/red
	initial_padding_color = "#9d2300"
/obj/structure/chair/rounded/teal
	initial_padding_color = "#00e1ff"
/obj/structure/chair/rounded/black
	initial_padding_color = "#505050"
/obj/structure/chair/rounded/green
	initial_padding_color = "#b7f27d"
/obj/structure/chair/rounded/purple
	initial_padding_color = "#9933ff"
/obj/structure/chair/rounded/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/rounded/beige
	initial_padding_color = "#ceb689"
/obj/structure/chair/rounded/lime
	initial_padding_color = "#62e36c"
/obj/structure/chair/rounded/yellow
	initial_padding_color = "#ffbf00"

/obj/structure/chair/shuttle
	name = "shuttle seat"
	desc = "A comfortable, secure seat. It has a sturdy-looking buckling system for smoother flights."
	icon = 'icons/obj/structures/furniture/chair_shuttle.dmi'
	buckle_sound = 'sound/effects/metal_close.ogg'
	material = /decl/material/solid/metal/steel
	initial_padding_material = /decl/material/solid/organic/cloth
	has_special_overlay = TRUE

/obj/structure/chair/shuttle/get_base_icon()
	. = ..()
	if (buckled_mob)
		. += "_buckled"

/obj/structure/chair/shuttle/blue
	initial_padding_color = "#46698c"
/obj/structure/chair/shuttle/black
	initial_padding_color = "#505050"
/obj/structure/chair/shuttle/white
	initial_padding_color = "#f0f0f0"

/obj/structure/chair/wood
	name_prefix = "classic"
	desc = "Old is never too old to not be in fashion."
	icon = 'icons/obj/structures/furniture/chair_wooden.dmi'
	color = WOOD_COLOR_GENERIC
	material = /decl/material/solid/organic/wood/oak
	padding_extension_type = null // Cannot be padded.

/obj/structure/chair/wood/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/organic/wood/mahogany
/obj/structure/chair/wood/maple
	color = WOOD_COLOR_PALE
	material = /decl/material/solid/organic/wood/maple
/obj/structure/chair/wood/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/organic/wood/ebony
/obj/structure/chair/wood/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/organic/wood/walnut

/obj/structure/chair/wood/wings
	name = "winged chair"
	icon = 'icons/obj/structures/furniture/chair_wooden_wings.dmi'

/obj/structure/chair/wood/wings/mahogany
	color = WOOD_COLOR_RICH
	material = /decl/material/solid/organic/wood/mahogany
/obj/structure/chair/wood/wings/maple
	color = WOOD_COLOR_PALE
	material = /decl/material/solid/organic/wood/maple
/obj/structure/chair/wood/wings/ebony
	color = WOOD_COLOR_BLACK
	material = /decl/material/solid/organic/wood/ebony
/obj/structure/chair/wood/wings/walnut
	color = WOOD_COLOR_CHOCOLATE
	material = /decl/material/solid/organic/wood/walnut

/obj/structure/chair/backed
	name_prefix = "backed"
	desc = "A tall chair with a sturdy back. Not very comfortable."
	icon = 'icons/obj/structures/furniture/chair_backed.dmi'
	reinf_material = null
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color

/obj/structure/chair/backed/get_material_icon()
	return material?.backed_chair_icon || initial(icon)

/obj/structure/chair/slatted
	name = "seat"
	name_prefix = "slatted" // slatted wooden seat vs wooden slatted seat
	icon = 'icons/obj/structures/furniture/chair_slatted.dmi'
	reinf_material = null
	material = /decl/material/solid/organic/wood/oak
	color = /decl/material/solid/organic/wood/oak::color

/obj/structure/chair/slatted/get_material_icon()
	return material?.slatted_seat_icon || initial(icon)