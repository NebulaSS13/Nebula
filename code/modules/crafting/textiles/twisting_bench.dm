/obj/structure/textiles/spinning_wheel/twisting_bench
	name = "twisting bench"
	desc = "An arrangement of hooks and levers used to spin dried gut fibers into catgut."
	icon = 'icons/obj/structures/twisting_bench.dmi'
	var/accepts_gut_material = /decl/material/solid/organic/leather/gut

/obj/structure/textiles/spinning_wheel/twisting_bench/can_process(obj/item/thing)
	return istype(thing, /obj/item/chems/food/butchery/offal) && istype(thing.material, accepts_gut_material)

/obj/structure/textiles/spinning_wheel/twisting_bench/is_thread_material(decl/material/mat)
	return istype(mat, accepts_gut_material)
