/obj/item/gun/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself."
	icon = 'icons/obj/guns/staff.dmi'
	icon_state = ICON_STATE_WORLD
	fire_sound = 'sound/weapons/emitter.ogg'
	obj_flags =  OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_LOWER_BODY|SLOT_BACK
	w_class = ITEM_SIZE_LARGE
	origin_tech = null
	receiver = /obj/item/firearm_component/receiver/energy/staff
	barrel = /obj/item/firearm_component/barrel/energy/staff
	var/required_antag_type = /decl/special_role/wizard

/obj/item/gun/staff/special_check(var/mob/user)
	if(required_antag_type)
		var/decl/special_role/antag = GET_DECL(required_antag_type)
		if(user.mind && !antag.is_antagonist(user.mind))
			to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
			return 0
	return ..()

/obj/item/gun/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	receiver = /obj/item/firearm_component/receiver/energy/animate
	barrel = /obj/item/firearm_component/barrel/energy/animate

/obj/item/gun/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/guns/focus_staff.dmi'
	barrel = /obj/item/firearm_component/barrel/energy/staff/beacon/force
