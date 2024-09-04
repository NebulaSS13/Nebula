/obj/structure/working/butter_churn
	name         = "butter churn"
	desc         = "A simple contraption for churning cream into butter."
	icon         = 'icons/obj/structures/butter_churn.dmi'
	product_type = /obj/item/food/dairy/butter/stick
	work_sound   = /datum/composite_sound/loom_working
	atom_flags   = ATOM_FLAG_OPEN_CONTAINER

/obj/structure/working/butter_churn/Initialize()
	. = ..()
	initialize_reagents()

/obj/structure/working/butter_churn/initialize_reagents(populate)
	create_reagents(200)
	. = ..()

/obj/structure/working/butter_churn/try_start_working(mob/user)

	if(!reagents?.has_reagent(/decl/material/liquid/drink/milk/cream, 20))
		to_chat(user, SPAN_NOTICE("\The [src] does not have enough cream to churn into butter."))
		return FALSE

	start_working()
	var/decl/chemical_reaction/butter_recipe = GET_DECL(/decl/chemical_reaction/recipe/food/dairy/butter)
	var/processed = 0
	while(user.do_skilled(1.5 SECONDS, work_skill, src) && reagents?.has_reagent(/decl/material/liquid/drink/milk/cream, 20))
		if(QDELETED(src) || QDELETED(user))
			break
		var/obj/item/food/butter = new product_type(get_turf(src))
		if(istype(butter))
			butter.set_nutriment_data(butter_recipe.send_data(reagents))
		processed += 20
		reagents.remove_reagent(/decl/material/liquid/drink/milk/cream, 20)

	if(processed && !QDELETED(user))
		to_chat(user, SPAN_NOTICE("You finish working at \the [src], having churned [processed] unit\s of cream into butter."))

	stop_working()
	return TRUE

/obj/structure/working/butter_churn/walnut
	material = /decl/material/solid/organic/wood/walnut
	color    = /decl/material/solid/organic/wood/walnut::color
