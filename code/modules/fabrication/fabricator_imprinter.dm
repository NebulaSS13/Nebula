/obj/machinery/fabricator/imprinter
	name = "circuit imprinter"
	desc = "An advanced fabricator that etches circuits from various materials and acids."
	icon = 'icons/obj/machines/fabricators/imprinter.dmi'
	icon_state = "imprinter"
	base_icon_state = "imprinter"
	idle_power_usage = 30
	active_power_usage = 2500
	base_type = /obj/machinery/fabricator/imprinter
	has_recycler = FALSE
	fabricator_class = FABRICATOR_CLASS_IMPRINTER
	base_storage_capacity = list(
		/decl/material/solid/glass =              SHEET_MATERIAL_AMOUNT * 50,
		/decl/material/solid/metal/gold =         SHEET_MATERIAL_AMOUNT * 50,
		/decl/material/solid/metal/silver =       SHEET_MATERIAL_AMOUNT * 50,
		/decl/material/solid/gemstone/diamond =   SHEET_MATERIAL_AMOUNT * 50,
		/decl/material/liquid/acid =              120,
		/decl/material/liquid/acid/hydrochloric = 120,
		/decl/material/liquid/acid/polyacid =     120
	)