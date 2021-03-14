/obj/item/slime_extract_enhancer
	name = "extract enhancer"
	desc = "A potent chemical mix that will give a slime extract three uses."
	icon = 'icons/obj/items/chem/bottle.dmi'
	icon_state = "bottle17"

/obj/item/slime_extract_enhancer/afterattack(obj/target, mob/user , flag)
	if(!istype(target, /obj/item/slime_extract))
		return ..()
	var/obj/item/slime_extract/extract = target
	if(extract.enhanced == TRUE)
		to_chat(user, SPAN_WARNING("\The [extract] has already been enhanced!"))
		return TRUE
	if(extract.Uses <= 0)
		to_chat(user, SPAN_WARNING("You can't enhance a used extract!"))
		return TRUE
	to_chat(user, SPAN_NOTICE("You apply \the [src] to \the [extract]. It now has triple the amount of uses."))
	extract.Uses = 3
	extract.enhanced = TRUE
	qdel(src)
	return TRUE
