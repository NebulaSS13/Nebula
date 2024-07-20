/decl/crafting_stage/material/stunprod_rod
	descriptor = "spear or stunprod"
	begins_with_object_type = /obj/item/handcuffs/cable
	item_icon_state = "wiredrod"
	progress_message = "You wind the cable cuffs around the top of the rod."
	completion_trigger_type = /obj/item/stack/material/rods
	stack_material = null
	stack_consume_amount = 1
	next_stages = list(
		/decl/crafting_stage/spear_blade_shard,
		/decl/crafting_stage/spear_blade_blade,
		/decl/crafting_stage/stunprod_wirecutters
	)

/decl/crafting_stage/material/stunprod_rod/consume_crafting_resource(var/mob/user, var/obj/item/thing, var/obj/item/target)
	. = ..()
	if(.)
		target.set_material(thing?.material.type)

/decl/crafting_stage/spear_blade_shard
	completion_trigger_type = /obj/item/shard
	progress_message = "You fasten the shard to the top of the rod with the cable."
	product = /obj/item/bladed/polearm/spear

/decl/crafting_stage/spear_blade_shard/get_product(var/obj/item/work)
	var/obj/item/shard/blade = locate() in work
	. = new product(get_turf(work), blade && blade.material && blade.material.type)
	if(ispath(product,  /obj/item/bladed/polearm/spear))
		var/obj/item/bladed/polearm/spear/S = .
		var/obj/item/handcuffs/cable/C = locate() in work
		if(C)
			S.cable_color = C.color
		if(work.material)
			S.shaft_material = work.material.type
		S.update_icon()

/decl/crafting_stage/spear_blade_blade
	completion_trigger_type = /obj/item/butterflyblade
	progress_message = "You fasten the blade to the top of the rod with the cable."
	product = /obj/item/bladed/polearm/spear

/decl/crafting_stage/spear_blade_blade/get_product(var/obj/item/work)
	var/obj/item/butterflyblade/blade = locate() in work
	. = new product(get_turf(work), blade && blade.material && blade.material.type)

/decl/crafting_stage/stunprod_wirecutters
	completion_trigger_type = /obj/item/wirecutters
	progress_message = "You fasten the wirecutters to the top of the rod with the cable, prongs outward."
	product = /obj/item/baton/cattleprod
