var/global/list/_limb_mask_cache = list()
/proc/get_limb_mask_for(var/decl/bodytype/bodytype, var/bodypart)
	LAZYINITLIST(_limb_mask_cache[bodytype])
	if(!_limb_mask_cache[bodytype][bodypart])
		var/icon/limb_mask = icon(bodytype.icon_base, bodypart)
		limb_mask.MapColors(0,0,0, 0,0,0, 0,0,0, 1,1,1)
		_limb_mask_cache[bodytype][bodypart] = limb_mask
	return _limb_mask_cache[bodytype][bodypart]

/*
	Global associative list for caching humanoid icons.
	Index format m or f, followed by a string of 0 and 1 to represent bodyparts followed by husk 1 or 0.
	TODO: Proper documentation
	icon_key is [bodytype.get_icon_cache_uid(src)][g][husk][skin_tone]
*/
var/global/list/human_icon_cache = list()
var/global/list/tail_icon_cache = list() //key is [bodytype.get_icon_cache_uid(src)][skin_colour]
var/global/list/light_overlay_cache = list()

/proc/overlay_image(icon,icon_state,color,flags)
	var/image/ret = image(icon,icon_state)
	ret.color = color
	ret.appearance_flags = flags
	return ret

	///////////////////////
	//UPDATE_ICONS SYSTEM//
	///////////////////////
/*
Calling this  a system is perhaps a bit trumped up. It is essentially update_clothing dismantled into its
core parts. The key difference is that when we generate overlays we do not generate either lying or standing
versions. Instead, we generate both and store them in two fixed-length lists, both using the same list-index
(The indexes are in update_icons.dm): Each list for humans is (at the time of writing) of length 19.
This will hopefully be reduced as the system is refined.

	var/overlays_lying[19]			//For the lying down stance
	var/overlays_standing[19]		//For the standing stance

When we call update_icons, the 'lying' variable is checked and then the appropriate list is assigned to our overlays!
That in itself uses a tiny bit more memory (no more than all the ridiculous lists the game has already mind you).

On the other-hand, it should be very CPU cheap in comparison to the old system.
In the old system, we updated all our overlays every life() call, even if we were standing still inside a crate!
or dead!. 25ish overlays, all generated from scratch every second for every xeno/human/monkey and then applied.
More often than not update_clothing was being called a few times in addition to that! CPU was not the only issue,
all those icons had to be sent to every client. So really the cost was extremely cumulative. To the point where
update_clothing would frequently appear in the top 10 most CPU intensive procs during profiling.

Another feature of this new system is that our lists are indexed. This means we can update specific overlays!
So we only regenerate icons when we need them to be updated! This is the main saving for this system.

In practice this means that:
	everytime you fall over, we just switch between precompiled lists. Which is fast and cheap.
	Everytime you do something minor like take a pen out of your pocket, we only update the in-hand overlay
	etc...


There are several things that need to be remembered:

>	Whenever we do something that should cause an overlay to update (which doesn't use standard procs
	( i.e. you do something like l_hand = /obj/item/something new(src) )
	You will need to call the relevant update_inv_* proc:
		update_inv_head()
		update_inv_wear_suit()
		update_inv_gloves()
		update_inv_shoes()
		update_inv_w_uniform()
		update_inv_glasse()
		update_inv_hands()
		update_inv_belt()
		update_inv_wear_id()
		update_inv_ears()
		update_inv_s_store()
		update_inv_pockets()
		update_inv_back()
		update_inv_handcuffed()
		update_inv_wear_mask()

	All of these are named after the variable they update from. They are defined at the mob/ level like
	update_clothing was, so you won't cause undefined proc runtimes with usr.update_inv_wear_id() if the usr is a
	slime etc. Instead, it'll just return without doing any work. So no harm in calling it for slimes and such.


>	There are also these special cases:
		update_mutations()	//handles updating your appearance for certain mutations.  e.g TK head-glows
		UpdateDamageIcon()	//handles damage overlays for brute/burn damage //(will rename this when I geta round to it)
		update_body()	//Handles updating your mob's icon to reflect their gender/race/complexion etc
		update_hair()	//Handles updating your hair overlay (used to be update_face, but mouth and
																			...eyes were merged into update_body)
		update_targeted() // Updates the target overlay when someone points a gun at you

>	All of these procs update our overlays_lying and overlays_standing, and then call update_icon() by default.
	If you wish to update several overlays at once, you can set the argument to 0 to disable the update and call
	it manually:
		e.g.
		update_inv_head(0)
		update_inv_hands()		//<---calls update_icon()

	or equivillantly:
		update_inv_head(0)
		update_inv_hands(0)
		update_icon()

>	If you need to update all overlays you can use refresh_visible_overlays(). it works exactly like update_clothing used to.

>	I reimplimented an old unused variable which was in the code called (coincidentally) var/update_icon
	It can be used as another method of triggering update_icon(). It's basically a flag that when set to non-zero
	will call update_icon() at the next life() call and then reset itself to 0.
	The idea behind it is icons are regenerated only once, even if multiple events requested it.

This system is confusing and is still a WIP. It's primary goal is speeding up the controls of the game whilst
reducing processing costs. So please bear with me while I iron out the kinks. It will be worth it, I promise.
If I can eventually free var/lying stuff from the life() process altogether, stuns/death/status stuff
will become less affected by lag-spikes and will be instantaneous! :3

If you have any questions/constructive-comments/bugs-to-report/or have a massivly devestated butt...
Please contact me on #coderbus IRC. ~Carn x
*/

