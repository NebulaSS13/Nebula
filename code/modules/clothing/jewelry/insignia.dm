/obj/item/clothing/jewelry/insignia
	name = "chaplain insignia (christianity)"
	desc = "An insignia worn by chaplains. The cross represents Christianity."
	icon = 'icons/clothing/accessories/religious/icon_christianity.dmi'
	accessory_slot = ACCESSORY_SLOT_INSIGNIA

/obj/item/clothing/jewelry/insignia/get_initial_accessory_hide_on_states()
	var/static/list/initial_accessory_hide_on_states = list(
		/decl/clothing_state_modifier/rolled_down
	)
	return initial_accessory_hide_on_states

/obj/item/clothing/jewelry/insignia/judaism
	name = "chaplain insignia (judaism)"
	desc = "An insignia worn by chaplains. The Star of David represents Judaism."
	icon = 'icons/clothing/accessories/religious/icon_judaism.dmi'

/obj/item/clothing/jewelry/insignia/islam
	name = "chaplain insignia (islam)"
	desc = "An insignia worn by chaplains. The star & crescent represent Islam."
	icon = 'icons/clothing/accessories/religious/icon_islam.dmi'

/obj/item/clothing/jewelry/insignia/buddhism
	name = "chaplain insignia (buddhism)"
	desc = "An insignia worn by chaplains. The Dharma Chakra represents Buddhism."
	icon = 'icons/clothing/accessories/religious/icon_buddhism.dmi'

/obj/item/clothing/jewelry/insignia/hinduism
	name = "chaplain insignia (hinduism)"
	desc = "An insignia worn by chaplains. The Om represents Hinduism."
	icon = 'icons/clothing/accessories/religious/icon_hinduism.dmi'

/obj/item/clothing/jewelry/insignia/sikhism
	name = "chaplain insignia (sikhism)"
	desc = "An insignia worn by chaplains. The Khanda represents Sikhism."
	icon = 'icons/clothing/accessories/religious/icon_sikh.dmi'

/obj/item/clothing/jewelry/insignia/bahaifaith
	name = "chaplain insignia (baha'i faith)"
	desc = "An insignia worn by chaplains. The nine-pointed star represents the Baha'i Faith."
	icon = 'icons/clothing/accessories/religious/icon_baha.dmi'

/obj/item/clothing/jewelry/insignia/jainism
	name = "chaplain insignia (jainism)"
	desc = "An insignia worn by chaplains. The symbol of Ahimsa represents Jainism."
	icon = 'icons/clothing/accessories/religious/icon_jain.dmi'

/obj/item/clothing/jewelry/insignia/taoism
	name = "chaplain insignia (taoism)"
	desc = "An insignia worn by chaplains. The yin yang represents Taoism."
	icon = 'icons/clothing/accessories/religious/icon_taoist.dmi'
