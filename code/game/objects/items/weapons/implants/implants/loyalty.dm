/obj/item/implant/loyalty
	name = "loyalty implant"
	desc = "Makes you loyal or such."
	origin_tech = "{'materials':1,'biotech':2,'esoteric':3}"
	known = 1

/obj/item/implant/loyalty/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> [global.using_map.company_name] Employee Management Implant<BR>
	<b>Life:</b> Ten years.<BR>
	<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
	<HR>
	<b>Implant Details:</b><BR>
	<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
	<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
	<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/implant/loyalty/implanted(mob/M)
	if(!istype(M, /mob/living/carbon/human))
		return FALSE
	var/mob/living/carbon/human/H = M
	var/decl/special_role/antag_data = ispath(H.mind.assigned_special_role, /decl/special_role) && GET_DECL(H.mind.assigned_special_role)
	if(antag_data && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		H.visible_message("[H] seems to resist the implant!", "You feel the corporate tendrils of [global.using_map.company_name] try to invade your mind!")
		return FALSE
	else
		clear_antag_roles(H.mind, 1)
		to_chat(H, "<span class='notice'>You feel a surge of loyalty towards [global.using_map.company_name].</span>")
	return TRUE

/obj/item/implanter/loyalty
	name = "implanter-loyalty"
	imp = /obj/item/implant/loyalty

/obj/item/implantcase/loyalty
	name = "glass case - 'loyalty'"
	imp = /obj/item/implant/loyalty