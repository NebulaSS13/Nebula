/obj/structure/memorial
	name = "memorial"
	desc = "A large stone slab, engraved with the names of people who have given their lives for the cause. Not a list you'd want to make. Add the dog tags of the fallen to the monument to memorialize them."
	icon = 'icons/obj/structures/memorial.dmi'
	icon_state = "memorial"
	pixel_x = -16
	pixel_y = -16
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	material = /decl/material/solid/stone/marble
	material_alteration = MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_NAME

	var/list/fallen = list()

/obj/structure/memorial/attackby(var/obj/D, var/mob/user)
	if(istype(D, /obj/item/clothing/accessory/badge/tags))
		var/obj/item/clothing/accessory/badge/tags/T = D
		to_chat(user, "<span class='warning'>You add \the [T.owner_name]'s \the [T] to \the [src].</span>")
		fallen += "[T.owner_rank] [T.owner_name] | [T.owner_branch]"
		qdel(T)

/obj/structure/memorial/examine(mob/user, distance)
	. = ..()
	if (distance <= 2 && fallen.len)
		to_chat(user, "<b>The fallen:</b> [jointext(fallen, "<br>")]")
