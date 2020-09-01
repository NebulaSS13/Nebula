#define MAX_COMPRESS_ORE_PER_TICK  10

/obj/machinery/material_processing/compressor
	name = "material compressor"
	icon_state = "compressor"
	use_ui_template = "material_processing_compressor.tmpl"
	var/list/stored = list()

/obj/machinery/material_processing/compressor/Process()

	if(!use_power || (stat & (BROKEN|NOPOWER)))
		return

	if(input_turf)
		var/compressed = 0
		for(var/obj/item/O in input_turf)
			if(!O.simulated || O.anchored)
				continue
			for(var/mat in O.matter)
				if(stored[mat])
					stored[mat] += O.matter[mat]
				else
					stored[mat] = O.matter[mat]
			qdel(O)
			compressed++
			if(compressed >= MAX_COMPRESS_ORE_PER_TICK)
				break
		if(emagged)
			for(var/mob/living/carbon/human/H in input_turf)
				for(var/obj/item/organ/external/crushing in H.organs)
					if(!crushing.simulated || crushing.anchored || crushing.is_stump() || !prob(5))
						continue
					visible_message(SPAN_DANGER("\The [src] crushes \the [H]'s [crushing.name]!"))
					for(var/mat in crushing.matter)
						if(stored[mat])
							stored[mat] += crushing.matter[mat]
						else
							stored[mat] = crushing.matter[mat]
					crushing.droplimb(disintegrate = DROPLIMB_BLUNT, silent = TRUE)
					break
	if(output_turf)
		var/produced = 0
		for(var/mat in stored)
			var/sheets = min(Floor((stored[mat] / SHEET_MATERIAL_AMOUNT) / 2), (MAX_COMPRESS_ORE_PER_TICK - produced))
			if(sheets <= 0)
				continue
			var/decl/material/source = decls_repository.get_decl(mat)
			var/decl/material/product = source.ore_compresses_to ? decls_repository.get_decl(source.ore_compresses_to) : source
			product.place_sheet(output_turf, sheets)
			stored[mat] -= ceil(sheets * SHEET_MATERIAL_AMOUNT * 2)
			if(stored[mat] <= 0)
				stored -= mat
			produced += sheets
			if(produced >= MAX_COMPRESS_ORE_PER_TICK)
				break
