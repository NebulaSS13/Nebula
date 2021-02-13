/obj/item/organ/external/arm/insectoid
	name = "left forelimb"
	amputation_point = "coxa"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/arm/right/insectoid
	name = "right forelimb"
	amputation_point = "coxa"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/leg/insectoid
	name = "left tail side"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/leg/right/insectoid
	name = "right tail side"
	encased = "carapace"

/obj/item/organ/external/foot/insectoid
	name = "left tail tip"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/foot/right/insectoid
	name = "right tail tip"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/hand/insectoid
	name = "left grasper"
	icon_position = LEFT
	encased = "carapace"

/obj/item/organ/external/hand/insectoid/midlimb
	name = "central grasper"
	joint = "central wrist"
	organ_tag = BP_M_HAND
	icon_name = BP_M_HAND
	parent_organ = BP_CHEST
	amputation_point = "central wrist"
	icon_position = 0
	encased = "carapace"
	gripper_ui_loc = "CENTER,BOTTOM+1:14"
	gripper_ui_label = "M"

/obj/item/organ/external/hand/insectoid/upper
	name = "left raptorial"
	joint = "left upper wrist"
	amputation_point = "left upper wrist"
	organ_tag = BP_L_HAND_UPPER
	icon_name = BP_L_HAND_UPPER
	gripper_ui_loc = "CENTER:16,BOTTOM+1:14"
	gripper_ui_label = "UL"

/obj/item/organ/external/hand/insectoid/upper/get_dexterity()
	. = DEXTERITY_GRIP
	if(model)
		. = min(., ..())

/obj/item/organ/external/hand/right/insectoid
	name = "right grasper"
	icon_position = RIGHT
	encased = "carapace"

/obj/item/organ/external/hand/right/insectoid/upper
	name = "right raptorial"
	joint = "right upper wrist"
	amputation_point = "right upper wrist"
	organ_tag = BP_R_HAND_UPPER
	icon_name = BP_R_HAND_UPPER
	gripper_ui_loc = "CENTER-1:16,BOTTOM+1:14"
	gripper_ui_label = "UR"

/obj/item/organ/external/hand/right/insectoid/upper/get_dexterity()
	. = DEXTERITY_GRIP
	if(model)
		. = min(., ..())

/obj/item/organ/external/groin/insectoid
	name = "abdomen"
	icon_position = UNDER
	encased = "carapace"

/obj/item/organ/external/head/insectoid
	name = "head"
	has_lips = 0
	encased = "carapace"

/obj/item/organ/external/chest/insectoid
	name = "thorax"
	encased = "carapace"

/obj/item/organ/internal/heart/insectoid
	name = "hemolymph pump"

/obj/item/organ/internal/stomach/insectoid
	name = "digestive sac"

/obj/item/organ/internal/lungs/insectoid
	name = "spiracle junction"
	icon_state = "trach"
	gender = NEUTER

/obj/item/organ/internal/liver/insectoid
	name = "primary filters"
	gender = PLURAL

/obj/item/organ/internal/kidneys/insectoid
	name = "secondary filters"

/obj/item/organ/internal/brain/insectoid
	name = "ganglial junction"
	icon_state = "brain-distributed"

/obj/item/organ/internal/eyes/insectoid
	name = "compound ocelli"
	icon_state = "eyes-compound"

/obj/item/organ/internal/egg_sac/insectoid
	name = "gyne egg-sac"
	action_button_name = "Produce Egg"
	var/egg_metabolic_cost = 100

/obj/item/organ/internal/egg_sac/insectoid/refresh_action_button()
	. = ..()
	if(.)
		action.button_icon_state = "egg-on"
		if(action.button) action.button.UpdateIcon()

/obj/item/organ/internal/egg_sac/insectoid/attack_self(var/mob/user)
	. = ..()
	var/mob/living/carbon/H = user
	if(.)
		if(H.incapacitated())
			to_chat(H, SPAN_WARNING("You can't produce eggs in your current state."))
			return		
		if(H.nutrition < egg_metabolic_cost)
			to_chat(H, SPAN_WARNING("You are too ravenously hungry to produce more eggs."))
			return
		if(do_after(H, 5 SECONDS, H, FALSE))
			H.adjust_nutrition(-1 * egg_metabolic_cost)
			H.visible_message(SPAN_NOTICE("\icon[H] [H] carelessly deposits an egg on \the [get_turf(src)]."))
			var/obj/structure/insectoid_egg/egg = new(get_turf(H)) // splorp
			egg.lineage = H.dna.lineage