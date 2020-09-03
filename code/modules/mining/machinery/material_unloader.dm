/obj/machinery/material_processing/unloader
	name = "ore unloader"
	icon_state = "unloader"
	use_ui_template = "material_processing_unloader.tmpl"

#define MAX_UNLOAD_TURF_CONTENTS 15
#define MAX_UNLOAD_ORE_PER_TICK  10

/obj/machinery/material_processing/unloader/Process()

	if(!use_power || (stat & (BROKEN|NOPOWER)))
		return

	if(!output_turf || !input_turf)
		return
	
	if(length(output_turf.contents) >= MAX_UNLOAD_TURF_CONTENTS)
		return

	var/ore_this_tick = 0
	for(var/obj/structure/ore_box/unloading in input_turf)
		for(var/obj/item/ore in unloading)
			ore.dropInto(output_turf)
			ore_this_tick++
			if(ore_this_tick >= MAX_UNLOAD_ORE_PER_TICK || length(output_turf.contents) >= MAX_UNLOAD_TURF_CONTENTS)
				return

	for(var/obj/item/ore in input_turf)
		if(ore.simulated && !ore.anchored)
			ore.dropInto(output_turf)
			ore_this_tick++
			if(ore_this_tick >= MAX_UNLOAD_ORE_PER_TICK || length(output_turf.contents) >= MAX_UNLOAD_TURF_CONTENTS)
				return

	if(emagged)
		for(var/mob/living/M in input_turf)
			visible_message(SPAN_DANGER("\The [M] is yanked violently through \the [src]!"))
			M.take_overall_damage(rand(10, 20), 0)
			M.dropInto(output_turf)
			break

#undef MAX_UNLOAD_TURF_CONTENTS
#undef MAX_UNLOAD_ORE_PER_TICK