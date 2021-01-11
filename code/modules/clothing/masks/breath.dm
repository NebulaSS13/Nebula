/obj/item/clothing/mask/breath
	desc = "A close-fitting mask that can be connected to an air supply."
	name = "breath mask"
	icon = 'icons/clothing/mask/breath.dmi'
	icon_state = ICON_STATE_WORLD
	item_flags = ITEM_FLAG_AIRTIGHT|ITEM_FLAG_FLEXIBLEMATERIAL
	body_parts_covered = SLOT_FACE
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.10
	permeability_coefficient = 0.50
	down_gas_transfer_coefficient = 1
	down_body_parts_covered = null
	down_item_flags = ITEM_FLAG_THICKMATERIAL
	pull_mask = 1
	origin_tech = "{'materials':1}"
	material = /decl/material/solid/plastic

/obj/item/clothing/mask/breath/medical
	desc = "A close-fitting sterile mask that can be manually connected to an air supply for treatment."
	name = "medical mask"
	icon = 'icons/clothing/mask/breath_medical.dmi'
	permeability_coefficient = 0.01

/obj/item/clothing/mask/breath/emergency
	desc = "A close-fitting  mask that is used by the wallmounted emergency oxygen pump."
	name = "emergency mask"
	permeability_coefficient = 0.50

/obj/item/clothing/mask/breath/scba
	desc = "A close-fitting self contained breathing apparatus mask. Can be connected to an air supply."
	name = "\improper SCBA mask"
	icon = 'icons/clothing/mask/breath_scuba.dmi'
	item_flags = ITEM_FLAG_AIRTIGHT|ITEM_FLAG_FLEXIBLEMATERIAL
	flags_inv = HIDEEYES
	body_parts_covered = SLOT_FACE|SLOT_EYES
	gas_transfer_coefficient = 0.01
