/obj/machinery/fabricator/industrial
	name = "industrial fabricator"
	desc = "A hulking, powerful fabrication system for producing industrial machinery like exosuits."
	icon = 'icons/obj/machines/fabricators/industrial_fab.dmi'
	icon_state = "industrial"
	base_icon_state = "industrial"
	idle_power_usage = 20
	active_power_usage = 5000
	base_type = /obj/machinery/fabricator/industrial
	fabricator_class = FABRICATOR_CLASS_INDUSTRIAL
	base_storage_capacity = list(
		MAT_STEEL =     SHEET_MATERIAL_AMOUNT * 100,
		MAT_OSMIUM =    SHEET_MATERIAL_AMOUNT * 100,
		MAT_ALUMINIUM = SHEET_MATERIAL_AMOUNT * 100,
		MAT_PLASTIC =   SHEET_MATERIAL_AMOUNT * 100,
		MAT_GLASS =     SHEET_MATERIAL_AMOUNT * 100,
		MAT_GOLD =      SHEET_MATERIAL_AMOUNT * 100,
		MAT_SILVER =    SHEET_MATERIAL_AMOUNT * 100,
		MAT_PHORON =    SHEET_MATERIAL_AMOUNT * 100,
		MAT_URANIUM =   SHEET_MATERIAL_AMOUNT * 100,
		MAT_DIAMOND =   SHEET_MATERIAL_AMOUNT * 100
	)

/obj/machinery/fabricator/industrial/do_build(var/datum/fabricator_recipe/recipe, var/amount)
	. = ..()
	for(var/atom/movable/product in .)
		step(product, EAST)
