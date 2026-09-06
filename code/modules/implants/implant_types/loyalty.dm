/obj/item/implant/loyalty
	name = "loyalty implant"
	desc = "Contains a small pod of nanobots that manipulate the host's mental functions. Personnel injected with this device tend to be much more loyal to the company."
	origin_tech = @'{"materials":1,"biotech":2,"esoteric":3}'
	known = TRUE // identifiable by scanners

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

/obj/item/implant/loyalty/implanted(mob/living/victim)
	if(!ishuman(victim))
		return FALSE
	var/decl/special_role/antag_data = GET_DECL(victim.mind?.assigned_special_role)
	if(istype(antag_data) && (antag_data.flags & ANTAG_IMPLANT_IMMUNE))
		victim.visible_message(
			"\The [victim] seems to resist the implant!",
			SPAN_WARNING("You feel the corporate tendrils of [global.using_map.company_name] try to invade your mind!")
		)
		return FALSE
	else
		clear_antag_roles(victim.mind, implanted = TRUE)
		to_chat(victim, SPAN_NOTICE("You feel a surge of loyalty towards [global.using_map.company_name]."))
	BITSET(victim.hud_updateflag, IMPLOYAL_HUD)
	return TRUE

/obj/item/implanter/loyalty
	name = "implanter-loyalty"
	imp = /obj/item/implant/loyalty

/obj/item/implantcase/loyalty
	name = "glass case - 'loyalty'"
	imp = /obj/item/implant/loyalty