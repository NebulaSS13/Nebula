/obj/item/clothing/insignia
	abstract_type = /obj/item/clothing/insignia
	accessory_slot = ACCESSORY_SLOT_INSIGNIA
	w_class = ITEM_SIZE_SMALL
	material = /decl/material/solid/metal/gold
	fallback_slot = slot_w_uniform_str

/obj/item/clothing/insignia/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down
	)
	return initial_accessory_hide_on_states

// Subtypes below.
/obj/item/clothing/insignia/christian
	name = "chaplain insignia (christianity)"
	desc = "An insignia worn by chaplains. The cross represents Christianity."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_christianity.dmi'

/obj/item/clothing/insignia/judaism
	name = "chaplain insignia (Judaism)"
	desc = "An insignia worn by chaplains. The Star of David represents Judaism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_judaism.dmi'

/obj/item/clothing/insignia/islam
	name = "chaplain insignia (Islam)"
	desc = "An insignia worn by chaplains. The star & crescent represent Islam."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_islam.dmi'

/obj/item/clothing/insignia/buddhism
	name = "chaplain insignia (Buddhism)"
	desc = "An insignia worn by chaplains. The Dharma Chakra represents Buddhism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_buddhism.dmi'

/obj/item/clothing/insignia/hinduism
	name = "chaplain insignia (Hinduism)"
	desc = "An insignia worn by chaplains. The Om represents Hinduism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_hinduism.dmi'

/obj/item/clothing/insignia/sikhism
	name = "chaplain insignia (Sikhism)"
	desc = "An insignia worn by chaplains. The Khanda represents Sikhism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_sikh.dmi'

/obj/item/clothing/insignia/bahaifaith
	name = "chaplain insignia (Baha'i faith)"
	desc = "An insignia worn by chaplains. The nine-pointed star represents the Baha'i faith."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_baha.dmi'

/obj/item/clothing/insignia/jainism
	name = "chaplain insignia (Jainism)"
	desc = "An insignia worn by chaplains. The symbol of Ahimsa represents Jainism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_jain.dmi'

/obj/item/clothing/insignia/taoism
	name = "chaplain insignia (Taoism)"
	desc = "An insignia worn by chaplains. The yin yang represents Taoism."
	icon = 'icons/clothing/accessories/jewelry/religious/icon_taoist.dmi'
