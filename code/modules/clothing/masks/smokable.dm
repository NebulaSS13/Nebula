/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	icon = 'icons/clothing/mask/smokables/cigarette.dmi'
	body_parts_covered = 0
	bodytype_equip_flags = null
	z_flags = ZMM_MANGLE_PLANES

	var/lit = FALSE
	var/waterproof = FALSE
	var/type_butt = null
	var/chem_volume = 0
	var/smoketime = 0
	var/genericmes = "<span class='notice'>USER lights their NAME with the FLAME.</span>"
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	var/brand
	var/gas_consumption = 0.04
	var/smoke_effect = 0
	var/smoke_amount = 1

/obj/item/clothing/mask/smokable/get_tool_quality(archetype, property)
	return (!lit && archetype == TOOL_CAUTERY) ? TOOL_QUALITY_NONE : ..()

/obj/item/clothing/mask/smokable/dropped(mob/user)
	. = ..()
	if(lit)
		update_icon()

/obj/item/clothing/mask/smokable/equipped(mob/user)
	. = ..()
	if(lit)
		update_icon()

/obj/item/clothing/mask/smokable/Initialize()
	. = ..()
	atom_flags |= ATOM_FLAG_NO_CHEM_CHANGE // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/smokable/Destroy()
	. = ..()
	if(lit)
		STOP_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/isflamesource(atom/A)
	. = lit

/obj/item/clothing/mask/smokable/get_heat()
	. = max(..(), lit ? 1500 : 0)

/obj/item/clothing/mask/smokable/fire_act()
	light(0)
	return ..()

/obj/item/clothing/mask/smokable/proc/smoke(amount, manual)
	smoketime -= amount
	if(reagents && reagents.total_volume) // check if it has any reagents at all
		var/smoke_loc = loc
		if(ishuman(loc))
			var/mob/living/human/user = loc
			smoke_loc = user.loc
			if ((src == user.get_equipped_item(slot_wear_mask_str) || manual) && user.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(user, smoke_amount * amount, CHEM_INHALE, 0.2)
				add_trace_DNA(user)
		else // else just remove some of the reagents
			remove_any_reagents(smoke_amount * amount)

		smoke_effect++

		if(smoke_effect >= 4 || manual)
			smoke_effect = 0
			new /obj/effect/effect/cig_smoke(smoke_loc)

	var/turf/T = get_turf(src)
	if(T)
		var/datum/gas_mixture/environment = T.return_air()
		if(ishuman(loc))
			var/mob/living/human/user = loc
			if (src == user.get_equipped_item(slot_wear_mask_str) && user.internal)
				environment = user.internal.return_air()
		if(environment.get_by_flag(XGM_GAS_OXIDIZER) < gas_consumption)
			extinguish()
		else
			environment.remove_by_flag(XGM_GAS_OXIDIZER, gas_consumption)
			environment.adjust_gas(/decl/material/gas/carbon_dioxide, 0.5*gas_consumption,0)
			environment.adjust_gas(/decl/material/gas/carbon_monoxide, 0.5*gas_consumption)

/obj/item/clothing/mask/smokable/Process()
	var/turf/location = get_turf(src)
	if(submerged() || smoketime < 1)
		extinguish()
		return
	smoke(1)
	if(location)
		location.hotspot_expose(700, 5)

/obj/item/clothing/mask/smokable/on_update_icon()
	. = ..()
	if(lit && check_state_in_icon("[icon_state]-on", icon))
		var/image/I
		if(plane == HUD_PLANE)
			I = image(icon, "[icon_state]-on")
		else
			I = emissive_overlay(icon, "[icon_state]-on")
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

	if(ismob(loc))
		var/mob/living/M = loc
		M.update_equipment_overlay(slot_wear_mask_str, FALSE)
		M.update_inhand_overlays()

/obj/item/clothing/mask/smokable/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing = TRUE)
	if(overlay && lit && check_state_in_icon("[overlay.icon_state]-on", overlay.icon))
		var/image/on_overlay = emissive_overlay(overlay.icon, "[overlay.icon_state]-on")
		on_overlay.appearance_flags |= RESET_COLOR
		overlay.add_overlay(on_overlay)
	. = ..()

