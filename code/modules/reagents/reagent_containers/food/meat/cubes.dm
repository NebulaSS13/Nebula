//cubed animals!

/obj/item/chems/food/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_OPEN_CONTAINER
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = @"{'x':16,'y':14}"

	var/growing = FALSE
	var/monkey_type = /mob/living/carbon/human/monkey
	var/wrapper_type

/obj/item/chems/food/monkeycube/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/nutriment/protein, 10)

/obj/item/chems/food/monkeycube/get_single_monetary_worth()
	. = (monkey_type ? round(atom_info_repository.get_combined_worth_for(monkey_type) * 1.25) : 5)
	if(wrapper_type)
		. += atom_info_repository.get_combined_worth_for(wrapper_type)

/obj/item/chems/food/monkeycube/attack_self(var/mob/user)
	if(wrapper_type)
		Unwrap(user)

/obj/item/chems/food/monkeycube/proc/Expand()
	if(!growing)
		growing = TRUE
		src.visible_message(SPAN_NOTICE("\The [src] expands!"))
		var/mob/monkey = new monkey_type
		monkey.dropInto(src.loc)
		qdel(src)

/obj/item/chems/food/monkeycube/proc/Unwrap(var/mob/user)
	icon_state = "monkeycube"
	desc = "Just add water!"
	to_chat(user, SPAN_NOTICE("You unwrap \the [src]."))
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER
	user.put_in_hands(new wrapper_type(get_turf(user)))
	wrapper_type = null

/obj/item/chems/food/monkeycube/On_Consume(var/mob/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.visible_message("<span class='warning'>A screeching creature bursts out of [M]'s chest!</span>")
		var/obj/item/organ/external/organ = H.get_organ(BP_CHEST)
		organ.take_external_damage(50, 0, 0, "Animal escaping the ribcage")
	Expand()

/obj/item/chems/food/monkeycube/on_reagent_change()
	if(reagents.has_reagent(/decl/material/liquid/water))
		Expand()

/obj/item/chems/food/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	item_flags = 0
	obj_flags = 0
	wrapper_type = /obj/item/trash/cubewrapper

//Spider cubes, all that's left of the cube PR
/obj/item/chems/food/monkeycube/spidercube
	name = "spider cube"
	monkey_type = /obj/effect/spider/spiderling

/obj/item/chems/food/monkeycube/wrapped/spidercube
	name = "spider cube"
	monkey_type = /obj/effect/spider/spiderling