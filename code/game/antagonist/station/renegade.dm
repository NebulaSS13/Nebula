/decl/special_role/renegade
	name = "Renegade"
	name_plural = "Renegades"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/submap)
	restricted_jobs = list()
	welcome_text = "Something's going to go wrong today, you can just feel it. You're paranoid, you've got a gun, and you're going to survive."
	antag_text = "You are a <b>minor</b> antagonist! Within the rules, \
		try to protect yourself and what's important to you. You aren't here to <i>cause</i> trouble, \
		you're just willing (and equipped) to go to extremes to <b>stop</b> it. \
		Your job is to oppose the other antagonists, should they threaten you, in ways that aren't quite legal. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"

	flags = ANTAG_SUSPICIOUS | ANTAG_IMPLANT_IMMUNE | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	hard_cap = 3
	hard_cap_round = 5

	initial_spawn_req = 1
	initial_spawn_target = 3
	antaghud_indicator = "hud_renegade"
	skill_setter = /datum/antag_skill_setter/station

	var/list/spawn_guns = list(
		/obj/item/gun/projectile/revolver/lasvolver,
		/obj/item/gun/energy/gun,
		/obj/item/gun/energy/crossbow,
		/obj/item/gun/energy/pulse_pistol,
		/obj/item/gun/projectile/automatic/smg,
		/obj/item/gun/projectile/pistol/holdout,
		/obj/item/gun/projectile/revolver,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn
		)

/decl/special_role/renegade/create_objectives(var/datum/mind/player)

	if(!..())
		return

	var/datum/objective/survive/survive = new
	survive.owner = player
	player.objectives |= survive

/decl/special_role/renegade/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		var/gun_type = pick(spawn_guns)
		if(islist(gun_type))
			gun_type = pick(gun_type)
		var/obj/item/gun = new gun_type(get_turf(player))
		if(player.equip_to_storage(gun))
			return
		if(player.equip_to_appropriate_slot(gun))
			return
		player.put_in_hands(gun)