//Human Overlays Indexes/////////
#define HO_MUTATIONS_LAYER  1
#define HO_SKIN_LAYER       2
#define HO_DAMAGE_LAYER     3
#define HO_SURGERY_LAYER    4 //bs12 specific.
#define HO_UNDERWEAR_LAYER  5
#define HO_UNIFORM_LAYER    6
#define HO_ID_LAYER         7
#define HO_SHOES_LAYER      8
#define HO_GLOVES_LAYER     9
#define HO_BELT_LAYER       10
#define HO_SUIT_LAYER       11
#define HO_GLASSES_LAYER    12
#define HO_BELT_LAYER_ALT   13
#define HO_SUIT_STORE_LAYER 14
#define HO_BACK_LAYER       15
#define HO_TAIL_LAYER       16 //bs12 specific. this hack is probably gonna come back to haunt me
#define HO_HAIR_LAYER       17 //TODO: make part of head layer?
#define HO_GOGGLES_LAYER    18
#define HO_EARS_LAYER       19
#define HO_FACEMASK_LAYER   20
#define HO_HEAD_LAYER       21
#define HO_COLLAR_LAYER     22
#define HO_HANDCUFF_LAYER   23
#define HO_INHAND_LAYER     24
#define HO_FIRE_LAYER       25 //If you're on fire
#define TOTAL_OVER_LAYERS   25
//////////////////////////////////

// Underlay defines; vestigal implementation currently.
#define HU_TAIL_LAYER 1
#define TOTAL_UNDER_LAYERS 1

/mob/living/carbon/human
	var/list/overlays_standing[TOTAL_OVER_LAYERS]
	var/list/underlays_standing[TOTAL_UNDER_LAYERS]
	var/previous_damage_appearance // store what the body last looked like, so we only have to update it if something changed

/mob/living/carbon/human/proc/refresh_visible_overlays()

	if(HasMovementHandler(/datum/movement_handler/mob/transformation) || QDELETED(src))
		return

	update_mutations(FALSE)
	update_body(FALSE)
	update_skin(FALSE)
	update_underwear(FALSE)
	update_hair(FALSE)
	update_inv_w_uniform(FALSE)
	update_inv_wear_id(FALSE)
	update_inv_gloves(FALSE)
	update_inv_glasses(FALSE)
	update_inv_ears(FALSE)
	update_inv_shoes(FALSE)
	update_inv_s_store(FALSE)
	update_inv_wear_mask(FALSE)
	update_inv_head(FALSE)
	update_inv_belt(FALSE)
	update_inv_back(FALSE)
	update_inv_wear_suit(FALSE)
	update_inv_hands(FALSE)
	update_inv_handcuffed(FALSE)
	update_inv_pockets(FALSE)
	update_fire(FALSE)
	update_surgery(FALSE)
	update_bandages(FALSE)
	UpdateDamageIcon(FALSE)
	update_icon()

/mob/living/carbon/human/on_update_icon()

	..()

	if(regenerate_body_icon)
		regenerate_body_icon = FALSE
		update_body(FALSE)
		refresh_visible_overlays()

	var/list/visible_overlays
	var/list/visible_underlays
	if(is_cloaked())
		icon = 'icons/mob/human.dmi'
		icon_state = "blank"
		visible_overlays = overlays_standing[HO_INHAND_LAYER]
	else
		icon = stand_icon
		icon_state = null
		visible_overlays = overlays_standing
		visible_underlays = underlays_standing

	var/matrix/M = matrix()
	if(lying && (bodytype.prone_overlay_offset[1] || bodytype.prone_overlay_offset[2]))
		M.Translate(bodytype.prone_overlay_offset[1], bodytype.prone_overlay_offset[2])

	for(var/i = 1 to LAZYLEN(visible_overlays))
		var/entry = visible_overlays[i]
		if(istype(entry, /image))
			var/image/overlay = entry
			if(i != HO_DAMAGE_LAYER)
				overlay.transform = M
			add_overlay(entry)
		else if(islist(entry))
			for(var/image/overlay in entry)
				if(i != HO_DAMAGE_LAYER)
					overlay.transform = M
				add_overlay(overlay)

	for(var/i = 1 to LAZYLEN(visible_underlays))
		var/entry = visible_underlays[i]
		if(istype(entry, /image))
			var/image/underlay = entry
			underlay.transform = M
		else if(islist(entry))
			for(var/image/underlay in entry)
				underlay.transform = M
	underlays = visible_underlays

	var/obj/item/organ/external/head/head = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(head)
		var/image/I = head.get_eye_overlay()
		if(I)
			add_overlay(I)

