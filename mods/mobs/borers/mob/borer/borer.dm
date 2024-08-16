/mob/living/simple_animal/borer
	name = "cortical borer"
	real_name = "cortical borer"
	icon = 'mods/mobs/borers/icons/borer.dmi'
	desc = "A small, quivering sluglike creature."
	speak_emote = list("chirrups")
	response_help_3p = "$USER$ pokes $TARGET$."
	response_help_1p = "You poke $TARGET$."
	response_disarm =  "prods"
	response_harm =    "stamps on"
	base_movement_delay = 2

	a_intent = I_HURT
	status_flags = CANPUSH
	natural_weapon = /obj/item/natural_weapon/bite/weak
	pass_flags = PASS_FLAG_TABLE
	universal_understand = TRUE
	holder_type = /obj/item/holder/borer
	mob_size = MOB_SIZE_SMALL
	bleed_colour = "#816e12"
	ai = /datum/mob_controller/borer

	var/static/list/chemical_types = list(
		"anti-trauma" =  /decl/material/liquid/brute_meds,
		"amphetamines" = /decl/material/liquid/amphetamines,
		"painkillers" =  /decl/material/liquid/painkillers
	)

	var/generation = 1
	var/static/list/borer_names = list(
		"Primary", "Secondary", "Tertiary", "Quaternary", "Quinary", "Senary",
		"Septenary", "Octonary", "Novenary", "Decenary", "Undenary", "Duodenary",
		)

	var/chemicals = 10                      // Chemicals used for reproduction and spitting neurotoxin.
	var/truename                            // Name used for brainworm-speak.
	var/controlling                         // Used in human death check.
	var/docile = FALSE                      // Sugar can stop borers from acting.
	var/has_reproduced                      // Whether or not the borer has reproduced, for objective purposes.
	var/roundstart                          // Whether or not this borer has been mapped and should not look for a player initially.
	var/neutered                            // 'borer lite' mode - fewer powers, less hostile to the host.
	var/mob/living/human/host        // Human host for the brain worm.
	var/mob/living/captive_brain/host_brain // Used for swapping control of the body back and forth.

/datum/mob_controller/borer
	emote_hear = list("chirrups")
	do_wander = FALSE
	can_escape_buckles = TRUE

/obj/item/holder/borer
	origin_tech = @'{"biotech":6}'

/mob/living/simple_animal/borer/roundstart
	roundstart = TRUE

/mob/living/simple_animal/borer/symbiote
	name = "symbiote"
	real_name = "symbiote"
	neutered = TRUE

/mob/living/simple_animal/borer/Login()
	. = ..()
	if(mind && !neutered)
		var/decl/special_role/borer/borers = GET_DECL(/decl/special_role/borer)
		borers.add_antagonist(mind)

/mob/living/simple_animal/borer/Initialize(var/mapload, var/gen=1)

	. = ..()

	add_language(/decl/language/corticalborer)
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	generation = gen
	set_borer_name()

	if(!roundstart)
		request_player()

/mob/living/simple_animal/borer/proc/set_borer_name()
	truename = "[borer_names[min(generation, borer_names.len)]] [random_id("borer[generation]", 1000, 9999)]"

/mob/living/simple_animal/borer/handle_vision()
	. = ..()
	set_status(STAT_BLIND,  host ? GET_STATUS(host, STAT_BLIND)  : 0)
	set_status(STAT_BLURRY, host ? GET_STATUS(host, STAT_BLURRY) : 0)

/mob/living/simple_animal/borer/handle_disabilities()
	. = ..()
	if(host)
		if(host.has_genetic_condition(GENE_COND_BLINDED))
			add_genetic_condition(GENE_COND_BLINDED)
		else
			remove_genetic_condition(GENE_COND_BLINDED)
		if(host.has_genetic_condition(GENE_COND_DEAFENED))
			add_genetic_condition(GENE_COND_DEAFENED)
		else
			remove_genetic_condition(GENE_COND_DEAFENED)
	else
		remove_genetic_condition(GENE_COND_BLINDED)
		remove_genetic_condition(GENE_COND_DEAFENED)