/obj/item/clothing/mask/smokable/fluid_act(var/datum/reagents/fluids)
	..()
	if(!QDELETED(src) && fluids?.total_volume && !waterproof && lit)
		var/turf/location = get_turf(src)
		if(location)
			location.hotspot_expose(700, 5)
		extinguish(no_message = TRUE)

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(QDELETED(src))
		return
	if(!lit)
		if(submerged())
			to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
			return
		lit = TRUE
		atom_damage_type = BURN
		if(REAGENT_VOLUME(reagents, /decl/material/liquid/fuel)) // the fuel explodes
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(REAGENT_VOLUME(reagents, /decl/material/liquid/fuel) / 5, 1), get_turf(src), 0, 0)
			e.start()
			qdel(src)
			return
		atom_flags &= ~ATOM_FLAG_NO_CHEM_CHANGE // allowing reagents to react after being lit
		HANDLE_REACTIONS(reagents)
		update_icon()
		if(flavor_text)
			var/turf/T = get_turf(src)
			T.visible_message(flavor_text)
		smoke_amount = reagents.total_volume / smoketime
		START_PROCESSING(SSobj, src)

/obj/item/clothing/mask/smokable/proc/extinguish(var/mob/user, var/no_message)
	lit = FALSE
	atom_damage_type =  BRUTE
	STOP_PROCESSING(SSobj, src)
	set_light(0)
	update_icon()

/obj/item/clothing/mask/smokable/attackby(var/obj/item/W, var/mob/user)
	..()
	if(W.isflamesource() || W.get_heat() >= T100C)
		var/text = matchmes
		if(istype(W, /obj/item/flame/match))
			text = matchmes
		else if(istype(W, /obj/item/flame/fuelled/lighter/zippo))
			text = zippomes
		else if(istype(W, /obj/item/flame/fuelled/lighter))
			text = lightermes
		else if(IS_WELDER(W))
			text = weldermes
		else if(istype(W, /obj/item/assembly/igniter))
			text = ignitermes
		else
			text = genericmes
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(target.on_fire)
		user.do_attack_animation(target)
		light(SPAN_NOTICE("\The [user] coldly lights the \the [src] with the burning body of \the [target]."))
		return TRUE
	return ..()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A small paper cylinder filled with processed tobacco and various fillers."
	throw_speed = 0.5
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS | SLOT_FACE
	attack_verb = list("burnt", "singed")
	type_butt = /obj/item/trash/cigbutt
	chem_volume = 5
	smoketime = 300
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"
	brand = "\improper Trans-Stellar Duty-free"

/obj/item/clothing/mask/smokable/cigarette/can_be_injected_by(var/atom/injector)
	return TRUE

/obj/item/clothing/mask/smokable/cigarette/Initialize()
	. = ..()
	initialize_reagents()
	set_extension(src, /datum/extension/tool, list(TOOL_CAUTERY = TOOL_QUALITY_MEDIOCRE))

/obj/item/clothing/mask/smokable/cigarette/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco, 1)

/obj/item/clothing/mask/smokable/cigarette/light(var/flavor_text = "[usr] lights the [name].")
	..()
	if(is_processing)
		set_scent_by_reagents(src)

/obj/item/clothing/mask/smokable/extinguish(var/mob/user, var/no_message)
	..()
	remove_extension(src, /datum/extension/scent)
	if (type_butt)
		var/obj/item/trash/cigbutt/butt = new type_butt(get_turf(src))
		transfer_fingerprints_to(butt)
		if(istype(butt) && butt.use_color)
			butt.color = color
		if(brand)
			butt.desc += " This one is a [brand]."
		if(ismob(loc))
			var/mob/living/M = loc
			if (!no_message)
				to_chat(M, SPAN_NOTICE("Your [name] goes out."))
		qdel(src)

