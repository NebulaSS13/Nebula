/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */

/////////////////////////////////////////////////////////////////
// Filling Cabinet
/////////////////////////////////////////////////////////////////
/obj/structure/filingcabinet
	name                   = "filing cabinet"
	desc                   = "A large cabinet with drawers."
	icon                   = 'icons/obj/structures/filling_cabinets.dmi'
	icon_state             = "filingcabinet"
	material               = /decl/material/solid/metal/steel
	density                = TRUE
	anchored               = TRUE
	atom_flags             = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	obj_flags              = OBJ_FLAG_ANCHORABLE
	tool_interaction_flags = TOOL_INTERACTION_ANCHOR | TOOL_INTERACTION_DECONSTRUCT
	var/tmp/list/can_hold  = list(
		/obj/item/paper,
		/obj/item/folder,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/forensics/sample)

/obj/structure/filingcabinet/Initialize(ml, _mat, _reinf_mat)
	if(ml)
		for(var/obj/item/I in loc)
			if(is_type_in_list(I, can_hold))
				I.forceMove(src)
	. = ..()

/obj/structure/filingcabinet/attackby(obj/item/P, mob/user)
	if(is_type_in_list(P, can_hold))
		if(!user.unEquip(P, src))
			return
		add_fingerprint(user)
		to_chat(user, SPAN_NOTICE("You put [P] in [src]."))
		flick("[initial(icon_state)]-open",src)
		updateUsrDialog()
		return TRUE

	return ..()

/obj/structure/filingcabinet/interact(mob/user)
	user.set_machine(src)
	var/dat = "<HR><TABLE>"
	for(var/obj/item/P in src)
		dat += "<TR><TD><A href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</A></TD></TR>"
	dat += "</TABLE>"
	show_browser(user, "<html><head><title>[name]</title></head><body>[dat]</body></html>", "window=filingcabinet;size=350x300")

/obj/structure/filingcabinet/attack_hand(mob/user)
	return interact(user)

/obj/structure/filingcabinet/OnTopic(mob/user, href_list, datum/topic_state/state)
	if(href_list["retrieve"])
		close_browser(user, "window=filingcabinet")
		var/obj/item/P = locate(href_list["retrieve"])
		if(istype(P) && CanPhysicallyInteractWith(user, src))
			user.put_in_hands(P)
			flick("[initial(icon_state)]-open", src)
			updateUsrDialog()
			. = TOPIC_REFRESH

/////////////////////////////////////////////////////////////////
// Chest Drawer
/////////////////////////////////////////////////////////////////
/obj/structure/filingcabinet/chestdrawer
	name       = "chest drawer"
	icon_state = "chestdrawer"

/////////////////////////////////////////////////////////////////
// Wall Filling Cabinet
/////////////////////////////////////////////////////////////////
/obj/structure/filingcabinet/wallcabinet
	name               = "wall-mounted filing cabinet"
	desc               = "A filing cabinet installed into a cavity in the wall to save space. Wow!"
	icon_state         = "wallcabinet"
	obj_flags          = OBJ_FLAG_MOVES_UNSUPPORTED
	directional_offset = "{'NORTH':{'y':-32}, 'SOUTH':{'y':32}, 'EAST':{'x':-32}, 'WEST':{'x':32}}"

/////////////////////////////////////////////////////////////////
// Tall Filling Cabinet
/////////////////////////////////////////////////////////////////
/obj/structure/filingcabinet/tall
	icon_state = "tallcabinet"
