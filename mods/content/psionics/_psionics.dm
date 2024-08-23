/decl/modpack/psionics
	name = "Psionics Content"
	dreams = list("the Foundation", "nullglass")

/decl/modpack/psionics/get_player_panel_options(var/mob/M)
	. = list("<b>Psionics:</b><br/>")
	if(isliving(M))
		var/datum/ability_handler/psionics/psi = M.get_ability_handler(/datum/ability_handler/psionics)
		if(psi)
			. += "<a href='byond://?src=\ref[psi];remove_psionics=1'>Remove psionics.</a><br/><br/>"
			. += "<a href='byond://?src=\ref[psi];trigger_psi_latencies=1'>Trigger latencies.</a><br/>"
		. += "<table width = '100%'>"
		for(var/faculty in list(PSI_COERCION, PSI_PSYCHOKINESIS, PSI_REDACTION, PSI_ENERGISTICS))
			var/decl/psionic_faculty/faculty_decl = SSpsi.get_faculty(faculty)
			var/faculty_rank = psi ? psi.get_rank(faculty) : 0
			. += "<tr><td><b>[faculty_decl.name]</b></td>"
			for(var/i = 1 to LAZYLEN(global.psychic_ranks_to_strings))
				var/psi_title = global.psychic_ranks_to_strings[i]
				if(i == faculty_rank)
					psi_title = "<b>[psi_title]</b>"
				. += "<td><a href='byond://?src=\ref[M.mind];set_psi_faculty_rank=[i];set_psi_faculty=[faculty]'>[psi_title]</a></td>"
			. += "</tr>"
		. += "</table>"
	else
		. += "Only available for living mobs, sorry."
	. = jointext(., null)

/datum/preferences/copy_to(mob/living/human/character, is_preview_copy = FALSE)
	character = ..()
	var/datum/ability_handler/psionics/psi = !is_preview_copy && istype(character) && character.get_ability_handler(/datum/ability_handler/psionics)
	if(psi)
		psi.update()

/decl/ability/can_use_ability(mob/user, list/metadata, silent = FALSE)
	. = ..()
	if(. && is_supernatural)
		var/spell_leech = user.disrupts_psionics()
		if(spell_leech)
			if(!silent)
				to_chat(user, SPAN_WARNING("You try to marshal your energy, but find it leeched away by \the [spell_leech]!"))
			return FALSE
