/obj/item/grenade/empgrenade
	name = "classic emp grenade"
	icon_state = "emp"
	item_state = "empgrenade"
	origin_tech = "{'materials':2,'magnets':3}"

	detonate()
		..()
		if(empulse(src, 4, 10))
			qdel(src)
		return

/obj/item/grenade/empgrenade/low_yield
	name = "low yield emp grenade"
	desc = "A weaker variant of the classic emp grenade."
	icon_state = "lyemp"
	item_state = "lyempgrenade"
	origin_tech = "{'materials':2,'magnets':3}"

	detonate()
		..()
		if(empulse(src, 4, 1))
			qdel(src)
		return
