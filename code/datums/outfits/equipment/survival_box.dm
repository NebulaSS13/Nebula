/decl/survival_box_option
	decl_flags = DECL_FLAG_MANDATORY_UID
	abstract_type = /decl/survival_box_option
	var/name = "survival box option"
	var/box_type

/decl/survival_box_option/none
	name = "nothing"
	uid = "survival_box_nothing"

/decl/survival_box_option/survival
	name = "survival kit"
	box_type = /obj/item/box/survival
	uid = "survival_box_kit"

/decl/survival_box_option/lunchbox
	name = "lunchbox"
	box_type = /obj/item/lunchbox/filled
	uid = "survival_box_lunchbox"

/decl/survival_box_option/lunchbox/heart
	name = "heart lunchbox"
	box_type = /obj/item/lunchbox/heart/filled
	uid = "survival_box_lunchbox_heart"

/decl/survival_box_option/lunchbox/cat
	name = "cat lunchbox"
	box_type = /obj/item/lunchbox/cat/filled
	uid = "survival_box_lunchbox_cat"
