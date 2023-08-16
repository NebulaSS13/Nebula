//I mean that's only handy

#define CASING_MATTER          list(/decl/material/solid/metal/lead      = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/carbon          = MATTER_AMOUNT_SECONDARY)
#define CASING_MATTER_RUBBER   list(/decl/material/solid/plastic         = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/carbon          = MATTER_AMOUNT_SECONDARY)
#define CASING_MATTER_FLASH    list(/decl/material/solid/phosphorus      = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/carbon          = MATTER_AMOUNT_SECONDARY)
#define CASING_MATTER_EMP      list(/decl/material/solid/metal/uranium   = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)
#define CASING_MATTER_LASBULB  list(/decl/material/gas/hydrogen          = MATTER_AMOUNT_REINFORCEMENT, /decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY)

#define CASING_MATTER_PRACTICE list(/decl/material/solid/metal/lead      = MATTER_AMOUNT_TRACE,         /decl/material/solid/carbon = MATTER_AMOUNT_TRACE)

#define CASING_MATTER_SHELL    list(/decl/material/solid/metal/lead      = MATTER_AMOUNT_SECONDARY,     /decl/material/solid/carbon = MATTER_AMOUNT_PRIMARY)
#define CASING_MATTER_BEANBAG  list(/decl/material/solid/cloth           = MATTER_AMOUNT_SECONDARY,     /decl/material/solid/carbon = MATTER_AMOUNT_PRIMARY)
#define CASING_MATTER_STUN     list(/decl/material/solid/metal/aluminium = MATTER_AMOUNT_SECONDARY,     /decl/material/solid/carbon = MATTER_AMOUNT_PRIMARY)

//Pistol

/obj/item/ammo_casing/pistol
	desc = "A pistol bullet casing."
	icon = 'icons/obj/ammo/casings/pistol.dmi'
	caliber = CALIBER_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol
	color        = COLOR_POLISHED_BRASS
	bullet_color = COLOR_POLISHED_BRASS
	matter = CASING_MATTER

/obj/item/ammo_casing/pistol/rubber
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	bullet_color = COLOR_GRAY40
	matter = CASING_MATTER_RUBBER

/obj/item/ammo_casing/pistol/practice
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color  = COLOR_OFF_WHITE
	marking_color = COLOR_SUN
	matter = CASING_MATTER_PRACTICE

/obj/item/ammo_casing/pistol/flash
	projectile_type = /obj/item/projectile/energy/flash
	marking_color = COLOR_ORANGE
	matter = CASING_MATTER_FLASH

/obj/item/ammo_casing/pistol/emp
	projectile_type = /obj/item/projectile/ion/small
	bullet_color  = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_EMP

//Holdout/SMG

/obj/item/ammo_casing/pistol/small
	desc = "A small pistol bullet casing."
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	caliber = CALIBER_PISTOL_SMALL
	projectile_type = /obj/item/projectile/bullet/pistol/small

/obj/item/ammo_casing/pistol/small/rubber
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/small
	bullet_color = COLOR_GRAY40
	matter = CASING_MATTER_RUBBER

/obj/item/ammo_casing/pistol/small/practice
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color  = COLOR_OFF_WHITE
	marking_color = COLOR_SUN
	matter = CASING_MATTER_PRACTICE

/obj/item/ammo_casing/pistol/small/flash
	projectile_type = /obj/item/projectile/energy/flash
	marking_color = COLOR_ORANGE
	matter = CASING_MATTER_FLASH

/obj/item/ammo_casing/pistol/small/emp
	projectile_type = /obj/item/projectile/ion/tiny
	bullet_color  = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_EMP

//Magnum

/obj/item/ammo_casing/pistol/magnum
	desc = "A high-power pistol bullet casing."
	icon = 'icons/obj/ammo/casings/magnum.dmi'
	caliber = CALIBER_PISTOL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/pistol/magnum
	marking_color = COLOR_MAROON

/obj/item/ammo_casing/pistol/magnum/rubber
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/magnum
	bullet_color = COLOR_GRAY40
	matter = CASING_MATTER_RUBBER

/obj/item/ammo_casing/pistol/magnum/practice
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color  = COLOR_OFF_WHITE
	marking_color = COLOR_SUN
	matter = CASING_MATTER_PRACTICE

/obj/item/ammo_casing/pistol/magnum/flash
	projectile_type = /obj/item/projectile/energy/flash
	marking_color = COLOR_ORANGE
	matter = CASING_MATTER_FLASH

/obj/item/ammo_casing/pistol/magnum/emp
	projectile_type = /obj/item/projectile/ion/small
	bullet_color  = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_EMP

/obj/item/ammo_casing/pistol/magnum/stun //it makes total sense for this to be available only for revolver cuz its high caliber
	leaves_residue = FALSE
	projectile_type = /obj/item/projectile/energy/stun
	marking_color = COLOR_YELLOW
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_STUN

