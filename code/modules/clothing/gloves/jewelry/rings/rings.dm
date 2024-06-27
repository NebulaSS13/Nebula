/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/gloves/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_diamond.dmi'

/obj/item/clothing/gloves/ring/engagement/attack_self(mob/user)
	user.visible_message(SPAN_WARNING("\The [user] gets down on one knee, presenting \the [src]."), SPAN_WARNING("You get down on one knee, presenting \the [src]."))

/obj/item/clothing/gloves/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_cti.dmi'

/obj/item/clothing/gloves/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_mariner.dmi'

/////////////////////////////////////////
//Magic Rings

/obj/item/clothing/gloves/ring/magic
	name = "magic ring"
	desc = "A strange ring with symbols carved on it in some arcane language."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_magic.dmi'

/obj/item/clothing/gloves/ring/magic/equipped(var/mob/living/human/H, var/slot)
	..()
	if(istype(H) && slot == SLOT_HANDS)
		H.add_cloaking_source(src)

/obj/item/clothing/gloves/ring/magic/dropped(var/mob/living/human/H)
	if(!..())
		return 0

	if(istype(H))
		H.remove_cloaking_source(src)

/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/gloves/ring/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = @'{"materials":2,"esoteric":4}'
	var/tmp/volume = 15

/obj/item/clothing/gloves/ring/reagent/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/clothing/gloves/ring/reagent/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(volume)
	else
		reagents.maximum_volume = max(volume, reagents.maximum_volume)
	. = ..()

/obj/item/clothing/gloves/ring/reagent/equipped(var/mob/living/human/H)
	..()
	if(istype(H) && H.get_equipped_item(slot_gloves_str) == src)
		to_chat(H, SPAN_DANGER("You feel a prick as you slip on the ring."))

		if(reagents.total_volume)
			if(H.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, reagents.total_volume, CHEM_INJECT)
				admin_inject_log(usr, H, src, contained_reagents, trans)
	return

//Sleepy Ring
/obj/item/clothing/gloves/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	origin_tech = @'{"materials":2,"esoteric":5}'

/obj/item/clothing/gloves/ring/reagent/sleepy/populate_reagents()
	add_to_reagents(/decl/material/liquid/paralytics, 10)
	add_to_reagents(/decl/material/liquid/sedatives,   5)

/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/gloves/ring/seal
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal_secgen.dmi'

/obj/item/clothing/gloves/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal_masonic.dmi'

/obj/item/clothing/gloves/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon = 'icons/clothing/accessories/jewelry/rings/ring_seal_signet.dmi'
	var/nameset = 0

/obj/item/clothing/gloves/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, SPAN_NOTICE("The [src] has already been claimed!"))
		return

	nameset = 1
	to_chat(user, SPAN_NOTICE("You claim the [src] as your own!"))
	name = "[user]'s signet ring"
	desc = "A signet ring belonging to [user], for when you're too sophisticated to sign letters."
