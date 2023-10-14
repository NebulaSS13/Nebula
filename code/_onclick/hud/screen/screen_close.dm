/obj/screen/close
	name       = "close"
	icon_state = "x"
	layer      = HUD_BASE_LAYER

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/storage))
			var/obj/item/storage/S = master
			S.close(usr)
	return 1
