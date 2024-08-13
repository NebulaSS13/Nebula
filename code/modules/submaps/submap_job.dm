/datum/job/submap
	title = "Survivor"
	supervisors = "your conscience"
	account_allowed = FALSE
	latejoin_at_spawnpoints = TRUE
	announced = FALSE
	create_record = FALSE
	total_positions = 4
	outfit_type = /decl/outfit/job/survivor
	hud_icon = "hudblank"
	available_by_default = FALSE
	allowed_ranks = null
	allowed_branches = null
	skill_points = 25
	autoset_department = FALSE
	max_skill = list(
		SKILL_LITERACY =     SKILL_MAX,
		SKILL_FINANCE =      SKILL_MAX,
		SKILL_EVA =          SKILL_MAX,
		SKILL_MECH =         SKILL_MAX,
		SKILL_PILOT =        SKILL_MAX,
		SKILL_HAULING =      SKILL_MAX,
		SKILL_COMPUTER =     SKILL_MAX,
		SKILL_BOTANY =       SKILL_MAX,
		SKILL_COOKING =      SKILL_MAX,
		SKILL_COMBAT =       SKILL_MAX,
		SKILL_WEAPONS =      SKILL_MAX,
		SKILL_FORENSICS =    SKILL_MAX,
		SKILL_CONSTRUCTION = SKILL_MAX,
		SKILL_ELECTRICAL =   SKILL_MAX,
		SKILL_ATMOS =        SKILL_MAX,
		SKILL_ENGINES =      SKILL_MAX,
		SKILL_DEVICES =      SKILL_MAX,
		SKILL_SCIENCE =      SKILL_MAX,
		SKILL_MEDICAL =      SKILL_MAX,
		SKILL_ANATOMY =      SKILL_MAX,
		SKILL_CHEMISTRY =    SKILL_MAX
	)

	var/info = "You have survived a terrible disaster. Make the best of things that you can."
	var/rank
	var/branch
	var/list/spawnpoints
	var/datum/submap/owner
	var/list/blacklisted_species = list()
	var/list/whitelisted_species = list()

/decl/outfit/job/survivor
	name = "Job - Survivor"

/datum/job/submap/New(var/datum/submap/_owner, var/abstract_job = FALSE)

	if(islist(whitelisted_species) && !length(whitelisted_species))
		whitelisted_species |= SSmodpacks.default_submap_whitelisted_species
	if(islist(blacklisted_species) && !length(blacklisted_species))
		blacklisted_species |= SSmodpacks.default_submap_blacklisted_species

	if(!abstract_job)
		spawnpoints = list()
		owner = _owner
		..()

/datum/job/submap/is_species_allowed(var/decl/species/S)
	if(LAZYLEN(whitelisted_species) && !(S.name in whitelisted_species))
		return FALSE
	if(S.name in blacklisted_species)
		return FALSE
	if(owner && owner.archetype)
		if(LAZYLEN(owner.archetype.whitelisted_species) && !(S.name in owner.archetype.whitelisted_species))
			return FALSE
		if(S.name in owner.archetype.blacklisted_species)
			return FALSE
	return TRUE

/datum/job/submap/is_restricted(var/datum/preferences/prefs, var/feedback)
	var/decl/species/S = get_species_by_key(prefs.species)
	if(LAZYACCESS(minimum_character_age, S.get_root_species_name()) && (prefs.get_character_age() < minimum_character_age[S.get_root_species_name()]))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age[S.get_root_species_name()]].</span>")
		return TRUE
	if(LAZYLEN(whitelisted_species) && !(prefs.species in whitelisted_species))
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor].</span>")
		return TRUE
	if(prefs.species in blacklisted_species)
		to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted as [title] on \a [owner.archetype.descriptor].</span>")
		return TRUE
	if(owner && owner.archetype)
		if(LAZYLEN(owner.archetype.whitelisted_species) && !(prefs.species in owner.archetype.whitelisted_species))
			to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor].</span>")
			return TRUE
		if(prefs.species in owner.archetype.blacklisted_species)
			to_chat(feedback, "<span class='boldannounce'>Your current species, [prefs.species], is not permitted on \a [owner.archetype.descriptor].</span>")
			return TRUE
	return FALSE

/datum/job/submap/check_is_active(var/mob/M)
	. = (..() && M.faction == owner.name)

/datum/job/submap/create_cash_on_hand(var/mob/living/human/H, var/datum/money_account/M)
	. = get_total_starting_money(H)
	if(. > 0)
		var/obj/item/cash/cash = new
		cash.adjust_worth(.)
		H.equip_to_storage_or_put_in_hands(cash)
