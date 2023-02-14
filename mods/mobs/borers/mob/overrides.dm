#define HAS_BRAIN_WORMS(HOST) (locate(/mob/living/simple_animal/borer) in HOST?.contents)

/obj/item/organ/external/has_growths()
	. = ..()
	if(!.)
		. = locate(/mob/living/simple_animal/borer) in implants

/mob/proc/has_brain_worms()
	. = locate(/mob/living/simple_animal/borer) in contents

/mob/handle_pre_transformation()
	. = ..()
	var/mob/living/simple_animal/borer/borer = HAS_BRAIN_WORMS(src)
	if(borer)
		borer.detatch()
		borer.leave_host()

/mob/living/human/handle_hud_list()
	var/last_hud_bitfield = hud_updateflag
	. = ..()
	if(stat != DEAD && has_brain_worms() && BITTEST(last_hud_bitfield, STATUS_HUD) && hud_list[STATUS_HUD] && hud_list[STATUS_HUD_OOC])
		var/mob/living/simple_animal/borer/B = HAS_BRAIN_WORMS(src)
		if(B.controlling)
			var/image/holder = hud_list[STATUS_HUD]
			holder.icon_state = "hudbrainworm"
		var/image/holder2 = hud_list[STATUS_HUD_OOC]
		holder2.icon_state = "hudbrainworm"

/mob/living/human/say_understands(mob/speaker, decl/language/speaking)
	return has_brain_worms() || ..()

/obj/item/organ/internal/brain/do_uninstall(in_place, detach, ignore_children)
	if(istype(owner))
		var/mob/living/simple_animal/borer/borer = HAS_BRAIN_WORMS(owner)
		if(borer)
			borer.detatch()
	. = ..()

/obj/item/glass_jar/Initialize()
	accept_mobs |= /mob/living/simple_animal/borer
	. = ..()

/mob/death()
	var/mob/living/simple_animal/borer/B = HAS_BRAIN_WORMS(src)
	if(B && B.controlling)
		B.detatch()
	. = ..()
