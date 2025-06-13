/obj/structure/loot_pile/maint/technical/get_uncommon_loot()
	var/static/injected = FALSE
	. = ..()
	if(!injected)
		. += /obj/item/disk/integrated_circuit/upgrade/advanced
		injected = TRUE