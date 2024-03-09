/obj/item/grenade/empgrenade
	name = "classic EMP grenade"
	icon = 'icons/obj/items/grenades/emp.dmi'
	origin_tech = @'{"materials":2,"magnets":3}'
	var/emp_light_range = 10
	var/emp_heavy_range = 4

/obj/item/grenade/empgrenade/detonate()
	..()
	if(empulse(src, emp_heavy_range, emp_light_range))
		qdel(src)
	return

/obj/item/grenade/empgrenade/low_yield
	name = "low-yield EMP grenade"
	desc = "A weaker variant of the classic EMP grenade."
	icon = 'icons/obj/items/grenades/emp_old.dmi'
	origin_tech = @'{"materials":2,"magnets":3}'
	emp_heavy_range = 1
	emp_light_range = 4