/obj/item/clothing/mask/smokable/cigarette/menthol
	name = "menthol cigarette"
	desc = "A cigarette with a little minty kick. Well, minty in theory."
	icon = 'icons/clothing/mask/smokables/cigarette_menthol.dmi'
	brand = "\improper Temperamento Menthol"
	color = "#ddffe8"
	type_butt = /obj/item/trash/cigbutt/menthol

/obj/item/clothing/mask/smokable/cigarette/menthol/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/menthol, 1)

/obj/item/trash/cigbutt/menthol
	icon = 'icons/clothing/mask/smokables/cigarette_menthol_butt.dmi'

/obj/item/clothing/mask/smokable/cigarette/luckystars
	brand = "\improper Lucky Star"

/obj/item/clothing/mask/smokable/cigarette/jerichos
	name = "rugged cigarette"
	brand = "\improper Jericho"
	icon = 'icons/clothing/mask/smokables/cigarette_jericho.dmi'
	color = "#dcdcdc"
	type_butt = /obj/item/trash/cigbutt/jerichos

/obj/item/clothing/mask/smokable/cigarette/jerichos/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/bad, 1.5)

/obj/item/trash/cigbutt/jerichos
	icon = 'icons/clothing/mask/smokables/cigarette_jericho_butt.dmi'

/obj/item/clothing/mask/smokable/cigarette/carcinomas
	name = "dark cigarette"
	brand = "\improper Carcinoma Angel"
	color = "#869286"

/obj/item/clothing/mask/smokable/cigarette/professionals
	name = "thin cigarette"
	brand = "\improper Professional"
	icon = 'icons/clothing/mask/smokables/cigarette_professional.dmi'
	type_butt = /obj/item/trash/cigbutt/professionals

/obj/item/clothing/mask/smokable/cigarette/professionals/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/bad, 1)

/obj/item/trash/cigbutt/professionals
	icon = 'icons/clothing/mask/smokables/cigarette_professional_butt.dmi'

/obj/item/clothing/mask/smokable/cigarette/killthroat
	brand = "\improper Acme Co. cigarette"

/obj/item/clothing/mask/smokable/cigarette/dromedaryco
	brand = "\improper Dromedary Co. cigarette"

/obj/item/clothing/mask/smokable/cigarette/trident
	name = "wood tip cigar"
	brand = "\improper Trident cigar"
	desc = "A narrow cigar with a wooden tip."
	icon = 'icons/clothing/mask/smokables/cigarello.dmi'
	smoketime = 600
	chem_volume = 10
	type_butt = /obj/item/trash/cigbutt/woodbutt
	var/band_color

/obj/item/clothing/mask/smokable/cigarette/trident/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/fine, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/on_update_icon()
	. = ..()
	if(band_color)
		var/image/I = image(icon, "[icon_state]-band")
		I.color = band_color
		I.appearance_flags |= RESET_COLOR
		add_overlay(I)

/obj/item/clothing/mask/smokable/cigarette/trident/mint
	band_color = COLOR_CYAN

/obj/item/clothing/mask/smokable/cigarette/trident/mint/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/menthol, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/berry
	band_color = COLOR_VIOLET

/obj/item/clothing/mask/smokable/cigarette/trident/berry/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/berry, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/cherry
	band_color = COLOR_RED

/obj/item/clothing/mask/smokable/cigarette/trident/cherry/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/nutriment/cherryjelly, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/grape
	band_color = COLOR_PURPLE

/obj/item/clothing/mask/smokable/cigarette/trident/grape/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/grape, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/watermelon
	band_color = COLOR_GREEN

/obj/item/clothing/mask/smokable/cigarette/trident/watermelon/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/watermelon, 2)

/obj/item/clothing/mask/smokable/cigarette/trident/orange
	band_color = COLOR_ORANGE

/obj/item/clothing/mask/smokable/cigarette/trident/orange/populate_reagents()
	. = ..()
	add_to_reagents(/decl/material/liquid/drink/juice/orange, 2)

/obj/item/trash/cigbutt/woodbutt
	name = "wooden tip"
	icon = 'icons/clothing/mask/smokables/cigar_butt.dmi'
	desc = "A wooden mouthpiece from a cigar. Smells rather bad."
	material = /decl/material/solid/organic/wood

