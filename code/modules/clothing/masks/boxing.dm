/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon = 'icons/clothing/mask/balaclava.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE|BLOCKHAIR|HIDEEARS
	body_parts_covered = SLOT_FACE|SLOT_HEAD
	down_body_parts_covered = SLOT_HEAD
	down_flags_inv = BLOCKHEADHAIR
	pull_mask = 1
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	icon = 'icons/clothing/mask/swat_mask.dmi'
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon = 'icons/clothing/mask/luchador.dmi'
	icon_state = ICON_STATE_WORLD
	flags_inv = HIDEFACE|BLOCKHAIR|HIDEEARS
	body_parts_covered = SLOT_HEAD|SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 3.0
	material = /decl/material/solid/cloth

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon = 'icons/clothing/mask/luchador_tecnicos.dmi'

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon = 'icons/clothing/mask/luchador_rudos.dmi'
