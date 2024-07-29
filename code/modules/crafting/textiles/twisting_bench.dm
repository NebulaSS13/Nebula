/obj/structure/textiles/spinning_wheel/twisting_bench
	name = "twisting bench"
	desc = "An arrangement of hooks and levers used to spin dried gut fibers into catgut."
	icon = 'icons/obj/structures/twisting_bench.dmi'
	var/accepts_gut_material = /decl/material/solid/organic/leather/gut

/obj/structure/textiles/spinning_wheel/twisting_bench/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/food/butchery/offal) && !istype(W, /obj/item/food/butchery/offal/small))
		to_chat(user, SPAN_WARNING("\The [W] is too large for \the [src], cut it up first."))
		return TRUE
	return ..()

/obj/structure/textiles/spinning_wheel/twisting_bench/can_process(obj/item/thing)
	return istype(thing, /obj/item/food/butchery/offal/small) && istype(thing.material, accepts_gut_material)

/obj/structure/textiles/spinning_wheel/twisting_bench/is_thread_material(decl/material/mat)
	return istype(mat, accepts_gut_material)

/obj/structure/textiles/spinning_wheel/twisting_bench/ebony
	material = /decl/material/solid/organic/wood/ebony
