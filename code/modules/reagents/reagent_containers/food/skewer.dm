/obj/item/food/skewer
	abstract_type = /obj/item/food/skewer
	icon = 'icons/obj/food/butchery/kabob.dmi'
	trash = /obj/item/stack/material/rods
	center_of_mass = @'{"x":17,"y":15}'
	bitesize = 2
	nutriment_desc = list("tofu" = 3, "metal" = 1)
	nutriment_amt = 8

/obj/item/food/skewer/on_reagent_change()
	. = ..()
	update_icon()

/obj/item/food/skewer/on_update_icon()
	. = ..()
	var/decl/material/meat = reagents?.get_primary_reagent_decl()
	if(meat)
		add_overlay(overlay_image(icon, "[icon_state]_meat", meat.color, RESET_COLOR))

/obj/item/food/skewer/meat
	name = "meat skewer"
	desc = "Delicious meat, on a stick."
	filling_color = "#a85340"
	nutriment_type = /decl/material/solid/organic/meat

/obj/item/food/skewer/tofu
	name = "tofu skewer"
	icon = 'icons/obj/food/butchery/kabob.dmi'
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/material/rods
	filling_color = "#fffee0"
	center_of_mass = @'{"x":17,"y":15}'
