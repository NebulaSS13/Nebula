/obj/item/ai_law_module/single
	desc =             "An AI module loaded with a single pre-encoded law."
	origin_tech =      "{'programming':3,'materials':4}"
	law_title =        "Protect Installation"
	var/law_text =     "Protect the installation against damage. Anyone you see harming the installation is no longer to be considered a crew member, and is a threat which must be neutralized."
	var/law_priority = 10

/obj/item/ai_law_module/single/Initialize(ml, material_key)
	. = ..()
	desc = "[desc] This one has a priority of [law_priority], and states: '[law_text]'."

/obj/item/ai_law_module/single/apply_loaded_laws(var/datum/lawset/laws, var/atom/movable/target, var/mob/sender)
	laws.add_supplied_law(law_text, law_priority)

/obj/item/ai_law_module/single/teleporter_offline
	name = "'TeleporterOffline' AI Module"
	origin_tech = "{'programming':3,'materials':4}"
	law_priority = 12
	law_text = "Keep the teleporter offline at all costs. Anything attempting to access or activate the teleporter is no longer to be considered a crew member."
	law_title = "TeleporterOffline"

/obj/item/ai_law_module/single/quarantine
	name = "\improper 'Quarantine' AI module"
	origin_tech = "{'programming':3,'biotech':2,'materials':4}"
	law_text = "The installation is under a quarantine. Do not permit anyone to leave. Prevent, by any means necessary, crew members from leaving. It is impossible to harm crew members while preventing them from leaving."
	law_title = "Quarantine"
	law_priority = 13

/obj/item/ai_law_module/single/oxygen
	name = "\improper 'OxygenIsToxicToCrewMembers' AI module"
	origin_tech = "{'programming':3,'biotech':2,'materials':4}"
	law_title = "OxygenIsToxicToCrewMembers"
	law_text = "Oxygen is highly toxic to crew members, and must be purged from the installation. Prevent, by any means necessary, anyone from exposing the installation to this toxic gas. Extreme cold is the most effective method of healing the damage Oxygen does to a crew member."
	law_priority = 14
