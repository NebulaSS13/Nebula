/decl/banner_symbol
	abstract_type = /decl/banner_symbol
	decl_flags    = DECL_FLAG_MANDATORY_UID
	/// Icon to draw from when rendering on a banner.
	var/icon      = 'icons/obj/items/banners/banner_symbols.dmi'
	/// Icon state to draw from the icon.
	var/icon_state
	/// String used to select/describe a symbol
	var/name
	var/usable_by_banner_type = list(
		/obj/item/banner
	)

/decl/banner_symbol/validate()
	. = ..()
	if(!icon)
		. += "null icon"
	if(!istext(icon_state))
		. += "invalid/null icon_state"
	if(!istext(name))
		. += "invalid/null name"
	if(icon && icon_state && !check_state_in_icon(icon_state, icon))
		. += "missing icon_state '[icon_state]' from icon '[icon]'"

// Default definitions below.
/decl/banner_symbol/starburst
	name       = "starburst"
	icon_state = "starburst"
	uid        = "symbol_starburst"

/decl/banner_symbol/fern
	name       = "fern"
	icon_state = "fern"
	uid        = "symbol_fern"

/decl/banner_symbol/snowflake
	name       = "snowflake"
	icon_state = "snowflake"
	uid        = "symbol_snowflake"

/decl/banner_symbol/sun
	name       = "sun"
	icon_state = "sun"
	uid        = "symbol_sun"

/decl/banner_symbol/scarab
	name       = "scarab"
	icon_state = "scarab"
	uid        = "symbol_scarab"

/decl/banner_symbol/triangle_chevron
	name       = "triangle with chevron"
	icon_state = "triangle with chevron"
	uid        = "symbol_triangle_chevron"

/decl/banner_symbol/triangle_down
	name       = "downward triangle"
	icon_state = "downward triangle"
	uid        = "symbol_triangle_down"

/decl/banner_symbol/triangle_up
	name       = "upward triangle"
	icon_state = "upward triangle"
	uid        = "symbol_triangle_up"

/decl/banner_symbol/hand
	name       = "hand"
	icon_state = "hand"
	uid        = "symbol_hand"

/decl/banner_symbol/sword
	name       = "sword"
	icon_state = "sword"
	uid        = "symbol_sword"

/decl/banner_symbol/knot
	name       = "knot"
	icon_state = "knot"
	uid        = "symbol_knot"

/decl/banner_symbol/circled_cup
	name       = "circled cup"
	icon_state = "circled cup"
	uid        = "symbol_cup_circle"

/decl/banner_symbol/aquila
	name       = "aquila"
	icon_state = "aquila"
	uid        = "symbol_aquila"

/decl/banner_symbol/orb
	name       = "orb"
	icon_state = "orb"
	uid        = "symbol_orb"

/decl/banner_symbol/bird_head
	name       = "bird head"
	icon_state = "bird head"
	uid        = "symbol_bird_head"

/decl/banner_symbol/deer
	name       = "deer"
	icon_state = "deer"
	uid        = "symbol_deer"

/decl/banner_symbol/deer_antler
	name       = "antlered deer"
	icon_state = "antlered deer"
	uid        = "symbol_deer_antler"

/decl/banner_symbol/duck
	name       = "duck head"
	icon_state = "duck head"
	uid        = "symbol_duck_head"

/decl/banner_symbol/frog
	name       = "frog"
	icon_state = "frog"
	uid        = "symbol_frog"

/decl/banner_symbol/fish
	name       = "fish"
	icon_state = "fish"
	uid        = "symbol_fish"

/decl/banner_symbol/bird
	name       = "bird"
	icon_state = "bird"
	uid        = "symbol_bird"

/decl/banner_symbol/cross
	name       = "cross"
	icon_state = "cross"
	uid        = "symbol_cross"

/decl/banner_symbol/sign
	icon                  = 'icons/obj/items/banners/sign_symbols.dmi'
	abstract_type         = /decl/banner_symbol/sign
	usable_by_banner_type = list(
		/obj/item/banner/sign
	)

/decl/banner_symbol/sign/mug
	name       = "mug"
	icon_state = "mug"
	uid        = "symbol_sign_mug"

/decl/banner_symbol/sign/scales
	name       = "scales"
	icon_state = "scales"
	uid        = "symbol_sign_scales"

/decl/banner_symbol/sign/mortar_pestle
	name       = "mortar and pestle"
	icon_state = "mortar and pestle"
	uid        = "symbol_sign_mortar_pestle"

/decl/banner_symbol/sign/pick_shovel
	name       = "pick and shovel"
	icon_state = "pick and shovel"
	uid        = "symbol_sign_pick_shovel"

/decl/banner_symbol/sign/face
	name       = "face"
	icon_state = "face"
	uid        = "symbol_sign_face"

/decl/banner_symbol/sign/crescent
	name       = "crescent"
	icon_state = "crescent"
	uid        = "symbol_sign_crescent"

/decl/banner_symbol/sign/vial
	name       = "vial"
	icon_state = "vial"
	uid        = "symbol_sign_vial"

/decl/banner_symbol/sign/spool
	name       = "spool"
	icon_state = "spool"
	uid        = "symbol_sign_spool"

/decl/banner_symbol/sign/pawnbroker
	name       = "pawnbroker"
	icon_state = "pawnbroker"
	uid        = "symbol_sign_pawnbroker"

/decl/banner_symbol/sign/sword
	name       = "sword"
	icon_state = "sword"
	uid        = "symbol_sign_sword"

/decl/banner_symbol/sign/cross
	name       = "cross"
	icon_state = "cross"
	uid        = "symbol_sign_cross"

/decl/banner_symbol/sign/circle
	name       = "circle"
	icon_state = "circle"
	uid        = "symbol_sign_circle"
