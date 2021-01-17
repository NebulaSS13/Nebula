/decl/special_role/foundation
	name = "Foundation Agent"
	antag_indicator = "hudfoundation"
	name_plural = "Foundation Agents"
	welcome_text = "<span class='info'>You are a field agent of the Cuchulain Foundation, \
	a body that specializes in taking down psychic threats. You have a free pass to anywhere \
	you like, a pistol loaded with anti-psi nullglass rounds, and a clear duty. Naturally, \
	nobody takes your employers seriously - until a day like today.</span>"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to Foundation Agents.</b>"

	flags = ANTAG_OVERRIDE_JOB | ANTAG_OVERRIDE_MOB | ANTAG_CLEAR_EQUIPMENT | ANTAG_CHOOSE_NAME | ANTAG_SET_APPEARANCE
	antaghud_indicator = "hudfoundation"
	landmark_id = "Response Team"
	hard_cap = 3
	hard_cap_round = 3
	initial_spawn_req = 1
	initial_spawn_target = 2
	min_player_age = 14
	faction = "foundation"
	id_type = /obj/item/card/id/foundation
	default_outfit = /decl/hierarchy/outfit/foundation
	id_title = "Foundation Agent"

/decl/special_role/foundation/equip(var/mob/living/carbon/human/player)
	. = ..()
	if(.)
		player.set_psi_rank(PSI_REDACTION,     3, defer_update = TRUE)
		player.set_psi_rank(PSI_COERCION,      3, defer_update = TRUE)
		player.set_psi_rank(PSI_PSYCHOKINESIS, 3, defer_update = TRUE)
		player.set_psi_rank(PSI_ENERGISTICS,   3, defer_update = TRUE)
		player.psi.update(TRUE)

/decl/hierarchy/outfit/foundation
	name = "Cuchulain Foundation Agent"
	glasses =  /obj/item/clothing/glasses/sunglasses
	uniform =  /obj/item/clothing/under/suit_jacket/charcoal
	shoes =    /obj/item/clothing/shoes/color/black
	hands =    list(/obj/item/storage/briefcase/foundation)
	l_ear =    /obj/item/radio/headset/foundation
	holster =  /obj/item/clothing/accessory/storage/holster/armpit
	id_slot =  slot_wear_id_str
