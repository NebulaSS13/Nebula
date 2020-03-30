/decl/modpack/psionics
	name = "Psionics Content"
	dreams = list("the Foundation", "nullglass")

/decl/modpack/psionics/get_player_panel_options(var/mob/M)
	. = list("<b>Psionics:</b><br/>")
	if(isliving(M))
		var/mob/living/psyker = M
		if(psyker.psi)
			. += "<a href='?src=\ref[psyker.psi];remove_psionics=1'>Remove psionics.</a><br/><br/>"
			. += "<a href='?src=\ref[psyker.psi];trigger_psi_latencies=1'>Trigger latencies.</a><br/>"
		. += "<table width = '100%'>"
		for(var/faculty in list(PSI_COERCION, PSI_PSYCHOKINESIS, PSI_REDACTION, PSI_ENERGISTICS))
			var/decl/psionic_faculty/faculty_decl = SSpsi.get_faculty(faculty)
			var/faculty_rank = psyker.psi ? psyker.psi.get_rank(faculty) : 0
			. += "<tr><td><b>[faculty_decl.name]</b></td>"
			for(var/i = 1 to LAZYLEN(GLOB.psychic_ranks_to_strings))
				var/psi_title = GLOB.psychic_ranks_to_strings[i]
				if(i == faculty_rank)
					psi_title = "<b>[psi_title]</b>"
				. += "<td><a href='?src=\ref[psyker.mind];set_psi_faculty_rank=[i];set_psi_faculty=[faculty]'>[psi_title]</a></td>"
			. += "</tr>"
		. += "</table>"
	else
		. += "Only available for living mobs, sorry."
	. = jointext(., null)