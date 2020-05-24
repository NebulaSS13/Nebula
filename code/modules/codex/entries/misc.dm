/datum/codex_entry/suitcooler
	associated_paths = list(/obj/item/suit_cooling_unit)
	mechanics_text = "You may wear this instead of your backpack to cool yourself down. It is commonly used by full-body prosthetic users, \
	as it allows them to go into low pressure environments for more than few seconds without overhating. It runs off energy provided by internal power cell. \
	Remember to turn it on by clicking it when it's your in your hand before you put it on."

/datum/codex_entry/barsign
	associated_paths = list(/obj/structure/sign/double/barsign)
	mechanics_text = "If your ID has bar access, you may swipe it on this sign to alter its display."

/datum/codex_entry/sneakies
	associated_paths = list(/obj/item/clothing/shoes/dress/sneakies)
	lore_text =  "Originally designed to confuse Terran troops on the swamp moon of Nabier XI, where they were proven somewhat effective. Not bad on a space vessel, either."

/datum/codex_entry/moneygun
	associated_paths = list(/obj/item/gun/launcher/money)
	mechanics_text = "Load money into the cannon by picking it up with the gun, or feeding it directly by hand. Use in your hand to configure how much money you want to fire per shot."
	lore_text = "These devices were invented several centuries ago and are a distinctly human cultural infection. They have produced knockoffs as timeless and as insipid as the potato gun and the paddle ball, showing up in all corners of the galaxy. The Money Cannon variation is noteworthy for its sturdiness and build quality, but is, at the end of the day, just another knockoff of the ancient originals."

/datum/codex_entry/moneygun/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text)
	. = ..()
	antag_text = "Sliding a cryptographic sequencer into the receptacle will short the motors and override their speed. If you set the cannon to dispense 100 units or more, this might make a handy weapon."

/datum/codex_entry/textbook
	associated_paths = list(/obj/item/book/skill)
	associated_strings = list("textbook","skill book")
	lore_text = "Education, written down and made overly expensive."
	mechanics_text = "Textbooks provide <span codexlink='Skills (category)'>skill</span> buffs, raising the relevant skill by one level. In order to use textbook, you must have the matching skill that the textbook teaches, at the level it can buff. To use a textbook, simply hold it in your active hand and click it. You must then wait for a short period of time, after which you will have the skill buff indefinitely. However, the skill buff will be removed the moment the textbook is closed (used again) or removed from your hand in any way (dropped, put in a container, destroyed, etc). This process can be repeated without consequence, though only one textbook can be used at any one time. <BR><BR> \
	<h4>Custom Skill Books</h4> \
	Those with Master level <span codexlink='Literacy (skill)'>Literacy</span> can create a textbook with the use of an autobinder and a suitable writing implement. This works much the same way as writing a normal book(use pen on book) but rather than manually writing the contents, the Skill option is selected from the menu. To imbue the book with any given skill, the writer must possess the relevant skill at the level they desire. After successfully selecting the skill and level, the writer must then repeatedly use the pen on the book until it is complete. Only once complete can it be used as a skill book. <b>Important note</b>: You may only write two skill books during a round. If a textbook you wrote gets destroyed, it does not enable you to write another to replace it."