//Lasbulb

/obj/item/ammo_casing/lasbulb
	name = "lasbulb"
	desc = "A laser-bulb casing."
	icon = 'icons/obj/ammo/casings/lasbulb.dmi'
	caliber = CALIBER_PISTOL_LASBULB
	projectile_type = /obj/item/projectile/beam/heavy/pop
	color        = COLOR_BLUE_GRAY
	bullet_color = COLOR_BLUE_LIGHT
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_LASBULB

/obj/item/ammo_casing/lasbulb/stun
	projectile_type = /obj/item/projectile/beam/stun/heavy
	bullet_color = COLOR_YELLOW
	marking_color = COLOR_YELLOW

//Toyy

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	caliber = CALIBER_CAPS
	projectile_type = /obj/item/projectile/bullet/pistol/cap
	color        = COLOR_RED
	bullet_color = COLOR_RED
	material = /decl/material/solid/plastic
	matter = list(/decl/material/solid/carbon = MATTER_AMOUNT_TRACE)

//Shotgun

/obj/item/ammo_casing/shotgun
	name = "slug shell"
	desc = "A shotgun slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	drop_sound = 'sound/weapons/guns/shotgun_fall.ogg'
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_SHELL

/obj/item/ammo_casing/shotgun/pellet
	name = "pellet shell"
	desc = "A shotshell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = CASING_MATTER_BEANBAG

/obj/item/ammo_casing/shotgun/practice
	name = "practice shell"
	desc = "A practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = CASING_MATTER_PRACTICE

/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "netshell" //icon was missing and there's no nets anyway, also blanks were useless so I removed them
	spent_icon = "netshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = CASING_MATTER_FLASH

/obj/item/ammo_casing/shotgun/stun
	name = "stun shell"
	desc = "A shell fitted with a stun electrode launcher."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	leaves_residue = FALSE
	projectile_type = /obj/item/projectile/energy/stun/heavy
	matter = CASING_MATTER_STUN

/obj/item/ammo_casing/shotgun/emp
	name = "haywire shell"
	desc = "A shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	matter = CASING_MATTER_EMP

//Rifle

/obj/item/ammo_casing/rifle
	desc = "A military rifle bullet casing."
	icon = 'icons/obj/ammo/casings/rifle.dmi'
	color        = COLOR_POLISHED_BRASS
	bullet_color = COLOR_POLISHED_BRASS
	caliber = CALIBER_RIFLE
	projectile_type = /obj/item/projectile/bullet/rifle
	matter = CASING_MATTER

/obj/item/ammo_casing/rifle/rubber
	projectile_type = /obj/item/projectile/bullet/rifle/rubber
	bullet_color = COLOR_GRAY40
	matter = CASING_MATTER_RUBBER

/obj/item/ammo_casing/rifle/practice
	projectile_type = /obj/item/projectile/bullet/rifle/practice
	bullet_color  = COLOR_OFF_WHITE
	marking_color = COLOR_SUN
	matter = CASING_MATTER_PRACTICE

/obj/item/ammo_casing/rifle/flash
	projectile_type = /obj/item/projectile/energy/flash
	marking_color = COLOR_ORANGE
	matter = CASING_MATTER_FLASH

/obj/item/ammo_casing/rifle/emp
	projectile_type = /obj/item/projectile/ion/tiny
	bullet_color  = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL
	material = /decl/material/solid/metal/steel
	matter = CASING_MATTER_EMP

//AM shell

/obj/item/ammo_casing/rifle/shell
	name = "shell casing"
	desc = "A heavy rifle shell casing."
	icon = 'icons/obj/ammo/casings/heavy_rifle.dmi'
	color = COLOR_WHITE
	caliber = CALIBER_ANTI_MATERIEL
	projectile_type = /obj/item/projectile/bullet/rifle/shell
	bullet_color  = COLOR_RED_GRAY
	marking_color = COLOR_RED_LIGHT
	matter = CASING_MATTER_SHELL

//Chemdart

/obj/item/ammo_casing/chemdart
	name = "chemical dart"
	desc = "A small hardened, hollow dart."
	icon_state = "dart"
	leaves_residue = FALSE
	caliber = CALIBER_DART
	projectile_type = /obj/item/projectile/bullet/chemdart

/obj/item/ammo_casing/chemdart/expend()
	qdel(src)

//Rocket

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	caliber = "rocket"
	projectile_type = /obj/item/missile
	material = /decl/material/solid/metal/steel
	matter = list(
		/decl/material/solid/metal/aluminium = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/solid/metal/copper    = MATTER_AMOUNT_TRACE,
		/decl/material/solid/silicon         = MATTER_AMOUNT_TRACE,
		/decl/material/liquid/anfo           = MATTER_AMOUNT_REINFORCEMENT,
		/decl/material/liquid/fuel           = MATTER_AMOUNT_REINFORCEMENT,
	)