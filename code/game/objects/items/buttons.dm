// Lightswitch Hull

/obj/item/frame/button/light_switch
	name = "light switch frame"
	desc = "Used for building a light switch."
	icon = 'icons/obj/power.dmi'
	icon_state = "light-p"
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	build_machine_type = /obj/machinery/light_switch

/obj/item/frame/button/light_switch/kit
	name = "light switch kit"
	fully_construct = TRUE
	build_machine_type = /obj/machinery/light_switch

/obj/item/frame/button/light_switch/windowtint
	name = "window tint switch frame"
	desc = "Used for building a window tint switch."
	icon = 'icons/obj/power.dmi'
	icon_state = "light-p"
	build_machine_type = /obj/machinery/button/windowtint

/obj/item/frame/button/light_switch/windowtint/kit
	name = "window tint switch kit"
	fully_construct = TRUE
	build_machine_type = /obj/machinery/button/windowtint