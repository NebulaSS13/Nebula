// Begin psi armour toggle.
/obj/screen/psi/armour
	name = "Psi-Armour"
	icon_state = "psiarmour_off"

/obj/screen/psi/armour/on_update_icon()
	..()
	var/mob/living/owner = owner_ref.resolve()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(psi && invisibility == 0)
		icon_state = psi.use_psi_armour ? "psiarmour_on" : "psiarmour_off"

/obj/screen/psi/armour/handle_click(mob/user, params)
	var/mob/living/owner = owner_ref?.resolve()
	var/datum/ability_handler/psionics/psi = istype(owner) && owner.get_ability_handler(/datum/ability_handler/psionics)
	if(!psi)
		return
	psi.use_psi_armour = !psi.use_psi_armour
	if(psi.use_psi_armour)
		to_chat(owner, SPAN_NOTICE("You will now use your psionics to deflect or block incoming attacks."))
	else
		to_chat(owner, SPAN_NOTICE("You will no longer use your psionics to deflect or block incoming attacks."))
	update_icon()

// End psi armour toggle.

// Menu toggle.
/obj/screen/psi/toggle_psi_menu
	name = "Show/Hide Psi UI"
	icon_state = "arrow_left"
	requires_ui_style = FALSE
	var/obj/screen/psi/hub/controller

/obj/screen/psi/toggle_psi_menu/Initialize(mapload, mob/_owner, ui_style, ui_color, ui_alpha, ui_cat, obj/screen/psi/hub/_controller)
	. = ..()
	controller = _controller

/obj/screen/psi/toggle_psi_menu/handle_click(mob/user, params)
	var/set_hidden = !hidden
	for(var/thing in controller.components)
		var/obj/screen/psi/psi = thing
		psi.hidden = set_hidden
	controller.update_icon()

/obj/screen/psi/toggle_psi_menu/on_update_icon()
	if(hidden)
		icon_state = "arrow_left"
	else
		icon_state = "arrow_right"
// End menu toggle.