/mob/living/carbon/human/proc/get_icon_scale_mult()
	// If you want stuff like scaling based on species or something, here is a good spot to mix the numbers together.
	return list(icon_scale_x, icon_scale_y)

/mob/living/carbon/human/update_transform()

	// First, get the correct size.
	var/list/icon_scale_values = get_icon_scale_mult()
	var/desired_scale_x = icon_scale_values[1]
	var/desired_scale_y = icon_scale_values[2]

	// Apply KEEP_TOGETHER so all the component overlays move properly when
	// applying a transform, or remove it if we aren't doing any transforms
	// (due to cost).
	if(!lying && desired_scale_x == 1 && desired_scale_y == 1)
		appearance_flags &= ~KEEP_TOGETHER
	else
		appearance_flags |= KEEP_TOGETHER

	// Scale/translate/rotate and apply the transform.
	var/matrix/M = matrix()
	if(lying)
		var/turn_angle
		if(dir & WEST)
			turn_angle = -90
		else if(dir & EAST)
			turn_angle = 90
		else
			turn_angle = pick(-90, 90)
		M.Turn(turn_angle)
		M.Scale(desired_scale_y, desired_scale_x)
		M.Translate(turn_angle == 90 ? 1 : -2, (turn_angle == 90 ? -6 : -5) - default_pixel_z)
	else
		M.Scale(desired_scale_x, desired_scale_y)
		M.Translate(0, 16 * (desired_scale_y - 1))

	if(transform_animate_time)
		animate(src, transform = M, time = transform_animate_time)
	else
		transform = M

	return transform

var/global/list/damage_icon_parts = list()

//DAMAGE OVERLAYS
//constructs damage icon for each organ from mask * damage field and saves it in our overlays_ lists
/mob/living/carbon/human/UpdateDamageIcon(var/update_icons=1)

	// first check whether something actually changed about damage appearance
	var/damage_appearance = ""
	for(var/obj/item/organ/external/O in get_external_organs())
		damage_appearance += O.damage_state

	if(damage_appearance == previous_damage_appearance)
		// nothing to do here
		return

	previous_damage_appearance = damage_appearance

	var/image/standing_image = image(bodytype.get_damage_overlays(src), icon_state = "00")

	// blend the individual damage states with our icons
	for(var/obj/item/organ/external/O in get_external_organs())
		O.update_damstate()
		O.update_icon()
		if(O.damage_state == "00")
			continue
		var/icon/DI
		var/use_colour = (BP_IS_PROSTHETIC(O) ? SYNTH_BLOOD_COLOR : O.species.get_blood_color(src))
		var/cache_index = "[O.damage_state]/[O.bodytype.type]/[O.icon_state]/[use_colour]/[species.name]"
		if(damage_icon_parts[cache_index] == null)
			DI = new /icon(bodytype.get_damage_overlays(src), O.damage_state) // the damage icon for whole human
			DI.Blend(get_limb_mask_for(O.bodytype, O.icon_state), ICON_MULTIPLY)  // mask with this organ's pixels
			DI.Blend(use_colour, ICON_MULTIPLY)
			damage_icon_parts[cache_index] = DI
		else
			DI = damage_icon_parts[cache_index]

		standing_image.overlays += DI

	overlays_standing[HO_DAMAGE_LAYER]	= standing_image
	update_bandages(update_icons)
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/update_bandages(var/update_icons=1)
	var/bandage_icon = bodytype.get_bandages_icon(src)
	if(!bandage_icon)
		return
	var/image/standing_image = overlays_standing[HO_DAMAGE_LAYER]
	if(standing_image)
		for(var/obj/item/organ/external/O in get_external_organs())
			var/bandage_level = O.bandage_level()
			if(bandage_level)
				standing_image.overlays += image(bandage_icon, "[O.icon_state][bandage_level]")

		overlays_standing[HO_DAMAGE_LAYER]	= standing_image
	if(update_icons)
		queue_icon_update()

