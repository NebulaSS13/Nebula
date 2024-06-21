/datum/codex_entry/deity
	abstract_type = /datum/codex_entry/deity

/datum/codex_entry/deity/altar
	associated_paths = list(/obj/structure/deity/altar)
	mechanics_text = "To place someone upon the altar, first have them in an aggressive grab and click the altar while adjacent."
	antag_text = "This structure anchors your deity within this realm, granting them additional power to influence it and empower their followers. Additionally, using it as a focus for their powers, they can convert someone laying on top of the altar.<br>"
	disambiguator = "occult"

/datum/codex_entry/deity/blood_forge
	associated_paths = list(/obj/structure/deity/blood_forge)
	antag_text = "Allows creation of special items by feeding your blood into it. Only usable by cultists of the aligned deity."
	disambiguator = "occult"

/datum/codex_entry/deity/gateway
	associated_paths = list(/obj/structure/deity/gateway)
	antag_text = "Stand within the gateway to be transported to an unknown dimension and transformed into a flaming Starborn, a mysterious Blueforged or a subtle Shadowling."
	disambiguator = "occult"

/datum/codex_entry/deity/radiant_statue
	associated_paths = list(/obj/structure/deity/radiant_statue)
	antag_text = "Allows storage of power if cultists are nearby. This stored power can be expended to charge Starlight items."
	disambiguator = "occult"

/datum/codex_entry/deity/blood_forge/starlight
	associated_paths = list(/obj/structure/deity/blood_forge/starlight)
	antag_text = "Allows creation of special Starlight items. Only usable by cultists of the aligned deity. Use of this powerful forge will inflict burns."
	disambiguator = "occult"

/datum/codex_entry/deity/wizard_recharger
	associated_paths = list(/obj/structure/deity/wizard_recharger)
	antag_text = "A well of arcane power. When charged, a cultist may absorb this power to refresh their spells."
	disambiguator = "occult"

/datum/codex_entry/deity/pylon
	associated_paths = list(/obj/structure/deity/pylon)
	antag_text = "Serves as a conduit for a deity to speak through, making their will known in this dimension to any who hear it."
	disambiguator = "occult"