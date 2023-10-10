/obj/item/gun/projectile/revolver/foundation
	name = "\improper Foundation revolver"
	icon = 'mods/content/psionics/icons/foundation.dmi'
	icon_state = "foundation"
	desc = "The CF 'Troubleshooter', a compact plastic-composite weapon designed for concealed carry by Cuchulain Foundation field agents. Smells faintly of copper."
	ammo_type = /obj/item/ammo_casing/pistol/magnum/nullglass

/obj/item/gun/projectile/revolver/foundation/disrupts_psionics()
	return FALSE

/obj/item/storage/briefcase/foundation
	name = "\improper Foundation briefcase"
	desc = "A handsome black leather briefcase embossed with a stylized radio telescope."
	icon_state = "fbriefcase"
	item_state = "fbriefcase"

/obj/item/storage/briefcase/foundation/disrupts_psionics()
	return FALSE

/obj/item/storage/briefcase/foundation/WillContain()
	return list(
		/obj/item/ammo_magazine/speedloader/nullglass,
		/obj/item/gun/projectile/revolver/foundation,
	)

/obj/item/storage/briefcase/foundation/Initialize(ml, material_key)
	. = ..()
	if(length(contents))
		make_exact_fit()