//BASE MOB SPRITE
/mob/living/carbon/human/update_body(var/update_icons=1)

	var/list/limbs = get_external_organs()
	if(!LAZYLEN(limbs))
		return // Something is trying to update our body pre-init (probably loading a preview image during world startup).

	var/husk_color_mod = rgb(96,88,80)
	var/husk = is_husked()

	//CACHING: Generate an index key from visible bodyparts.
	//0 = destroyed, 1 = normal, 2 = robotic, 3 = necrotic.

	//Create a new, blank icon for our mob to use.
	if(stand_icon)
		qdel(stand_icon)
	stand_icon = new(bodytype.icon_template || 'icons/mob/human.dmi',"blank")

	var/icon_key = "[bodytype.get_icon_cache_uid(src)][skin_tone][skin_colour]"
	if(lip_style)
		icon_key += "[lip_style]"
	else
		icon_key += "nolips"
	var/obj/item/organ/internal/eyes/eyes = get_organ((species.vision_organ || BP_EYES), /obj/item/organ/internal/eyes)
	icon_key += istype(eyes) ? eyes.eye_colour : COLOR_BLACK

	for(var/limb_tag in global.all_limb_tags)
		var/obj/item/organ/external/part = GET_EXTERNAL_ORGAN(src, limb_tag)
		if(isnull(part) || part.skip_body_icon_draw)
			icon_key += "0"
			continue
		for(var/M in part.markings)
			icon_key += "[M][part.markings[M]]"
		if(part)
			icon_key += "[part.bodytype.get_icon_cache_uid(part.owner)][part.render_alpha]"
			icon_key += "[part.skin_tone]"
			if(part.skin_colour)
				icon_key += "[part.skin_colour]"
				icon_key += "[part.skin_blend]"
			for(var/M in part.markings)
				icon_key += "[M][part.markings[M]]"
		if(BP_IS_PROSTHETIC(part))
			icon_key += "2[part.model ? "-[part.model]": ""]"
		else if(part.status & ORGAN_DEAD)
			icon_key += "3"
		else
			icon_key += "1"

	icon_key = "[icon_key][husk ? 1 : 0]"

	var/icon/base_icon
	if(human_icon_cache[icon_key])
		base_icon = human_icon_cache[icon_key]
	else
		//BEGIN CACHED ICON GENERATION.
		base_icon = icon(bodytype.icon_template)
		for(var/obj/item/organ/external/part in limbs)
			var/icon/temp = part.get_icon()
			//That part makes left and right legs drawn topmost and lowermost when human looks WEST or EAST
			//And no change in rendering for other parts (they icon_position is 0, so goes to 'else' part)
			if(part.icon_position & (LEFT | RIGHT))
				var/icon/temp2 = icon(bodytype.icon_template)
				temp2.Insert(new /icon(temp,dir=NORTH),dir=NORTH)
				temp2.Insert(new /icon(temp,dir=SOUTH),dir=SOUTH)
				if(!(part.icon_position & LEFT))
					temp2.Insert(new /icon(temp,dir=EAST),dir=EAST)
				if(!(part.icon_position & RIGHT))
					temp2.Insert(new /icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_OVERLAY)
				if(part.icon_position & LEFT)
					temp2.Insert(new /icon(temp,dir=EAST),dir=EAST)
				if(part.icon_position & RIGHT)
					temp2.Insert(new /icon(temp,dir=WEST),dir=WEST)
				base_icon.Blend(temp2, ICON_UNDERLAY)
			else if(part.icon_position & UNDER)
				base_icon.Blend(temp, ICON_UNDERLAY)
			else
				base_icon.Blend(temp, ICON_OVERLAY)

		if(husk)
			base_icon.ColorTone(husk_color_mod)

		//Handle husk overlay.
		if(husk)
			var/husk_icon = bodytype.get_husk_icon(src)
			if(husk_icon)
				var/icon/mask = new(base_icon)
				var/icon/husk_over = new(husk_icon, "")
				mask.MapColors(0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,0)
				husk_over.Blend(mask, ICON_ADD)
				base_icon.Blend(husk_over, ICON_OVERLAY)

		human_icon_cache[icon_key] = base_icon

	//END CACHED ICON GENERATION.
	stand_icon.Blend(base_icon,ICON_OVERLAY)

	//tail
	update_tail_showing(0)
	..()

//UNDERWEAR OVERLAY

