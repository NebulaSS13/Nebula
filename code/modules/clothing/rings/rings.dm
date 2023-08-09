/////////////////////////////////////////
//Standard Rings
/obj/item/clothing/ring/engagement
	name = "engagement ring"
	desc = "An engagement ring. It certainly looks expensive."
	icon = 'icons/clothing/rings/ring_diamond.dmi'

/obj/item/clothing/ring/engagement/attack_self(mob/user)
	user.visible_message(SPAN_WARNING("\The [user] gets down on one knee, presenting \the [src]."), SPAN_WARNING("You get down on one knee, presenting \the [src]."))

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
	var/tmp/volume = 15

/obj/item/clothing/ring/reagent/Initialize(ml, material_key)
	. = ..()
	initialize_reagents()

/obj/item/clothing/ring/reagent/initialize_reagents(populate = TRUE)
	if(!reagents)
		create_reagents(volume)
	else
		reagents.maximum_volume = max(volume, reagents.maximum_volume)
	. = ..()

/obj/item/clothing/ring/reagent/equipped(var/mob/living/carbon/human/H)
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
/obj/item/clothing/ring/reagent/sleepy
	name = "silver ring"
	desc = "A ring made from what appears to be silver."
	origin_tech = "{'materials':2,'esoteric':5}"

/obj/item/clothing/ring/reagent/sleepy/populate_reagents()
	reagents.add_reagent(/decl/material/liquid/paralytics, 10)
	reagents.add_reagent(/decl/material/liquid/sedatives,   5)

/////////////////////////////////////////
//Seals and Signet Rings
/decl/stamp_type/ring_secretary_general
	name                = "secretary-general"
	owner_name          = "secretary-general"
	stamp_color_name    = "red"
	stamp_overlay_state = "paper_seal-signet"

/obj/item/clothing/ring/seal
	name = "Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	icon = 'icons/clothing/rings/ring_seal_secgen.dmi'
	///
	var/decl/stamp_type/stamp_symbol = /decl/stamp_type/ring_secretary_general
	///Maximum amount of uses given by a single fill. If -1, means infinite.
	var/max_uses = -1

/obj/item/clothing/ring/seal/Initialize(ml, material_key)
	. = ..()
	set_extension(src, /datum/extension/tool, list(TOOL_STAMP = TOOL_QUALITY_GOOD), TOOL_STAMP = list(TOOL_PROP_USES = max_uses))
	if(ispath(stamp_symbol))
		set_stamp_symbol(stamp_symbol)

/obj/item/clothing/ring/seal/proc/set_stamp_symbol(var/decl/stamp_type/_stamp_symbol)
	if(ispath(_stamp_symbol))
		_stamp_symbol = GET_DECL(_stamp_symbol)
	stamp_symbol = _stamp_symbol
	set_tool_property(TOOL_STAMP, TOOL_PROP_STAMP_SYMBOL, stamp_symbol)

//Mason Ring
/decl/stamp_type/ring_mason
	name                = "mason"
	stamp_color_name    = "bronze"
	stamp_overlay_state = "paper_seal-masonic"

/obj/item/clothing/ring/seal/mason
	name         = "masonic ring"
	desc         = "The Square and Compasses feature prominently on this Masonic ring."
	icon         = 'icons/clothing/rings/ring_seal_masonic.dmi'
	stamp_symbol = /decl/stamp_type/ring_mason

//Signet Ring
/obj/item/clothing/ring/seal/signet
	name           = "signet ring"
	desc           = "A signet ring, for when you're too sophisticated to sign letters."
	icon           = 'icons/clothing/rings/ring_seal_signet.dmi'
	stamp_symbol   = null
	var/owner_name

/obj/item/clothing/ring/seal/signet/Initialize(ml, material_key)
	. = ..()
	set_tool_property(TOOL_STAMP, TOOL_PROP_STAMP_OVERLAY, overlay_image('icons/obj/items/rubber_stamps_overlays.dmi', "paper_seal-signet", null, RESET_COLOR))
	set_tool_property(TOOL_STAMP, TOOL_PROP_STAMP_MESSAGE, "stamped by [name]")

/obj/item/clothing/ring/seal/signet/proc/set_signet_owner(var/mob/living/user)
	if(length(owner_name))
		to_chat(user, SPAN_NOTICE("The [src] has already been claimed!"))
		return
	if(!length(user.real_name))
		to_chat(user, SPAN_NOTICE("You must actually have a name to claim \the [src]!"))
		return
	owner_name = user.real_name
	to_chat(user, SPAN_NOTICE("You claim \the [src] as your own!"))
	SetName("[user]'s signet ring")
	desc = "A signet ring belonging to [user], for when you're too sophisticated to sign letters."
	set_tool_property(TOOL_STAMP, TOOL_PROP_STAMP_MESSAGE, "stamped by \the [src]")

/obj/item/clothing/ring/seal/signet/attack_self(mob/user)
	if(length(owner_name))
		return ..()
	set_signet_owner(user)
