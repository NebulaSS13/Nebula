/mob/living/brain/get_radio()
	var/obj/item/organ/internal/brain_interface/container = get_container()
	if(istype(container))
		return container.get_radio()

/mob/living/brain/get_death_message(gibbed)
	var/obj/item/organ/internal/brain_interface/container = get_container()
	if(!gibbed && istype(container))
		return "beeps shrilly as \the [container] flatlines!"
	return ..()

/mob/living/brain/death(gibbed)
	var/obj/item/organ/internal/brain_interface/container = get_container()
	. = ..()
	if(. && istype(container) && !QDELETED(container))
		container.update_icon()

/mob/living/brain/gib(do_gibs = TRUE)
	var/obj/item/organ/internal/brain_interface/container = get_container()
	. = ..()
	if(. && istype(container) && !QDELETED(container))
		qdel(container)

/mob/living/brain/on_container_login(obj/item/organ/internal/container)
	var/obj/item/organ/internal/brain_interface/interface = container
	if(istype(interface))
		interface.locked = TRUE
	. = ..()

/mob/living/brain/is_in_interface()
	var/container = get_container()
	return ..() || istype(container, /obj/item/organ/internal/brain_interface)

/mob/living/brain/check_mob_can_emote(var/emote_type, allow_brain_emote = FALSE)
	return ..(emote_type, istype(get_container(), /obj/item/organ/internal/brain_interface))
