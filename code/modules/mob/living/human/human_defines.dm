/mob/living/human

	ai = /datum/mob_controller/human
	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY
	weather_sensitive = TRUE

	/// If true, the next icon update will also regenerate the body.
	var/regenerate_body_icon = FALSE
	/// Skin tone
	var/skin_tone = 0
	/// multiplies melee combat damage
	var/damage_multiplier = 1
	var/list/worn_underwear = list()
	var/list/background_info = list()
	var/icon/stand_icon = null
	/// Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()
	var/voice = ""
	/// Used for determining if we need to process all organs or just some or even none.
	var/last_dam = -1
	var/mob/remoteview_target = null
	var/hand_blood_color
	var/list/flavor_texts = list()
	/// We are a robutt.
	var/full_prosthetic
	/// Number of robot limbs.
	var/robolimb_count = 0
	/// The world_time where an unarmed attack was done
	var/last_attack = 0
	/// Total level of visualy impairing items
	var/equipment_tint_total = 0
	/// Darksight modifier from equipped items
	var/equipment_darkness_modifier
	/// Extra vision flags from equipped items
	var/equipment_vision_flags
	/// Max see invibility level granted by equipped items
	var/equipment_see_invis
	/// Eye prescription granted by equipped items
	var/equipment_prescription
	var/equipment_light_protection
	/// Extra overlays from equipped items
	var/list/equipment_overlays = list()
	var/datum/mil_branch/char_branch = null
	var/datum/mil_rank/char_rank = null
	/// default unarmed attack
	var/decl/natural_attack/default_attack
	/// machine that is currently applying visual effects to this mob. Only used for camera monitors currently.
	var/obj/machinery/machine_visual
	var/shock_stage
	var/rounded_shock_stage
	/// var for caching last pain calc to avoid looping through organs over and over and over again
	var/last_pain
	var/vital_organ_missing_time
	/// Used to look up records when the client is logged out.
	var/comments_record_id
	/// Active emote/pose - appended to examine
	var/pose = null
	/// Reagent holder for bloodstream reagents
	var/datum/reagents/metabolism/bloodstr
	/// Reagent holder for contact reagents
	var/datum/reagents/metabolism/touching
	/// Should this mob ignore radiation?
	var/ignore_rads = FALSE
	/// Whether the mob is performing cpr or not.
	var/performing_cpr = FALSE
	/// Cooldown tracker for throwing up.
	var/lastpuke = 0
	/// Reference to the tank we are currently breathing from.
	var/obj/item/tank/internal
	/// Contains environment tolerances and language information, along with a lot of other stuff, usually set during Initialize().
	var/decl/species/species