/obj/item/clothing/mask/smokable/cigarette/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/energy_blade/sword))
		var/obj/item/energy_blade/sword/S = W
		if(S.active)
			light(SPAN_WARNING("[user] swings their [W], barely missing their nose. They light their [name] in the process."))
			return TRUE
	return ..()

/obj/item/clothing/mask/smokable/cigarette/use_on_mob(mob/living/target, mob/living/user, animate = TRUE)
	if(lit && target == user)
		var/obj/item/blocked = target.check_mouth_coverage()
		if(blocked)
			to_chat(target, SPAN_WARNING("\The [blocked] is in the way!"))
			return TRUE
		var/decl/pronouns/G = user.get_pronouns()
		var/puff_str = pick("drag","puff","pull")
		user.visible_message(\
			SPAN_NOTICE("\The [user] takes a [puff_str] on [G.his] [name]."), \
			SPAN_NOTICE("You take a [puff_str] on your [name]."))
		smoke(12, TRUE)
		add_trace_DNA(target)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	if(!lit && target.on_fire)
		user.do_attack_animation(target)
		light(target, user)
		return TRUE

	return ..()

/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/chems/glass/glass, var/mob/user, proximity)
	if(!proximity)
		return
	if(!lit && istype(glass)) //you can dip unlit cigarettes into beakers. todo: extinguishing lit cigarettes in beakers? disambiguation via intent?
		if(!ATOM_IS_OPEN_CONTAINER(glass))
			to_chat(user, SPAN_NOTICE("You need to take the lid off first."))
			return TRUE
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if(transfered)	//if reagents were transfered, show the message
			to_chat(user, SPAN_NOTICE("You dip \the [src] into \the [glass]."))
		else			//if not, either the beaker was empty, or the cigarette was full
			if(!glass.reagents.total_volume)
				to_chat(user, SPAN_NOTICE("[glass] is empty."))
			else
				to_chat(user, SPAN_NOTICE("[src] is full."))
		return TRUE
	return ..()

/obj/item/clothing/mask/smokable/cigarette/attack_self(var/mob/user)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] calmly drops and treads on the lit [src], putting it out instantly."))
		extinguish(no_message = 1)
	return ..()

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "premium cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon = 'icons/clothing/mask/smokables/cigar_alt.dmi'
	type_butt = /obj/item/trash/cigbutt/cigarbutt
	throw_speed = 0.5
	smoketime = 1500
	chem_volume = 15
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
	brand = null

/obj/item/clothing/mask/smokable/cigarette/cigar/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/fine, 5)

/obj/item/clothing/mask/smokable/cigarette/cigar/cohiba
	name = "\improper Cohiba Robusto cigar"
	desc = "There's little more you could want from a cigar."
	icon = 'icons/clothing/mask/smokables/cigar_alt.dmi'
	brand = "Cohiba Robusto"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "premium Havanian cigar"
	desc = "A cigar fit for only the best of the best."
	icon = 'icons/clothing/mask/smokables/cigar_alt.dmi'
	smoketime = 3000
	chem_volume = 20
	brand = "Havana"

/obj/item/clothing/mask/smokable/cigarette/cigar/havana/populate_reagents()
	add_to_reagents(/decl/material/solid/tobacco/fine, 10)

/obj/item/trash/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/clothing/mask/smokables/cigarette_butt.dmi'
	icon_state = ICON_STATE_WORLD
	randpixel = 10
	w_class = ITEM_SIZE_TINY
	slot_flags = SLOT_EARS
	var/use_color = TRUE

/obj/item/trash/cigbutt/Initialize()
	. = ..()
	transform = turn(transform,rand(0,360))

/obj/item/trash/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon = 'icons/clothing/mask/smokables/cigar_butt.dmi'

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(var/obj/item/W, var/mob/user)
	..()
	user.update_equipment_overlay(slot_wear_mask_str, FALSE)
	user.update_inhand_overlays()

