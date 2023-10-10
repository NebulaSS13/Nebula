/obj/item/grenade/empgrenade
	name = "classic EMP grenade"
	icon = 'icons/obj/items/grenades/emp.dmi'
	origin_tech = "{'materials':2,'magnets':3}"

/obj/item/grenade/empgrenade/detonate()
	..()
	if(empulse(src, 4, 10))
		qdel(src)
	return

/obj/item/grenade/empgrenade/low_yield
	name = "low-yield EMP grenade"
	desc = "A weaker variant of the classic EMP grenade."
	icon = 'icons/obj/items/grenades/emp_old.dmi'
	origin_tech = "{'materials':2,'magnets':3}"

/obj/item/grenade/empgrenade/low_yield/detonate()
	..()
	if(empulse(src, 4, 1))
		qdel(src)
