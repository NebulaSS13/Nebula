
/decl/archaeological_find/remains
	item_type = "humanoid remains"
	modification_flags = XENOFIND_APPLY_PREFIX | XENOFIND_REPLACE_ICON
	responsive_reagent = /decl/material/solid/carbon
	new_icon = 'icons/effects/blood.dmi'
	new_icon_state = "remains"
	possible_types = list(/obj/item)
	var/list/descs = list("They appear almost human.",\
	"They are contorted in a most gruesome way.",\
	"They look almost peaceful.",\
	"The bones are yellowing and old, but remarkably well preserved.",\
	"The bones are scored by numerous burns and partially melted.",\
	"The are battered and broken, in some cases less than splinters are left.",\
	"The mouth is wide open in a death rictus, the victim would appear to have died screaming.")

/decl/archaeological_find/remains/get_additional_description()
	return pick(descs)

/decl/archaeological_find/remains/robot
	item_type = "robotic debris"
	new_icon = 'icons/mob/robots/_gibs.dmi'
	new_icon_state = "remainsrobot"
	descs = list("Almost mistakeable for the remains of a modern cyborg.",\
			"They are barely recognisable as anything other than a pile of waste metals.",\
			"It looks like the battered remains of an ancient robot chassis.",\
			"The chassis is rusting and old, but remarkably well preserved.",\
			"The chassis is scored by numerous burns and partially melted.",\
			"The chassis is battered and broken, in some cases only chunks of metal are left.",\
			"A pile of wires and crap metal that looks vaguely robotic.")

/decl/archaeological_find/remains/xeno
	item_type = "alien remains"
	new_icon_state = "remainsxeno"
	descs = list("It looks vaguely reptilian, but with more teeth.",\
			"They are faintly unsettling.",\
			"There is a faint aura of unease about them.",\
			"The bones are yellowing and old, but remarkably well preserved.",\
			"The bones are scored by numerous burns and partially melted.",\
			"The are battered and broken, in some cases less than splinters are left.",\
			"This creature would have been twisted and monstrous when it was alive.",\
			"It doesn't look human.")
