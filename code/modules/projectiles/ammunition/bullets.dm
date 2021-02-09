
/obj/item/ammo_casing/pistol
	desc = "A pistol bullet casing."
	caliber = CALIBER_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol
	icon = 'icons/obj/ammo/casings/pistol.dmi'

/obj/item/ammo_casing/pistol/rubber
	desc = "A rubber pistol bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber
	bullet_color = COLOR_GRAY40

/obj/item/ammo_casing/pistol/practice
	desc = "A practice pistol bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/pistol/emp
	name = "haywire round"
	desc = "A pistol bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/small
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)
	bullet_color = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL

/obj/item/ammo_casing/pistol/small
	desc = "A small pistol bullet casing."
	color = COLOR_POLISHED_BRASS
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	caliber = CALIBER_PISTOL_SMALL
	projectile_type = /obj/item/projectile/bullet/pistol/holdout
	
/obj/item/ammo_casing/pistol/small/rubber
	desc = "A small pistol rubber bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/rubber/holdout
	bullet_color = COLOR_GRAY40

/obj/item/ammo_casing/pistol/small/practice
	desc = "A small pistol practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/pistol/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/pistol/small/emp
	name = "small haywire round"
	desc = "A small bullet casing fitted with a single-use ion pulse generator."
	projectile_type = /obj/item/projectile/ion/tiny
	bullet_color = COLOR_ACID_CYAN
	marking_color = COLOR_LUMINOL

/obj/item/ammo_casing/pistol/magnum
	desc = "A high-power pistol bullet casing."
	caliber = CALIBER_PISTOL_MAGNUM
	color = COLOR_POLISHED_BRASS
	marking_color = COLOR_MAROON
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	icon = 'icons/obj/ammo/casings/magnum.dmi'

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A shotgun slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = CALIBER_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	material = /decl/material/solid/metal/steel
	fall_sounds = list('sound/weapons/guns/shotgun_fall.ogg')

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A shotshell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	material = /decl/material/solid/metal/steel

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	material = /decl/material/solid/metal/steel

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "An energy stun cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	leaves_residue = 0
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/glass = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/ammo_casing/shotgun/emp
	name = "haywire slug"
	desc = "A 12-gauge shotgun slug fitted with a single-use ion pulse generator."
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/ion
	material = /decl/material/solid/metal/steel
	matter = list(/decl/material/solid/metal/uranium = MATTER_AMOUNT_REINFORCEMENT)

/obj/item/ammo_casing/shell
	name = "shell casing"
	desc = "An anti-materiel shell casing."
	caliber = CALIBER_ANTI_MATERIEL
	projectile_type = /obj/item/projectile/bullet/rifle/shell
	material = /decl/material/solid/metal/steel
	color = COLOR_POLISHED_BRASS
	icon = 'icons/obj/ammo/casings/anti_materiel.dmi'

/obj/item/ammo_casing/shell/apds
	name = "\improper APDS shell casing"
	desc = "An Armour Piercing Discarding Sabot shell."
	projectile_type = /obj/item/projectile/bullet/rifle/shell/apds
	bullet_color = COLOR_RED_GRAY
	marking_color = COLOR_NT_RED

/obj/item/ammo_casing/rifle
	desc = "A military rifle bullet casing."
	caliber = CALIBER_RIFLE
	projectile_type = /obj/item/projectile/bullet/rifle
	icon = 'icons/obj/ammo/casings/rifle.dmi'

/obj/item/ammo_casing/rifle/practice
	desc = "A military rifle practice bullet casing."
	projectile_type = /obj/item/projectile/bullet/rifle/practice
	bullet_color = COLOR_OFF_WHITE
	marking_color = COLOR_SUN

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = CALIBER_CAPS
	icon = 'icons/obj/ammo/casings/small_pistol.dmi'
	bullet_color = COLOR_RED
	color = COLOR_RED
	projectile_type = /obj/item/projectile/bullet/pistol/cap

/obj/item/ammo_casing/lasbulb
	name = "lasbulb"
	desc = "A laser-bulb casing."
	caliber = CALIBER_PISTOL_LASBULB
	projectile_type = /obj/item/projectile/beam/pop
	icon = 'icons/obj/ammo/casings/lasbulb.dmi'
	color = COLOR_BLUE_GRAY
	bullet_color = COLOR_BLUE_LIGHT
	material = /decl/material/solid/glass
	matter = list(/decl/material/solid/plastic = MATTER_AMOUNT_REINFORCEMENT)