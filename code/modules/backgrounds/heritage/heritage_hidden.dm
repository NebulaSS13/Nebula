/decl/background_detail/heritage/hidden
	abstract_type = /decl/background_detail/heritage/hidden
	description = "This is a hidden cultural detail. If you can see this, please report it on the tracker."
	hidden = TRUE
	hidden_from_codex = TRUE

/decl/background_detail/heritage/hidden/alium
	name = "Alien Humanoid"
	language = /decl/language/alium
	secondary_langs = null
	uid = "heritage_alium"

/decl/background_detail/heritage/hidden/cultist
	name = "Blood Cultist"
	language = /decl/language/cultcommon
	uid = "heritage_bloodcult"

/decl/background_detail/heritage/hidden/cultist/get_random_name()
	return "[pick("Anguished", "Blasphemous", "Corrupt", "Cruel", "Depraved", "Despicable", "Disturbed", "Exacerbated", "Foul", "Hateful", "Inexorable", "Implacable", "Impure", "Malevolent", "Malignant", "Malicious", "Pained", "Profane", "Profligate", "Relentless", "Resentful", "Restless", "Spiteful", "Tormented", "Unclean", "Unforgiving", "Vengeful", "Vindictive", "Wicked", "Wronged")] [pick("Apparition", "Aptrgangr", "Dis", "Draugr", "Dybbuk", "Eidolon", "Fetch", "Fylgja", "Ghast", "Ghost", "Gjenganger", "Haint", "Phantom", "Phantasm", "Poltergeist", "Revenant", "Shade", "Shadow", "Soul", "Spectre", "Spirit", "Spook", "Visitant", "Wraith")]"

/decl/background_detail/heritage/hidden/monkey
	name = "Test Subject"
	language = /decl/language/human/monkey
	uid = "heritage_testmonkey"
