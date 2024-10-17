
//Hat Station 13

/obj/item/clothing/head/collectable
	name = "collectable hat"
	desc = "A rare collectable hat."
	armor = null

/obj/item/clothing/head/collectable/petehat
	name = "ultra rare hat"
	desc = "an ultra rare hat. It commands a certain respect."
	icon = 'icons/clothing/head/pete.dmi'

/obj/item/clothing/head/collectable/xenom
	name = "collectable alien monster helmet!"
	desc = "Hiss hiss hiss!"
	icon = 'icons/clothing/head/xeno.dmi'
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES|SLOT_EARS
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCK_ALL_HAIR

/obj/item/clothing/head/collectable/chef
	name = "collectable chef's hat"
	desc = "A rare Chef's Hat meant for hat collectors!"
	icon = 'icons/clothing/head/chef.dmi'

/obj/item/clothing/head/collectable/paper
	name = "collectable paper hat"
	desc = "What looks like an ordinary paper hat, is actually a rare and valuable collector's edition paper hat. Keep away from water, fire and Librarians."
	icon = 'icons/clothing/head/paper.dmi'

/obj/item/clothing/head/collectable/tophat
	name = "collectable top hat"
	desc = "A top hat worn by only the most prestigious hat collectors."
	icon = 'icons/clothing/head/tophat.dmi'

/obj/item/clothing/head/collectable/captain
	name = "collectable captain's hat"
	desc = "A Collectable Hat that'll make you look just like a real comdom!"
	icon = 'icons/clothing/head/captain.dmi'

/obj/item/clothing/head/collectable/police
	name = "collectable police officer's hat"
	desc = "A Collectable Police Officer's Hat. This hat emphasizes that you are THE LAW."
	icon = 'icons/clothing/head/warden.dmi'

/obj/item/clothing/head/collectable/beret
	name = "collectable beret"
	desc = "A Collectable red Beret. It smells faintly of Garlic."
	icon = 'icons/clothing/head/beret.dmi'
	color = COLOR_NT_RED

/obj/item/clothing/head/collectable/welding
	name = "collectable welding helmet"
	desc = "A Collectable Welding Helmet. Now with 80% less lead! Not for actual welding. Any welding done while wearing this Helmet is done so at the owner's own risk!"
	icon = 'icons/clothing/head/welding/default.dmi'
	w_class = ITEM_SIZE_NORMAL
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	flags_inv = HIDEMASK|HIDEEYES|HIDEFACE
	accessory_slot = null // cannot be equipped on top of helmets

/obj/item/clothing/head/collectable/slime
	name = "collectable slime hat"
	desc = "Just like a real Brain Slug!"
	icon = 'icons/clothing/head/brainslime.dmi'
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/collectable/pirate
	name = "collectable pirate hat"
	desc = "You'd make a great Dread Syndie Roberts!"
	icon = 'icons/clothing/head/pirate.dmi'

/obj/item/clothing/head/collectable/kitty
	name = "collectable kitty ears"
	desc = "The fur feels.....a bit too realistic."
	icon = 'icons/clothing/head/cat.dmi'
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/collectable/rabbitears
	name = "collectable rabbit ears"
	desc = "Not as lucky as the feet!"
	icon = 'icons/clothing/head/bunny.dmi'
	flags_inv = 0
	body_parts_covered = 0

/obj/item/clothing/head/collectable/wizard
	name = "collectable wizard's hat"
	desc = "NOTE:Any magical powers gained from wearing this hat are purely coincidental."
	icon = 'icons/clothing/head/wizard/wizard.dmi'

/obj/item/clothing/head/collectable/hardhat
	name = "collectable hard hat"
	desc = "WARNING! Offers no real protection, or luminosity, but it is damn fancy!"
	icon = 'icons/clothing/head/hardhat/yellow.dmi'
	w_class = ITEM_SIZE_NORMAL

/obj/item/clothing/head/collectable/HoS
	name = "collectable HoS hat"
	desc = "Now you can beat prisoners, set silly sentences and arrest for no reason too!"
	icon = 'icons/clothing/head/hos.dmi'

/obj/item/clothing/head/collectable/thunderdome
	name = "collectable Thunderdome helmet"
	desc = "Go Red! I mean Green! I mean Red! No Green!"
	icon = 'icons/clothing/head/armor/thunderdome.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_OVER_HELMET)
	restricted_accessory_slots = list(ACCESSORY_SLOT_OVER_HELMET)
	accessory_slot = null // cannot be equipped on top of helmets

/obj/item/clothing/head/collectable/swat
	name = "collectable SWAT helmet"
	desc = "Now you can be in the Deathsquad too!"
	icon = 'icons/clothing/head/armor/merc.dmi'
	valid_accessory_slots = list(ACCESSORY_SLOT_OVER_HELMET)
	restricted_accessory_slots = list(ACCESSORY_SLOT_OVER_HELMET)
	accessory_slot = null // cannot be equipped on top of helmets