/mob/living/carbon/human/proc/update_underwear(var/update_icons=1)
	overlays_standing[HO_UNDERWEAR_LAYER] = list()
	for(var/entry in worn_underwear)
		var/obj/item/underwear/UW = entry
		if (!UW || !UW.icon) // Avoid runtimes for nude underwear types
			continue
		var/image/I
		if(UW.slot_offset_str && LAZYACCESS(bodytype.equip_adjust, UW.slot_offset_str))
			I = bodytype.get_offset_overlay_image(FALSE, UW.icon, UW.icon_state, UW.color, UW.slot_offset_str)
		else
			I = image(icon = UW.icon, icon_state = UW.icon_state)
			I.color = UW.color
		I.appearance_flags |= RESET_COLOR
		overlays_standing[HO_UNDERWEAR_LAYER] += I

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_hair(var/update_icons=1)
	//Reset our hair
	overlays_standing[HO_HAIR_LAYER]	= null

	var/obj/item/organ/external/head/head_organ = get_organ(BP_HEAD, /obj/item/organ/external/head)
	if(!head_organ)
		if(update_icons)
			queue_icon_update()
		return

	overlays_standing[HO_HAIR_LAYER] = head_organ.get_hair_icon()
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/update_skin(var/update_icons=1)
	overlays_standing[HO_SKIN_LAYER] = species.update_skin(src)
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_mutations(var/update_icons=1)

	var/image/standing	= overlay_image('icons/effects/genetics.dmi', flags=RESET_COLOR)
	var/add_image = 0
	var/g = "m"
	if(gender == FEMALE)	g = "f"
	// DNA2 - Drawing underlays.
	var/list/all_genes = decls_repository.get_decls_of_subtype(/decl/gene)
	for(var/gene_type in all_genes)
		var/decl/gene/gene = all_genes[gene_type]
		if(!gene.block)
			continue
		if(gene.is_active(src))
			var/underlay=gene.OnDrawUnderlays(src,g)
			if(underlay)
				standing.underlays += underlay
				add_image = 1

	if(add_image)
		overlays_standing[HO_MUTATIONS_LAYER]	= standing
	else
		overlays_standing[HO_MUTATIONS_LAYER]	= null
	if(update_icons)
		queue_icon_update()

/* --------------------------------------- */
//vvvvvv UPDATE_INV PROCS vvvvvv

