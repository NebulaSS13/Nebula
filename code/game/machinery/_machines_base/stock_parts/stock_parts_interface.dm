/obj/item/stock_parts/console_screen
	name = "console screen"
	desc = "Used in the construction of computers and other devices with an interactive screen."
	icon_state = "output"
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/glass
	base_type = /obj/item/stock_parts/console_screen
	part_flags = PART_FLAG_HAND_REMOVE
	health = 20

/obj/item/stock_parts/console_screen/on_refresh(obj/machinery/machine)
	..()
	if(is_functional())
		machine.set_noscreen(FALSE)

/obj/item/stock_parts/console_screen/on_fail(var/obj/machinery/machine, damtype)
	..()
	playsound(src, "shatter", 10, 1)

/obj/item/stock_parts/keyboard
	name = "input controller"
	desc = "A standard part required by many machines to recieve user input."
	icon_state = "input"
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/plastic
	base_type = /obj/item/stock_parts/keyboard
	part_flags = PART_FLAG_HAND_REMOVE
	w_class = ITEM_SIZE_TINY

/obj/item/stock_parts/keyboard/on_refresh(obj/machinery/machine)
	..()
	if(is_functional())
		machine.set_noinput(FALSE)
		