/mob/living/simple_animal/borer/handle_living_non_stasis_processes()
	. = ..()
	if(!.)
		return FALSE

	if(!host || host.stat)
		return

	if(prob(host.get_damage(BRAIN)/20))
		INVOKE_ASYNC(host, TYPE_PROC_REF(/mob, say), "*[pick(list("blink","blink_r","choke","aflap","drool","twitch","twitch_v","gasp"))]")

	if(stat)
		return

	if(host.reagents.has_reagent(/decl/material/liquid/nutriment/sugar))
		if(!docile)
			if(controlling)
				to_chat(host, SPAN_NOTICE("You feel the soporific flow of sugar in your host's blood, lulling you into docility."))
			else
				to_chat(src, SPAN_NOTICE("You feel the soporific flow of sugar in your host's blood, lulling you into docility."))
			docile = TRUE
	else
		if(docile)
			if(controlling)
				to_chat(host, SPAN_NOTICE("You shake off your lethargy as the sugar leaves your host's blood."))
			else
				to_chat(src, SPAN_NOTICE("You shake off your lethargy as the sugar leaves your host's blood."))
			docile = FALSE

	if(chemicals < 250 && host.nutrition >= (neutered ? 200 : 50))
		host.nutrition--
		chemicals++
	if(controlling)
		if(neutered || docile)
			if(docile)
				to_chat(host, SPAN_NOTICE("You are feeling far too docile to continue controlling your host..."))
			host.release_control()
			return
		if(prob(5))
			host.take_damage(0.1, BRAIN)

/mob/living/simple_animal/borer/Stat()
	. = ..()
	statpanel("Status")

	if(SSevac.evacuation_controller)
		var/eta_status = SSevac.evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)

	if (client.statpanel == "Status")
		stat("Chemicals", chemicals)

/mob/living/simple_animal/borer/proc/detach_from_host()

	if(!host || !controlling) return

	if(ishuman(host))
		var/mob/living/human/H = host
		var/obj/item/organ/external/head = GET_EXTERNAL_ORGAN(H, BP_HEAD)
		LAZYREMOVE(head.implants, src)

	controlling = FALSE

	host.remove_language(/decl/language/corticalborer)
	host.verbs -= /mob/living/proc/release_control
	host.verbs -= /mob/living/proc/punish_host
	host.verbs -= /mob/living/proc/spawn_larvae

	if(host_brain)

		// these are here so bans and multikey warnings are not triggered on the wrong people when ckey is changed.
		// computer_id and IP are not updated magically on their own in offline mobs -walter0o

		// host -> self
		var/h2s_id = host.computer_id
		var/h2s_ip= host.lastKnownIP
		host.computer_id = null
		host.lastKnownIP = null

		src.ckey = host.ckey

		if(!src.computer_id)
			src.computer_id = h2s_id

		if(!host_brain.lastKnownIP)
			src.lastKnownIP = h2s_ip

		// brain -> host
		var/b2h_id = host_brain.computer_id
		var/b2h_ip= host_brain.lastKnownIP
		host_brain.computer_id = null
		host_brain.lastKnownIP = null

		host.ckey = host_brain.ckey

		if(!host.computer_id)
			host.computer_id = b2h_id

		if(!host.lastKnownIP)
			host.lastKnownIP = b2h_ip

	qdel(host_brain)

#define COLOR_BORER_RED "#ff5555"
/mob/living/simple_animal/borer/proc/set_ability_cooldown(var/amt)
	set_special_ability_cooldown(amt)
	var/datum/hud/borer/borer_hud = hud_used
	if(istype(borer_hud))
		for(var/obj/thing in borer_hud.borer_hud_elements)
			thing.color = COLOR_BORER_RED
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal/borer, reset_ui_callback)), amt)
#undef COLOR_BORER_RED

/mob/living/simple_animal/borer/proc/leave_host()

	var/datum/hud/borer/borer_hud = hud_used
	if(istype(borer_hud))
		for(var/obj/thing in borer_hud.borer_hud_elements)
			thing.alpha = 0
			thing.set_invisibility(INVISIBILITY_ABSTRACT)

	if(!host) return

	if(host.mind)
		var/decl/special_role/borer/borers = GET_DECL(/decl/special_role/borer)
		borers.remove_antagonist(host.mind)

	dropInto(host.loc)

	reset_view(null)
	machine = null

	host.reset_view(null)
	host.machine = null
	host.status_flags &= ~PASSEMOTES
	host = null
	return

//Procs for grabbing players.
/mob/living/simple_animal/borer/proc/request_player()
	var/decl/ghosttrap/G = GET_DECL(/decl/ghosttrap/cortical_borer)
	G.request_player(src, "A cortical borer needs a player.")

/mob/living/simple_animal/borer/flash_eyes(intensity, override_blindness_check, affect_silicon, visual, type)
	intensity *= 1.5
	. = ..()