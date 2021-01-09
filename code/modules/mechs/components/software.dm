#define T_BOARD_MECH(name)	"exosuit software (" + (name) + ")"

/obj/item/stock_parts/circuitboard/exosystem
	name = "exosuit software template"
	icon = 'icons/obj/modules/module_standard.dmi'
	var/list/contains_software = list()

/obj/item/stock_parts/circuitboard/exosystem/engineering
	name = T_BOARD_MECH("engineering systems")
	contains_software = list(MECH_SOFTWARE_ENGINEERING)
	origin_tech = "{'programming':1}"

/obj/item/stock_parts/circuitboard/exosystem/utility
	name = T_BOARD_MECH("utility systems")
	contains_software = list(MECH_SOFTWARE_UTILITY)
	icon = 'icons/obj/modules/module_controller.dmi'
	origin_tech = "{'programming':1}"

/obj/item/stock_parts/circuitboard/exosystem/medical
	name = T_BOARD_MECH("medical systems")
	contains_software = list(MECH_SOFTWARE_MEDICAL)
	icon = 'icons/obj/modules/module_controller.dmi'
	origin_tech = "{'programming':3,'biotech':2}"

/obj/item/stock_parts/circuitboard/exosystem/weapons
	name = T_BOARD_MECH("basic weapon systems")
	contains_software = list(MECH_SOFTWARE_WEAPONS)
	icon = 'icons/obj/modules/module_mainboard.dmi'
	origin_tech = "{'programming':4,'combat':3}"

#undef T_BOARD_MECH