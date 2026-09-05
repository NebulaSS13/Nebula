/obj/random/psionic
	name = "random cursed item"
	desc = "For use in dungeons."
	icon = /obj/item/clothing/head/helmet/space/psi_amp::icon
	icon_state = /obj/item/clothing/head/helmet/space/psi_amp::icon_state

/obj/random/psionic/item_to_spawn()
	var/static/list/spawnable_choices = list(
		/obj/item/shard/nullglass = 20,
		/obj/item/ammo_magazine/speedloader/nullglass = 10,
		/obj/item/gun/projectile/revolver/foundation = 5,
		/obj/item/clothing/head/helmet/space/psi_amp/lesser = 1
	)
	return spawnable_choices
