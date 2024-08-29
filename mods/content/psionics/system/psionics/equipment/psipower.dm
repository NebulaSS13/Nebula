/obj/item/ability/psionic
	name = "psychic power"
	icon = 'mods/content/psionics/icons/psychic_powers.dmi'
	abstract_type = /obj/item/ability/psionic
	handler_type = /datum/ability_handler/psionics
	var/maintain_cost = 3

/obj/item/ability/psionic/Initialize()
	. = ..()
	if(. != INITIALIZE_HINT_QDEL)
		START_PROCESSING(SSprocessing, src)

/obj/item/ability/psionic/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/ability/psionic/attack_self(var/mob/user)
	sound_to(owner, 'sound/effects/psi/power_fail.ogg')
	. = ..()

/obj/item/ability/psionic/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(target.do_psionics_check(max(get_attack_force(user), maintain_cost), user))
		to_chat(user, SPAN_WARNING("\The [src] flickers violently out of phase!"))
		return TRUE
	. = ..()

/obj/item/ability/psionic/afterattack(var/atom/target, var/mob/living/user, var/proximity)
	if(target.do_psionics_check(max(get_attack_force(user), maintain_cost), user))
		to_chat(user, SPAN_WARNING("\The [src] flickers violently out of phase!"))
		return TRUE
	. = ..(target, user, proximity)

/obj/item/ability/psionic/Process()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	psi?.spend_power(maintain_cost, backblast_on_failure = FALSE)
	if((!owner || owner.do_psionics_check(maintain_cost, owner) || loc != owner || !(src in owner.get_held_items())) && !QDELETED(src))
		qdel(src)
