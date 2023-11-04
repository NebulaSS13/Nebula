/obj/item/psychic_power
	name = "psychic power"
	icon = 'mods/content/psionics/icons/psychic_powers.dmi'
	atom_flags = 0
	simulated = 1
	anchored = TRUE

	pickup_sound = null
	drop_sound =   null
	equip_sound =  null

	is_spawnable_type = FALSE
	abstract_type = /obj/item/psychic_power

	var/maintain_cost = 3
	var/mob/living/owner

/obj/item/psychic_power/Initialize()
	owner = loc
	if(!istype(owner))
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/psychic_power/Destroy()
	if(istype(owner) && owner.psi)
		LAZYREMOVE(owner.psi.manifested_items, src)
		UNSETEMPTY(owner.psi.manifested_items)
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/psychic_power/get_storage_cost()
	return ITEM_SIZE_NO_CONTAINER

/obj/item/psychic_power/attack_self(var/mob/user)
	sound_to(owner, 'sound/effects/psi/power_fail.ogg')
	user.drop_from_inventory(src)

/obj/item/psychic_power/attack(var/mob/living/M, var/mob/living/user, var/target_zone)
	if(M.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, "<span class='danger'>\The [src] flickers violently out of phase!</span>")
		return 1
	. = ..()

/obj/item/psychic_power/afterattack(var/atom/target, var/mob/living/user, var/proximity)
	if(target.do_psionics_check(max(force, maintain_cost), user))
		to_chat(user, "<span class='danger'>\The [src] flickers violently out of phase!</span>")
		return
	. = ..(target, user, proximity)

/obj/item/psychic_power/dropped()
	..()
	qdel(src)

/obj/item/psychic_power/Process()
	if(istype(owner))
		owner.psi.spend_power(maintain_cost, backblast_on_failure = FALSE)
	if((!owner || owner.do_psionics_check(maintain_cost, owner) || loc != owner || !(src in owner.get_held_items())) && !QDELETED(src))
		qdel(src)
