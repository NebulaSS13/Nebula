/obj/screen/inventory/swaphand
	name = "hand"
	icon_state = "hand1"

/obj/screen/inventory/swaphand/handle_click(mob/user, params)
	user.swap_hand()

/obj/screen/inventory/swaphand/right
	icon_state = "hand2"
