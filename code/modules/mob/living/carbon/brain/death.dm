/mob/living/brain/death(gibbed)
	var/death_message = "no message"
	var/obj/item/brain_interface/container = get_container()
	if(!gibbed && istype(container))
		death_message = "beeps shrilly as \the [container] flatlines!"
	. = ..(gibbed, death_message)
	if(istype(container))
		container.update_icon()

/mob/living/brain/gib()
	var/obj/item/brain_interface/container = get_container()
	var/obj/item/organ/internal/brain/sponge = loc
	. = ..(null, 1)
	if(container && !QDELETED(container))
		qdel(container)
	if(istype(sponge) && !QDELETED(sponge)) 
		qdel(sponge)