//Bizarre
/obj/item/clothing/mask/smokable/cigarette/rolled/sausage
	name = "sausage"
	desc = "A piece of mixed, long meat, with a smoky scent."
	icon = 'icons/clothing/mask/smokables/sausage.dmi'
	type_butt = /obj/item/trash/cigbutt/sausagebutt
	chem_volume = 6
	smoketime = 5000
	brand = "sausage... wait what."

/obj/item/clothing/mask/smokable/cigarette/rolled/sausage/populate_reagents()
	add_to_reagents(/decl/material/solid/organic/meat, 6)

/obj/item/trash/cigbutt/sausagebutt
	name = "sausage butt"
	desc = "A piece of burnt meat."
	icon = 'icons/clothing/mask/smokables/sausage.dmi'

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A pipe, for smoking. Probably made of meershaum or something."
	icon = 'icons/clothing/mask/smokables/pipe.dmi'
	w_class = ITEM_SIZE_TINY
	smoketime = 0
	chem_volume = 50
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/pipe/Initialize()
	. = ..()
	SetName("empty [initial(name)]")

/obj/item/clothing/mask/smokable/pipe/isflamesource(atom/A)
	. = FALSE

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if(!lit && smoketime)
		if(submerged())
			to_chat(usr, SPAN_WARNING("You cannot light \the [src] underwater."))
			return
		lit = TRUE
		atom_damage_type = BURN
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		START_PROCESSING(SSobj, src)
		if(ismob(loc))
			var/mob/living/M = loc
			M.update_equipment_overlay(slot_wear_mask_str, FALSE)
			M.update_inhand_overlays()
		set_scent_by_reagents(src)
		update_icon()

/obj/item/clothing/mask/smokable/pipe/extinguish(var/mob/user, var/no_message)
	..()
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	if(ismob(loc))
		var/mob/living/M = loc
		if (!no_message)
			to_chat(M, SPAN_NOTICE("Your [name] goes out, and you empty the ash."))
	remove_extension(src, /datum/extension/scent)

/obj/item/clothing/mask/smokable/pipe/attack_self(var/mob/user)
	if(lit == 1)
		user.visible_message(SPAN_NOTICE("[user] puts out [src]."), SPAN_NOTICE("You put out [src]."))
		lit = FALSE
		update_icon()
		STOP_PROCESSING(SSobj, src)
		remove_extension(src, /datum/extension/scent)
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message(SPAN_NOTICE("[user] empties out [src]."), SPAN_NOTICE("You empty out [src]."))
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = 0
		reagents.clear_reagents()
		SetName("empty [initial(name)]")

/obj/item/clothing/mask/smokable/pipe/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/energy_blade/sword))
		return

	..()

	if (istype(W, /obj/item/food))
		var/obj/item/food/grown/grown = W
		if (!grown.dry)
			to_chat(user, SPAN_NOTICE("\The [grown] must be dried before you stuff it into \the [src]."))
			return
		if (smoketime)
			to_chat(user, SPAN_NOTICE("\The [src] is already packed."))
			return
		smoketime = 1000
		if(grown.reagents)
			grown.reagents.trans_to_obj(src, grown.reagents.total_volume)
		SetName("[grown.name]-packed [initial(name)]")
		qdel(grown)

	else if(istype(W, /obj/item/flame/fuelled/lighter))
		var/obj/item/flame/fuelled/lighter/L = W
		if(L.lit)
			light(SPAN_NOTICE("[user] manages to light their [name] with [W]."))

	else if(istype(W, /obj/item/flame/match))
		var/obj/item/flame/match/M = W
		if(M.lit)
			light(SPAN_NOTICE("[user] lights their [name] with their [W]."))

	else if(istype(W, /obj/item/assembly/igniter))
		light(SPAN_NOTICE("[user] fiddles with [W], and manages to light their [name] with the power of science."))

	user.update_equipment_overlay(slot_wear_mask_str, FALSE)
	user.update_inhand_overlays()

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A nicotine delivery system popularized by folksy backwoodsmen, kept popular in the modern age and beyond by space hipsters."
	icon = 'icons/clothing/mask/smokables/pipe_cob.dmi'
	chem_volume = 35