/mob/living/carbon/human/update_inv_w_uniform(var/update_icons=1)
	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(uniform && (!suit || !(suit.flags_inv & HIDEJUMPSUIT)))
		overlays_standing[HO_UNIFORM_LAYER]	= uniform.get_mob_overlay(src,slot_w_uniform_str)
	else
		overlays_standing[HO_UNIFORM_LAYER]	= null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_wear_id(var/update_icons=1)
	overlays_standing[HO_ID_LAYER] = null
	var/obj/item/id = get_equipped_item(slot_wear_id_str)
	if(id)
		var/obj/item/clothing/under/U = get_equipped_item(slot_w_uniform_str)
		if(istype(U) && !U.displays_id && !U.rolled_down)
			return
		overlays_standing[HO_ID_LAYER] = id.get_mob_overlay(src, slot_wear_id_str)
	BITSET(hud_updateflag, ID_HUD)
	BITSET(hud_updateflag, WANTED_HUD)

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_gloves(var/update_icons=1)
	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	var/obj/item/gloves = get_equipped_item(slot_gloves_str)
	if(gloves && !(suit && suit.flags_inv & HIDEGLOVES))
		overlays_standing[HO_GLOVES_LAYER]	= gloves.get_mob_overlay(src,slot_gloves_str)
	else
		var/list/blood_color
		for(var/obj/item/organ/external/grabber in get_hands_organs())
			if(grabber.coating)
				blood_color = grabber.coating.get_color()

		overlays_standing[HO_GLOVES_LAYER]	= null
		if(blood_color)
			var/mob_blood_overlay = bodytype.get_blood_overlays(src)
			if(mob_blood_overlay)
				var/image/bloodsies	= overlay_image(mob_blood_overlay, "bloodyhands", blood_color, RESET_COLOR)
				overlays_standing[HO_GLOVES_LAYER]	= bloodsies

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_glasses(var/update_icons=1)
	var/obj/item/glasses = get_equipped_item(slot_glasses_str)
	if(glasses)
		overlays_standing[glasses.use_alt_layer ? HO_GOGGLES_LAYER : HO_GLASSES_LAYER] = glasses.get_mob_overlay(src,slot_glasses_str)
		overlays_standing[glasses.use_alt_layer ? HO_GLASSES_LAYER : HO_GOGGLES_LAYER] = null
	else
		overlays_standing[HO_GLASSES_LAYER]	= null
		overlays_standing[HO_GOGGLES_LAYER]	= null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_ears(var/update_icons=1)

	overlays_standing[HO_EARS_LAYER] = null
	for(var/slot in global.airtight_slots)
		var/obj/item/gear = get_equipped_item(slot)
		if(gear && (gear.flags_inv & (BLOCK_ALL_HAIR)))
			if(update_icons)
				queue_icon_update()
			return

	var/image/both
	for(var/slot in global.ear_slots)
		var/obj/item/ear = get_equipped_item(slot)
		if(ear)
			if(!both)
				both = image("icon" = 'icons/effects/effects.dmi', "icon_state" = "nothing")
			both.overlays += ear.get_mob_overlay(src, slot)

	if(both)
		overlays_standing[HO_EARS_LAYER] = both
	else
		overlays_standing[HO_EARS_LAYER]	= null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_shoes(var/update_icons=1)
	var/obj/item/shoes =   get_equipped_item(slot_shoes_str)
	var/obj/item/suit =    get_equipped_item(slot_wear_suit_str)
	var/obj/item/uniform = get_equipped_item(slot_w_uniform_str)
	if(shoes && !((suit && suit.flags_inv & HIDESHOES) || (uniform && uniform.flags_inv & HIDESHOES)))
		overlays_standing[HO_SHOES_LAYER] = shoes.get_mob_overlay(src,slot_shoes_str)
	else
		var/list/blood_color
		for(var/foot_tag in list(BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/stomper = GET_EXTERNAL_ORGAN(src, foot_tag)
			if(stomper && stomper.coating)
				blood_color = stomper.coating.get_color()

		overlays_standing[HO_SHOES_LAYER] = null
		if(blood_color)
			var/mob_blood_overlay = bodytype.get_blood_overlays(src)
			if(mob_blood_overlay)
				var/image/bloodsies = overlay_image(mob_blood_overlay, "shoeblood", blood_color, RESET_COLOR)
				overlays_standing[HO_SHOES_LAYER] = bloodsies
		else
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_s_store(var/update_icons=1)
	var/obj/item/stored = get_equipped_item(slot_s_store_str)
	if(stored)
		overlays_standing[HO_SUIT_STORE_LAYER] = stored.get_mob_overlay(src, slot_belt_str)
	else
		overlays_standing[HO_SUIT_STORE_LAYER] = null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_head(var/update_icons=1)
	var/obj/item/head = get_equipped_item(slot_head_str)
	if(head)
		overlays_standing[HO_HEAD_LAYER] = head.get_mob_overlay(src,slot_head_str)
	else
		overlays_standing[HO_HEAD_LAYER]	= null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_belt(var/update_icons=1)
	var/obj/item/belt = get_equipped_item(slot_belt_str)
	if(belt)
		overlays_standing[belt.use_alt_layer ? HO_BELT_LAYER_ALT : HO_BELT_LAYER] = belt.get_mob_overlay(src,slot_belt_str)
		overlays_standing[belt.use_alt_layer ? HO_BELT_LAYER : HO_BELT_LAYER_ALT] = null
	else
		overlays_standing[HO_BELT_LAYER] = null
		overlays_standing[HO_BELT_LAYER_ALT] = null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_wear_suit(var/update_icons=1)
	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	if(suit)
		overlays_standing[HO_SUIT_LAYER] = suit.get_mob_overlay(src,slot_wear_suit_str)
		update_tail_showing(0)
	else
		overlays_standing[HO_SUIT_LAYER] = null
		update_tail_showing(0)
		update_inv_w_uniform(0)
		update_inv_shoes(0)
		update_inv_gloves(0)

	update_collar(0)

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_pockets(var/update_icons=1)
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_wear_mask(var/update_icons=1)
	var/obj/item/mask = get_equipped_item(slot_wear_mask_str)
	var/obj/item/head = get_equipped_item(slot_head_str)
	update_hair(0)	//rebuild hair
	update_inv_ears(0)

	if(!(mask && (mask.item_flags & ITEM_FLAG_AIRTIGHT)))
		set_internals(null)

	if(mask && !(head && head.flags_inv & HIDEMASK))
		overlays_standing[HO_FACEMASK_LAYER] = mask.get_mob_overlay(src,slot_wear_mask_str)
	else
		overlays_standing[HO_FACEMASK_LAYER] = null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_back(var/update_icons=1)
	var/obj/item/back = get_equipped_item(slot_back_str)
	if(back)
		overlays_standing[HO_BACK_LAYER] = back.get_mob_overlay(src,slot_back_str)
	else
		overlays_standing[HO_BACK_LAYER] = null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_handcuffed(var/update_icons=1)
	var/obj/item/cuffs = get_equipped_item(slot_handcuffed_str)
	if(cuffs)
		overlays_standing[HO_HANDCUFF_LAYER] = cuffs.get_mob_overlay(src,slot_handcuffed_str)
	else
		overlays_standing[HO_HANDCUFF_LAYER] = null
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_inv_hands(var/update_icons=1)
	overlays_standing[HO_INHAND_LAYER] = null
	for(var/hand_slot in get_held_item_slots())
		var/datum/inventory_slot/inv_slot = get_inventory_slot_datum(hand_slot)
		var/obj/item/held = inv_slot?.get_equipped_item()
		if(istype(held))
			// This should be moved out of icon code
			if(get_equipped_item(slot_handcuffed_str))
				drop_from_inventory(held)
				continue
			var/image/standing = held.get_mob_overlay(src, inv_slot.overlay_slot, hand_slot)
			if(standing)
				standing.appearance_flags |= RESET_ALPHA
				LAZYADD(overlays_standing[HO_INHAND_LAYER], standing)

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/update_tail_showing(var/update_icons=1)
	overlays_standing[HO_TAIL_LAYER] =  null
	underlays_standing[HU_TAIL_LAYER] = null
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!istype(tail_organ))
		return
	var/obj/item/suit = get_equipped_item(slot_wear_suit_str)
	var/tail_state = tail_organ.get_tail(tail_organ)
	if(tail_state && (!suit || !(suit.flags_inv & HIDETAIL)))
		var/icon/tail_s = get_tail_icon(tail_organ)
		var/tail_image = image(tail_s, icon_state = "[tail_state]_s")
		if(dir == NORTH)
			overlays_standing[HO_TAIL_LAYER] = tail_image
		else
			underlays_standing[HU_TAIL_LAYER] = tail_image
		animate_tail_reset(0)

	if(update_icons)
		update_icon()

/mob/living/carbon/human/proc/get_tail_icon(var/obj/item/organ/external/tail/tail_organ)
	if(!istype(tail_organ))
		return
	var/icon_key = "[tail_organ.get_tail()]\ref[tail_organ.icon][tail_organ.get_tail_blend(src)][species.appearance_flags & HAS_SKIN_COLOR][skin_colour][tail_organ.get_tail_hair()][tail_organ.get_tail_hair_blend()][hair_colour]"
	var/icon/tail_icon = tail_icon_cache[icon_key]
	if(!tail_icon)
		//generate a new one
		var/tail_anim = tail_organ.get_tail_animation() || tail_organ.get_tail_icon()
		tail_icon = new/icon(tail_anim)
		if(species.appearance_flags & HAS_SKIN_COLOR)
			tail_icon.Blend(skin_colour, tail_organ.get_tail_blend(src))
		// The following will not work with animated tails.
		var/use_tail = tail_organ.get_tail_hair()
		if(use_tail)
			var/icon/hair_icon = icon(tail_organ.get_tail_icon(src), "[tail_organ.get_tail()]_[use_tail]")
			hair_icon.Blend(hair_colour, tail_organ.get_tail_hair_blend())
			tail_icon.Blend(hair_icon, ICON_OVERLAY)
		tail_icon_cache[icon_key] = tail_icon

	return tail_icon

/mob/living/carbon/human/set_dir()
	. = ..()
	if(.)
		var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
		if(tail_organ && tail_organ.get_tail())
			update_tail_showing()


/mob/living/carbon/human/proc/set_tail_state(var/t_state)
	var/image/tail_overlay = overlays_standing[HO_TAIL_LAYER] || underlays_standing[HU_TAIL_LAYER]
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return null

	if(tail_overlay && tail_organ.get_tail_animation())
		tail_overlay.icon_state = t_state
		return tail_overlay

//Not really once, since BYOND can't do that.
//Update this if the ability to flick() images or make looping animation start at the first frame is ever added.
/mob/living/carbon/human/proc/animate_tail_once(var/update_icons=1)
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return
	var/t_state = "[tail_organ.get_tail()]_once"

	var/image/tail_overlay = overlays_standing[HO_TAIL_LAYER] || underlays_standing[HU_TAIL_LAYER]
	if(tail_overlay && tail_overlay.icon_state == t_state)
		return //let the existing animation finish

	tail_overlay = set_tail_state(t_state)
	if(tail_overlay)
		spawn(20)
			//check that the animation hasn't changed in the meantime
			var/current_tail = overlays_standing[HO_TAIL_LAYER] || underlays_standing[HU_TAIL_LAYER]
			if(current_tail == tail_overlay && tail_overlay.icon_state == t_state)
				animate_tail_stop()

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/animate_tail_start(var/update_icons=1)
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return
	var/tail_states = tail_organ.get_tail_states()
	if(tail_states)
		set_tail_state("[tail_organ.get_tail()]_slow[rand(1, tail_states)]")
		if(update_icons)
			queue_icon_update()

/mob/living/carbon/human/proc/animate_tail_fast(var/update_icons=1)
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return
	var/tail_states = tail_organ.get_tail_states()
	if(tail_states)
		set_tail_state("[tail_organ.get_tail()]_loop[rand(1, tail_states)]")
		if(update_icons)
			queue_icon_update()

/mob/living/carbon/human/proc/animate_tail_reset(var/update_icons=1)
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return
	var/tail_states = tail_organ.get_tail_states(src)
	if(stat != DEAD && tail_states)
		set_tail_state("[tail_organ.get_tail()]_idle[rand(1, tail_states)]")
	else
		set_tail_state("[tail_organ.get_tail()]_static")

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/animate_tail_stop(var/update_icons=1)
	var/obj/item/organ/external/tail/tail_organ = get_organ(BP_TAIL, /obj/item/organ/external/tail)
	if(!tail_organ)
		return
	set_tail_state("[tail_organ.get_tail()]_static")

//Adds a collar overlay above the helmet layer if the suit has one
//	Suit needs an identically named sprite in icons/mob/collar.dmi
/mob/living/carbon/human/proc/update_collar(var/update_icons=1)
	var/obj/item/clothing/suit/S = get_equipped_item(slot_wear_suit_str)
	if(istype(S))
		overlays_standing[HO_COLLAR_LAYER]	= S.get_collar()
	else
		overlays_standing[HO_COLLAR_LAYER]	= null

	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/update_fire(var/update_icons=1)
	overlays_standing[HO_FIRE_LAYER] = null
	if(on_fire)
		var/image/standing = overlay_image(bodytype.get_ignited_icon(src) || 'icons/mob/OnFire.dmi', "Standing", RESET_COLOR)
		overlays_standing[HO_FIRE_LAYER] = standing
	if(update_icons)
		queue_icon_update()

/mob/living/carbon/human/proc/update_surgery(var/update_icons=1)
	overlays_standing[HO_SURGERY_LAYER] = null
	var/image/total = new
	for(var/obj/item/organ/external/E in get_external_organs())
		if(BP_IS_PROSTHETIC(E))
			continue
		var/how_open = round(E.how_open())
		if(how_open <= 0)
			continue
		var/surgery_icon = E.species.get_surgery_overlay_icon(src)
		if(!surgery_icon)
			continue
		var/base_state = "[E.icon_state][how_open]"
		var/overlay_state = "[base_state]-flesh"
		var/list/overlays_to_add
		if(check_state_in_icon(overlay_state, surgery_icon))
			var/image/flesh = image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER)
			flesh.color = E.species.get_flesh_colour(src)
			LAZYADD(overlays_to_add, flesh)
		overlay_state = "[base_state]-blood"
		if(check_state_in_icon(overlay_state, surgery_icon))
			var/image/blood = image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER)
			blood.color = E.species.get_blood_color(src)
			LAZYADD(overlays_to_add, blood)
		overlay_state = "[base_state]-bones"
		if(check_state_in_icon(overlay_state, surgery_icon))
			LAZYADD(overlays_to_add, image(icon = surgery_icon, icon_state = overlay_state, layer = -HO_SURGERY_LAYER))
		total.overlays |= overlays_to_add

	total.appearance_flags = RESET_COLOR
	overlays_standing[HO_SURGERY_LAYER] = total
	if(update_icons)
		queue_icon_update()

