/obj/screen/psi
	icon = 'mods/content/psionics/icons/psi.dmi'
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/psi/Initialize(var/ml, var/mob/_owner)
	. = ..()
	owner = _owner
	forceMove(null)
	update_icon()

/obj/screen/psi/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()

/obj/screen/psi/on_update_icon()
	if(hidden)
		set_invisibility(INVISIBILITY_ABSTRACT)
	else
		set_invisibility(INVISIBILITY_NONE)