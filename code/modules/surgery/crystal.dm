/decl/surgery_step/generic/cut_open/crystal
	name = "Drill keyhole incision"
	description = "This procedure drills a keyhold incision into crystalline limbs to allow for delicate internal work."
	allowed_tools = list(TOOL_DRILL = 100)
	fail_string = "cracking"
	access_string = "a neat hole"
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/generic/cauterize/crystal
	name = "Close keyhole incision"
	description = "This procedure seals a keyhole incision with resin."
	allowed_tools = list(
		/obj/item/stack/medical/resin = 100
	)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH
	cauterize_term = "seal"
	post_cauterize_term = "seals"

/decl/surgery_step/open_encased/crystal
	name = "Saw through crystal"
	description = "This procedure cuts through hard crystal to allow for access to the internals."
	allowed_tools = list(TOOL_SAW = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_RETRACTED | SURGERY_NO_FLESH

/decl/surgery_step/bone/glue/crystal
	name = "Begin crystalline bone repair"
	description = "This procedure uses resin to begin patching damage to crystalline bones."
	allowed_tools = list(/obj/item/stack/medical/resin = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/bone/finish/crystal
	name = "Finish crystalline bone repair"
	description = "This procedure uses resin to finalize the repair of crystalline bones that have been set in place."
	allowed_tools = list(/obj/item/stack/medical/resin = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/internal/detach_organ/crystal
	name = "Detach crystalline internal organ"
	description = "This procedure severs a crystalline internal organ, allowing it to be removed."
	allowed_tools = list(TOOL_DRILL = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT | SURGERY_NO_FLESH

/decl/surgery_step/internal/attach_organ/crystal
	name = "Attach crystalline internal organ"
	description = "This procedure reattaches a previously detached crystalline internal organ."
	allowed_tools = list(/obj/item/stack/medical/resin = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NEEDS_ENCASEMENT | SURGERY_NO_FLESH

/decl/surgery_step/internal/fix_organ/crystal
	name = "Repair crystalline internal organ"
	description = "This procedure repairs damage to crystalline internal organs."
	allowed_tools = list(/obj/item/stack/medical/resin = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH

/decl/surgery_step/fix_vein/crystal
	name = "Repair arteries in crystalline beings"
	description = "This procedure is used to patch severed arteries in crystalline bodies."
	allowed_tools = list(/obj/item/stack/medical/resin = 100)
	surgery_candidate_flags = SURGERY_NO_ROBOTIC | SURGERY_NO_FLESH
