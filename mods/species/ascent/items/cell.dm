// Self-charging power cell.
/obj/item/cell/mantid
	name = "mantid microfusion plant"
	desc = "An impossibly tiny fusion reactor of mantid design."
	icon = 'mods/species/ascent/icons/ascent.dmi'
	icon_state = "plant"
	maxcharge = 1500
	w_class = ITEM_SIZE_NORMAL
	var/recharge_amount = 12

/obj/item/cell/mantid/Initialize()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/mantid/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/cell/mantid/Process()
	if(charge < maxcharge)
		give(recharge_amount)
