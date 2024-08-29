/obj/item/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	material = /decl/material/solid/metal/steel

/obj/item/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	material = /decl/material/solid/metal/steel

/decl/crafting_stage/balisong_blade
	descriptor = "balisong"
	begins_with_object_type = /obj/item/butterflyhandle
	item_desc = "It's an unfinished balisong with some loose screws."
	item_icon_state = "butterfly"
	consume_completion_trigger = TRUE
	completion_trigger_type = /obj/item/butterflyblade
	progress_message = "You attach the knife blade to the handle."
	next_stages = list(/decl/crafting_stage/screwdriver/balisong)

/decl/crafting_stage/screwdriver/balisong
	progress_message = "You secure the handle and the blade together."
	product = /obj/item/knife/folding/combat/balisong

/decl/crafting_stage/screwdriver/balisong/get_product(var/obj/item/work)
	var/obj/item/butterflyblade/blade = locate() in work
	. = new product(get_turf(work), blade && blade.material && blade.material.type)