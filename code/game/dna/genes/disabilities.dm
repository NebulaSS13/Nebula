/////////////////////
// DISABILITY GENES
//
// These activate either a mutation, disability, or sdisability.
//
// Gene is always activated.
/////////////////////

/decl/gene/disability
	name="DISABILITY"
	/// Mutation to give (or 0)
	var/mutation=0
	/// Disability to give (or 0)
	var/disability=0
	/// SDisability to give (or 0)
	var/sdisability=0
	/// Activation message
	var/activation_message=""
	/// Yay, you're no longer growing 3 arms
	var/deactivation_message=""

/decl/gene/disability/can_activate(var/mob/M,var/flags)
	return 1 // Always set!

/decl/gene/disability/activate(var/mob/M, var/connected, var/flags)
	if(mutation && !(mutation in M.mutations))
		M.mutations.Add(mutation)
	if(disability)
		M.disabilities|=disability
	if(sdisability)
		M.set_sdisability(sdisability)
	if(activation_message)
		to_chat(M, "<span class='warning'>[activation_message]</span>")
	else
		testing("[name] has no activation message.")

/decl/gene/disability/deactivate(var/mob/M, var/connected, var/flags)
	if(mutation && (mutation in M.mutations))
		M.mutations.Remove(mutation)
	if(disability)
		M.disabilities &= (~disability)
	if(sdisability)
		M.unset_sdisability(sdisability)
	if(deactivation_message)
		to_chat(M, "<span class='warning'>[deactivation_message]</span>")
	else
		testing("[name] has no deactivation message.")

// Note: Doesn't seem to do squat, at the moment.
/decl/gene/disability/hallucinate
	name="Hallucinate"
	activation_message="Your mind says 'Hello'."
	mutation=mHallucination

/decl/gene/disability/hallucinate/Initialize()
	. = ..()
	block=global.HALLUCINATIONBLOCK

/decl/gene/disability/epilepsy
	name="Epilepsy"
	activation_message="You get a headache."
	disability=EPILEPSY

/decl/gene/disability/epilepsy/Initialize()
	. = ..()
	block=global.HEADACHEBLOCK

/decl/gene/disability/cough
	name="Coughing"
	activation_message="You start coughing."
	disability=COUGHING

/decl/gene/disability/cough/Initialize()
	. = ..()
	block=global.COUGHBLOCK

/decl/gene/disability/clumsy
	name="Clumsiness"
	activation_message="You feel lightheaded."
	mutation=MUTATION_CLUMSY

/decl/gene/disability/clumsy/Initialize()
	. = ..()
	block=global.CLUMSYBLOCK

/decl/gene/disability/tourettes
	name="Tourettes"
	activation_message="You twitch."
	disability=TOURETTES

/decl/gene/disability/tourettes/Initialize()
	. = ..()
	block=global.TWITCHBLOCK

/decl/gene/disability/nervousness
	name="Nervousness"
	activation_message="You feel nervous."
	disability=NERVOUS

/decl/gene/disability/nervousness/Initialize()
	. = ..()
	block=global.NERVOUSBLOCK

/decl/gene/disability/blindness
	name="Blindness"
	activation_message="You can't seem to see anything."
	sdisability=BLINDED

/decl/gene/disability/blindness/Initialize()
	. = ..()
	block=global.BLINDBLOCK

/decl/gene/disability/deaf
	name="Deafness"
	activation_message="It's kinda quiet."
	sdisability=DEAFENED

/decl/gene/disability/deaf/Initialize()
	. = ..()
	block=global.DEAFBLOCK

/decl/gene/disability/deaf/activate(var/mob/M, var/connected, var/flags)
	..(M,connected,flags)
	M.set_status(STAT_DEAF, 1)

/decl/gene/disability/nearsighted
	name="Nearsightedness"
	activation_message="Your eyes feel weird..."
	disability=NEARSIGHTED

/decl/gene/disability/nearsighted/Initialize()
	. = ..()
	block=global.GLASSESBLOCK