//Ported from hud login stuff
//
/mob/living/carbon/hud_reset(full_reset = FALSE)
	if(!(. = ..()))
		return .
	for(var/obj/item/gear in get_equipped_items(TRUE))
		client.screen |= gear
	if(hud_used)
		hud_used.hidden_inventory_update()
		hud_used.persistant_inventory_update()
		update_action_buttons()
	if(internals && internal)
		internals.icon_state = "internal1"
	queue_hand_rebuild()

//Human Overlays Indexes/////////
#undef HO_MUTATIONS_LAYER
#undef HO_SKIN_LAYER
#undef HO_DAMAGE_LAYER
#undef HO_SURGERY_LAYER
#undef HO_UNDERWEAR_LAYER
#undef HO_UNIFORM_LAYER
#undef HO_ID_LAYER
#undef HO_SHOES_LAYER
#undef HO_GLOVES_LAYER
#undef HO_BELT_LAYER
#undef HO_EARS_LAYER
#undef HO_SUIT_LAYER
#undef HO_GLASSES_LAYER
#undef HO_BELT_LAYER_ALT
#undef HO_SUIT_STORE_LAYER
#undef HO_BACK_LAYER
#undef HO_TAIL_LAYER
#undef HO_HAIR_LAYER
#undef HO_GOGGLES_LAYER
#undef HO_FACEMASK_LAYER
#undef HO_HEAD_LAYER
#undef HO_COLLAR_LAYER
#undef HO_HANDCUFF_LAYER
#undef HO_INHAND_LAYER
#undef HO_FIRE_LAYER
#undef TOTAL_OVER_LAYERS

#undef HU_TAIL_LAYER
#undef TOTAL_UNDER_LAYERS