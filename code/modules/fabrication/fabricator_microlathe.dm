/obj/machinery/fabricator/micro
	name = "microlathe"
	desc = "It produces small items from common resources."
	icon = 'icons/obj/machines/fabricators/microlathe.dmi'
	icon_state = "minilathe"
	base_icon_state = "minilathe"
	idle_power_usage = 5
	active_power_usage = 1000
	base_type = /obj/machinery/fabricator/micro
	fabricator_class = FABRICATOR_CLASS_MICRO
	base_storage_capacity = list(
		MAT_ALUMINIUM = SHEET_MATERIAL_AMOUNT * 5,
		MAT_PLASTIC =   SHEET_MATERIAL_AMOUNT * 5,
		MAT_GLASS   =   SHEET_MATERIAL_AMOUNT * 5
	)

//Subtype for mapping, starts preloaded with glass and set to print glasses
/obj/machinery/fabricator/micro/bartender
	show_category = "Drinking Glasses"

/obj/machinery/fabricator/micro/bartender/Initialize()
	. = ..()
	stored_material[MAT_GLASS] = base_storage_capacity[MAT_GLASS]