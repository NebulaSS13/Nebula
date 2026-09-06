/obj/structure/memorial
	name = "memorial"
	desc = "A large stone slab, engraved with the names of people who have given their lives for the cause. Not a list you'd want to make. Add the dog tags of the fallen to the monument to memorialize them."
	icon = 'icons/obj/structures/memorial.dmi'
	icon_state = "memorial"
	pixel_x = -16
	pixel_y = -16
	density = TRUE
	anchored = TRUE
	material = /decl/material/solid/stone/marble
	material_alteration = MAT_FLAG_ALTERATION_DESC | MAT_FLAG_ALTERATION_NAME

	var/list/fallen = list()

/obj/structure/memorial/attackby(var/obj/item/used_item, var/mob/user)
	if(istype(used_item, /obj/item/clothing/dog_tags))
		var/obj/item/clothing/dog_tags/dogtags = used_item
		to_chat(user, "<span class='warning'>You add \the [dogtags.owner_name]'s [dogtags.name] to \the [src].</span>")
		fallen += "[dogtags.owner_rank] [dogtags.owner_name] | [dogtags.owner_branch]"
		qdel(dogtags)
		return TRUE
	return ..()

/obj/structure/memorial/get_examine_strings(mob/user, distance, infix, suffix)
	. = ..()
	if (distance <= 2 && fallen.len)
		. += "<b>The fallen:</b>"
		. += fallen
