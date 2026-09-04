var/global/list/_available_gemstone_cuts

/proc/get_available_gemstone_cuts()
	if(!global._available_gemstone_cuts)
		global._available_gemstone_cuts = list()
		for(var/decl/gemstone_cut/cut as anything in decls_repository.get_decls_of_type_unassociated(/decl/gemstone_cut))
			if(cut.can_be_cut)
				global._available_gemstone_cuts += cut
	return global._available_gemstone_cuts

/obj/item/gemstone
	name                      = "uncut gemstone"
	desc                      = "A hunk of uncut gemstone."
	icon                      = 'icons/obj/items/gemstones/uncut.dmi'
	icon_state                = ICON_STATE_WORLD
	w_class                   = ITEM_SIZE_TINY
	material                  = /decl/material/solid/gemstone/diamond
	material_alteration       = MAT_FLAG_ALTERATION_COLOR // Name and desc are handled manually.
	color                     = /decl/material/solid/gemstone/diamond::color
	var/decl/gemstone_cut/cut = /decl/gemstone_cut/uncut
	var/work_skill            = SKILL_CONSTRUCTION

/obj/item/gemstone/Initialize(ml, material_key)
	cut = GET_DECL(cut)
	. = ..()
	update_from_cut()

/obj/item/gemstone/proc/update_from_cut()
	icon = cut.icon
	desc = cut.desc
	update_name()
	update_icon()

/obj/item/gemstone/update_name()
	SetName("[cut.adjective] [material.solid_name]")

/obj/item/gemstone/get_single_monetary_worth()
	if(worthless)
		return 0
	. = ..() * cut.worth_multiplier

/obj/item/gemstone/attackby(obj/item/used_item, mob/user)
	if(IS_CHISEL(used_item) && !user.check_intent(I_FLAG_HARM))
		if(!cut.can_attempt_cut)
			to_chat(user, SPAN_WARNING("\The [src] has already been cut."))
			return TRUE
		var/decl/gemstone_cut/desired_cut = input(user, "What cut would you like to attempt?", "Cut Gemstone") as null|anything in get_available_gemstone_cuts()
		if(!desired_cut || QDELETED(src) || QDELETED(user) || !CanPhysicallyInteract(user) || !cut.can_attempt_cut)
			return TRUE
		user.visible_message(SPAN_NOTICE("\The [user] begins carefully cutting \the [src]."))
		if(!user.do_skilled(10 SECONDS, work_skill, src, check_holding = TRUE) || !CanPhysicallyInteract(user))
			if(QDELETED(src) || !cut.can_attempt_cut || QDELETED(user))
				return TRUE
			to_chat(user, SPAN_DANGER("You were interrupted, botching the cut!"))
			cut = GET_DECL(/decl/gemstone_cut/poor)
		else
			if(QDELETED(src) || !cut.can_attempt_cut || QDELETED(user))
				return TRUE
			user.visible_message(SPAN_NOTICE("\The [user] finishes cutting \the [src]."))
			if(user.skill_fail_prob(work_skill, 100, SKILL_EXPERT))
				to_chat(user, SPAN_DANGER("You've done a really poor job..."))
				cut = GET_DECL(/decl/gemstone_cut/poor)
			else
				cut = desired_cut
		update_from_cut()
		return TRUE
	. = ..()

// Subtypes for mapping/spawning etc.
/obj/item/gemstone/poor
	name = "poorly-cut diamond"
	cut  = /decl/gemstone_cut/poor
	icon = 'icons/obj/items/gemstones/poor.dmi'

/obj/item/gemstone/baguette
	name = "baguette-cut diamond"
	cut  = /decl/gemstone_cut/baguette
	icon = 'icons/obj/items/gemstones/baguette.dmi'

/obj/item/gemstone/hexagon
	name = "hexagon-cut diamond"
	cut  = /decl/gemstone_cut/hexagon
	icon = 'icons/obj/items/gemstones/hexagon.dmi'

/obj/item/gemstone/octagon
	name = "octagon-cut diamond"
	cut  = /decl/gemstone_cut/octagon
	icon = 'icons/obj/items/gemstones/octagon.dmi'

/obj/item/gemstone/round
	name = "round-cut diamond"
	cut  = /decl/gemstone_cut/round
	icon = 'icons/obj/items/gemstones/round.dmi'


// Material subtypes.
#define MATERIAL_CUT_GEMSTONES(MAT)\
/obj/item/gemstone/baguette/##MAT{\
	material = /decl/material/solid/gemstone/##MAT;\
	color    = /decl/material/solid/gemstone/##MAT::color;\
}\
/obj/item/gemstone/hexagon/##MAT{\
	material = /decl/material/solid/gemstone/##MAT;\
	color    = /decl/material/solid/gemstone/##MAT::color;\
}\
/obj/item/gemstone/octagon/##MAT{\
	material = /decl/material/solid/gemstone/##MAT;\
	color    = /decl/material/solid/gemstone/##MAT::color;\
}\
/obj/item/gemstone/round/##MAT{\
	material = /decl/material/solid/gemstone/##MAT;\
	color    = /decl/material/solid/gemstone/##MAT::color;\
}

MATERIAL_CUT_GEMSTONES(topaz)
MATERIAL_CUT_GEMSTONES(sapphire)
MATERIAL_CUT_GEMSTONES(ruby)