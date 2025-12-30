/obj/item/barrel_rim
	name                = "barrel rim"
	desc                = "A circular brace used to hold a barrel together."
	icon_state          = ICON_STATE_WORLD
	icon                = 'icons/obj/items/barrel_rim.dmi'
	material            = /decl/material/solid/metal/iron
	material_alteration = MAT_FLAG_ALTERATION_ALL

/decl/stack_recipe/rods/stick/barrel_rim
	result_type  = /obj/item/barrel_rim
	one_per_turf = FALSE
	on_floor     = FALSE
	category     = "items"

/obj/structure/reagent_dispensers/barrel
	// Skill used for coopery.
	var/work_skill = SKILL_CONSTRUCTION

// Overrides to make barrel rims useful.
/obj/structure/reagent_dispensers/barrel/crafted
	metal_material = null
/obj/structure/reagent_dispensers/barrel/cask/crafted
	metal_material = null

/obj/structure/reagent_dispensers/barrel/create_dismantled_products(turf/target)
	if(metal_material)
		new /obj/item/barrel_rim(target, metal_material)
		metal_material = null
	return ..()

// Barrels with no reinforcement break apart when things are put inside.
/obj/structure/reagent_dispensers/barrel/Entered(atom/movable/atom, atom/old_loc)
	. = ..()
	if(!metal_material)
		physically_destroyed()

/obj/structure/reagent_dispensers/barrel/on_reagent_change()
	. = ..()
	if(!metal_material && REAGENT_TOTAL_VOLUME(reagents))
		physically_destroyed()

// Adding a rim to a crafted barrel.
/obj/structure/reagent_dispensers/barrel/attackby(obj/item/used_item, mob/user)
	if(isnull(metal_material) && istype(used_item.material) && istype(used_item, /obj/item/barrel_rim))
		user.visible_message(SPAN_NOTICE("\The [user] begins securing \the [src] with \the [used_item]."))
		if(user.do_skilled(5 SECONDS, work_skill, src, check_holding = TRUE) && user.try_unequip(used_item))
			metal_material = used_item.material
			update_icon()
			user.visible_message(SPAN_NOTICE("\The [user] secures \the [src] with \the [used_item]."))
			qdel(used_item)
		return TRUE
	. = ..()
