/obj/item/firearm_component/receiver/energy/staff
	name = "staff handle"
	max_shots = 5
	self_recharge = 1
	charge_meter = 0
	max_shots = 10
	//fire_sound = 'sound/weapons/emitter.ogg'
	var/required_antag_type = /decl/special_role/wizard

/*
/obj/item/gun/staff/special_check(var/mob/user)
	if(required_antag_type)
		var/decl/special_role/antag = decls_repository.get_decl(required_antag_type)
		if(user.mind && !antag.is_antagonist(user.mind))
			to_chat(usr, "<span class='warning'>You focus your mind on \the [src], but nothing happens!</span>")
			return 0
	return ..()
*/

/obj/item/firearm_component/receiver/energy/staff/beacon
	name = "glowing staff handle"
	self_recharge = 0
	required_antag_type = /decl/special_role/godcultist

/obj/item/firearm_component/receiver/energy/staff/animate
	name = "writhing staff handle"
	max_shots = 5
	recharge_time = 5 SECONDS

/*
/obj/item/gun/staff/handle_click_empty()
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(get_turf(src), 'sound/effects/sparks1.ogg', 100, 1)
*/
