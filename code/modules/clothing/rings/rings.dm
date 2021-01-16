/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon = 'icons/clothing/rings/ring_diamond.dmi'

/obj/item/clothing/ring/engagement/attack_self(mob/user)
	user.visible_message("<span class='warning'>\The [user] gets down on one knee, presenting \the [src].</span>","<span class='warning'>You get down on one knee, presenting \the [src].</span>")

/obj/item/clothing/ring/cti
	name = "CTI ring"
	desc = "A ring commemorating graduation from CTI."
	icon = 'icons/clothing/rings/ring_cti.dmi'

/obj/item/clothing/ring/mariner
	name = "Mariner University ring"
	desc = "A ring commemorating graduation from Mariner University."
	icon = 'icons/clothing/rings/ring_mariner.dmi'

/////////////////////////////////////////
//Magic Rings

/obj/item/clothing/ring/magic
	name = "magic ring"
	desc = "A strange ring with symbols carved on it in some arcane language."
	icon = 'icons/clothing/rings/ring_magic.dmi'

/obj/item/clothing/ring/magic/equipped(var/mob/living/carbon/human/H, var/slot)
	..()
	if(istype(H) && slot == SLOT_HANDS)
		H.add_cloaking_source(src)

/obj/item/clothing/ring/magic/dropped(var/mob/living/carbon/human/H)
	if(!..())
		return 0

	if(istype(H))
		H.remove_cloaking_source(src)

/////////////////////////////////////////
//Reagent Rings

/obj/item/clothing/ring/reagent
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	origin_tech = "{'materials':2,'esoteric':4}"

/obj/item/clothing/ring/reagent/Initialize()
	. = ..()
	create_reagents(15)

/obj/item/clothing/ring/reagent/equipped(var/mob/living/carbon/human/H)
	..()
	if(istype(H) && H.gloves==src)
		to_chat(H, "<font color='blue'><b>You feel a prick as you slip on the ring.</b></font>")

		if(reagents.total_volume)
			if(H.reagents)
				var/contained_reagents = reagents.get_reagents()
				var/trans = reagents.trans_to_mob(H, 15, CHEM_INJECT)
				admin_inject_log(usr, H, src, contained_reagents, trans)
	return

//Sleepy Ring
/obj/item/clothing/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	origin_tech = "{'materials':2,'esoteric':5}"

/obj/item/clothing/ring/reagent/sleepy/Initialize()
	. = ..()
	reagents.add_reagent(/decl/material/liquid/paralytics, 10) // Less than a sleepy-pen, but still enough to knock someone out
	reagents.add_reagent(/decl/material/liquid/sedatives, 5)  

/////////////////////////////////////////
//Seals and Signet Rings
/obj/item/clothing/ring/seal
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon = 'icons/clothing/rings/ring_seal_secgen.dmi'

/obj/item/clothing/ring/seal/mason
	name = "masonic ring"
	desc = "The Square and Compasses feature prominently on this Masonic ring."
	icon = 'icons/clothing/rings/ring_seal_masonic.dmi'

/obj/item/clothing/ring/seal/signet
	name = "signet ring"
	desc = "A signet ring, for when you're too sophisticated to sign letters."
	icon = 'icons/clothing/rings/ring_seal_signet.dmi'
	var/nameset = 0

/obj/item/clothing/ring/seal/signet/attack_self(mob/user)
	if(nameset)
		to_chat(user, "<span class='notice'>The [src] has already been claimed!</span>")
		return

	nameset = 1
	to_chat(user, "<span class='notice'>You claim the [src] as your own!</span>")
	name = "[user]'s signet ring"
	desc = "A signet ring belonging to [user], for when you're too sophisticated to sign letters."
