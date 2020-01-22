/datum/codex_entry/suitcooler
	associated_paths = list(/obj/item/suit_cooling_unit)
	mechanics_text = "You may wear this instead of your backpack to cool yourself down. It is commonly used by full-body prosthetic users, \
	as it allows them to go into low pressure environments for more than few seconds without overhating. It runs off energy provided by internal power cell. \
	Remember to turn it on by clicking it when it's your in your hand before you put it on."

/datum/codex_entry/barsign
	associated_paths = list(/obj/structure/sign/double/barsign)
	mechanics_text = "If your ID has bar access, you may swipe it on this sign to alter its display."

/datum/codex_entry/sneakies
	associated_paths = list(/obj/item/clothing/shoes/laceup/sneakies)
	lore_text =  "Originally designed to confuse Terran troops on the swamp moon of Nabier XI, where they were proven somewhat effective. Not bad on a space vessel, either."

/datum/codex_entry/moneygun
	associated_paths = list(/obj/item/gun/launcher/money)
	mechanics_text = "Load money into the cannon by picking it up with the gun, or feeding it directly by hand. Use in your hand to configure how much money you want to fire per shot."
	lore_text = "These devices were invented several centuries ago and are a distinctly human cultural infection. They have produced knockoffs as timeless and as insipid as the potato gun and the paddle ball, showing up in all corners of the galaxy. The Money Cannon variation is noteworthy for its sturdiness and build quality, but is, at the end of the day, just another knockoff of the ancient originals."

/datum/codex_entry/moneygun/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text)
	. = ..()
	antag_text = "Sliding a cryptographic sequencer into the receptacle will short the motors and override their speed. If you set the cannon to dispense 100 [GLOB.using_map.local_currency_name] or more, this might make a handy weapon."

/datum/codex_entry/tray
	associated_paths = list(/obj/item/storage/tray)
	associated_strings = list("tray","platter")
	lore_text = "A simple tool allowing for multiple items to be carried at once while keeping the load more accessible than a box or bag. Used primarily by hospitality workers and other service staff."
	mechanics_text = "The tray works functionally the same as a <span codexlink='container'>container</span> used for collecting items. The only difference is that if you put it down on a table, all the items are placed on the table. If you drop the tray in any other way or hit someone with it, all the items it holds will fall off and scatter. You can also examine a tray to see the contents."