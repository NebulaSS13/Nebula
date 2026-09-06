/obj/structure/snowman
	name                = "man"
	icon                = 'icons/obj/structures/snowmen/snowman.dmi'
	icon_state          = ICON_STATE_WORLD
	desc                = "A happy little $NAME$ smiles back at you!"
	anchored            = TRUE
	material            = /decl/material/solid/ice/snow
	material_alteration = MAT_FLAG_ALTERATION_ALL // We override name and desc below.

/obj/structure/snowman/Initialize(ml, _mat, _reinf_mat)
	. = ..()
	update_icon()

/obj/structure/snowman/update_material_name(override_name)
	SHOULD_CALL_PARENT(FALSE)
	if(istype(material))
		SetName("[material.solid_name][initial(name)]")
	else
		SetName("mystery[initial(name)]")

/obj/structure/snowman/update_material_desc(override_desc)
	SHOULD_CALL_PARENT(FALSE)
	if(istype(material))
		var/snowname = "[material.solid_name][initial(name)]"
		desc = replacetext(initial(desc), "$NAME$", snowname)
	else
		desc = replacetext(initial(desc), "$NAME$", "mysteryman")

/obj/structure/snowman/on_update_icon()
	. = ..()
	// TODO: make carrot/stick arms/coal require items?
	add_overlay(overlay_image(icon, "[icon_state]-decorations", COLOR_WHITE, RESET_COLOR))
	compile_overlays()

/obj/structure/snowman/proc/user_destroyed(user)
	to_chat(user, SPAN_DANGER("\The [src] crumples into a pile of [material.solid_name] after a single solid hit. You monster."))
	physically_destroyed()

/obj/structure/snowman/attackby(obj/item/used_item, mob/user)
	if(user.check_intent(I_FLAG_HARM) && used_item.get_base_attack_force())
		user_destroyed(user)
		return TRUE
	return ..()

/obj/structure/snowman/attack_hand(mob/user)
	if(user.check_intent(I_FLAG_HARM))
		user_destroyed(user)
		return TRUE
	return ..()

/obj/structure/snowman/bot
	name                = "bot"
	icon                = 'icons/obj/structures/snowmen/snowbot.dmi'
	desc                = "A bland-faced little $NAME$. It even has a monitor for a head."

/obj/structure/snowman/spider
	name                = "spider"
	icon                = 'icons/obj/structures/snowmen/snowspider.dmi'
	desc                = "An impressively-crafted $NAME$. Not nearly as creepy as the real thing."