/decl/species
	/// This determiens how damaging allergic reactions are.
	var/allergen_damage_severity = 2.5
	/// This determines how long nonlethal effects last and how common emotes are.
	var/allergen_disable_severity = 10
	/// What type of reactions will you have? These the 'main' options and are intended to approximate anaphylactic shock at high doses.
	var/allergen_reaction         = ALLERGEN_REACTION_TOX_DMG|ALLERGEN_REACTION_OXY_DMG|ALLERGEN_REACTION_EMOTE|ALLERGEN_REACTION_PAIN|ALLERGEN_REACTION_BLURRY|ALLERGEN_REACTION_CONFUSE
	var/list/allergy_choke_emotes = list(
		/decl/emote/audible/cough,
		/decl/emote/audible/gasp,
		/decl/emote/audible/choke
	)
	var/list/allergy_faint_emotes = list(
		/decl/emote/visible/pale,
		/decl/emote/visible/shiver,
		/decl/emote/visible/twitch
	)
