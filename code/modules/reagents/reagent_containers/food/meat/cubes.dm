//cubed animals!
/obj/item/food/animal_cube
	abstract_type = /obj/item/food/animal_cube
	desc = "Just add water!"
	icon = 'icons/obj/items/animal_cube.dmi'
	icon_state = ICON_STATE_WORLD
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = @'{"x":16,"y":14}'
	var/growing = FALSE
	var/spawn_type
	var/wrapper_type

/obj/item/food/animal_cube/wrapped
	desc = "Still wrapped in some paper."
	item_flags = 0
	obj_flags = 0
	wrapper_type = /obj/item/trash/cubewrapper
	abstract_type = /obj/item/food/animal_cube/wrapped

/obj/item/food/animal_cube/Initialize(ml, material_key, skip_plate)
	. = ..()
	if(!spawn_type)
		return INITIALIZE_HINT_QDEL
	if(wrapper_type)
		update_icon()

/obj/item/food/animal_cube/on_update_icon()
	. = ..()
	icon_state = initial(icon_state)
	if(wrapper_type)
		icon_state = "[icon_state]_wrapped"

/obj/item/food/animal_cube/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/solid/organic/meat, 10)

/obj/item/food/animal_cube/get_single_monetary_worth()
	. = (spawn_type ? round(atom_info_repository.get_combined_worth_for(spawn_type) * 1.25) : 5)
	if(wrapper_type)
		. += atom_info_repository.get_combined_worth_for(wrapper_type)

/obj/item/food/animal_cube/attack_self(var/mob/user)
	if(wrapper_type)
		unwrap_cube(user)
		return TRUE
	return ..()

/obj/item/food/animal_cube/proc/spawn_creature(force_loc)
	if(growing)
		return
	growing = TRUE
	visible_message(SPAN_NOTICE("\The [src] expands!"))
	var/mob/critter = new spawn_type
	critter.dropInto(force_loc || loc)
	qdel(src)

/obj/item/food/animal_cube/proc/unwrap_cube(var/mob/user)
	desc = "Just add water!"
	to_chat(user, SPAN_NOTICE("You unwrap \the [src]."))
	user.put_in_hands(new wrapper_type(get_turf(user)))
	wrapper_type = null
	update_icon()

/obj/item/food/animal_cube/can_be_poured_into(atom/source)
	return ..() && !wrapper_type

/obj/item/food/animal_cube/handle_eaten_by_mob(mob/user, mob/target)
	. = ..()
	if(. == EATEN_SUCCESS)
		target = target || user
		if(target)
			target.visible_message(SPAN_DANGER("A screeching creature bursts out of \the [target]!"))
			var/obj/item/organ/external/organ = GET_EXTERNAL_ORGAN(target, BP_CHEST)
			if(organ)
				organ.take_external_damage(50, 0, 0, "Animal escaping the ribcage")
		spawn_creature(get_turf(target))

/obj/item/food/animal_cube/on_reagent_change()
	if((. = ..()) && !QDELETED(src) && reagents?.has_reagent(/decl/material/liquid/water))
		spawn_creature()

//Spider cubes, all that's left of the cube PR
/obj/item/food/animal_cube/spider
	name = "spider cube"
	spawn_type = /obj/effect/spider/spiderling

/obj/item/food/animal_cube/wrapped/spider
	name = "spider cube"
	spawn_type = /obj/effect/spider/spiderling

/obj/item/food/animal_cube/monkey
	name = "monkey cube"
	spawn_type = /mob/living/human/monkey

/obj/item/food/animal_cube/wrapped/monkey
	name = "monkey cube"
	spawn_type = /mob/living/human/monkey
