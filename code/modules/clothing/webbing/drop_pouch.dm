
/obj/item/clothing/webbing/drop_pouches
	slots = 4 //to accomodate it being slotless

/obj/item/clothing/webbing/drop_pouches/create_storage()
	hold = new/obj/item/storage/internal/pouch(src, slots*BASE_STORAGE_COST(max_w_class))

/obj/item/clothing/webbing/drop_pouches/black
	name = "black drop pouches"
	desc = "Robust black synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_black.dmi'

/obj/item/clothing/webbing/drop_pouches/brown
	name = "brown drop pouches"
	desc = "Worn brownish synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_brown.dmi'

/obj/item/clothing/webbing/drop_pouches/white
	name = "white drop pouches"
	desc = "Durable white synthcotton bags to hold whatever you need, but cannot hold in hands."
	icon = 'icons/clothing/accessories/pouches/thigh_white.dmi'
