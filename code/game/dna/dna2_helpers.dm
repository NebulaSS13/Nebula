/////////////////////////////
// Helpers for DNA2
/////////////////////////////

// DNA Gene activation boundaries, see dna2.dm.
// Returns a list object with 4 numbers.
/proc/GetDNABounds(var/block)
	var/list/BOUNDS=dna_activity_bounds[block]
	if(!istype(BOUNDS))
		return DNA_DEFAULT_BOUNDS
	return BOUNDS

// Give Random Bad Mutation to M
/proc/randmutb(var/mob/living/M)
	if(!M) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.should_have_organ(BP_HEART))
			return
	M.dna.check_integrity()
	var/block = pick(global.GLASSESBLOCK,global.COUGHBLOCK,global.FAKEBLOCK,global.NERVOUSBLOCK,global.CLUMSYBLOCK,global.TWITCHBLOCK,global.HEADACHEBLOCK,global.BLINDBLOCK,global.DEAFBLOCK,global.HALLUCINATIONBLOCK)
	M.dna.SetSEState(block, 1)

// Give Random Good Mutation to M
/proc/randmutg(var/mob/living/M)
	if(!M) return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.should_have_organ(BP_HEART))
			return
	M.dna.check_integrity()
	var/block = pick(global.XRAYBLOCK,global.FIREBLOCK,global.TELEBLOCK,global.NOBREATHBLOCK,global.REMOTEVIEWBLOCK,global.REGENERATEBLOCK,global.INCREASERUNBLOCK,global.REMOTETALKBLOCK,global.MORPHBLOCK,global.BLENDBLOCK,global.NOPRINTSBLOCK,global.SHOCKIMMUNITYBLOCK,global.SMALLSIZEBLOCK)
	M.dna.SetSEState(block, 1)

// Random Appearance Mutation
/proc/randmuti(var/mob/living/M)
	if(!M) return
	M.dna.check_integrity()
	M.dna.SetUIValue(rand(1,DNA_UI_LENGTH),rand(1,4095))

// Scramble UI or SE.
/proc/scramble(var/UI, var/mob/M, var/prob)
	if(!M)	return
	M.dna.check_integrity()
	if(UI)
		for(var/i = 1, i <= DNA_UI_LENGTH-1, i++)
			if(prob(prob))
				M.dna.SetUIValue(i,rand(1,4095),1)
		M.dna.UpdateUI()
		M.UpdateAppearance()

	else
		for(var/i = 1, i <= DNA_SE_LENGTH-1, i++)
			if(prob(prob))
				M.dna.SetSEValue(i,rand(1,4095),1)
		M.dna.UpdateSE()
		domutcheck(M, null)
	return

// /proc/updateappearance has changed behavior, so it's been removed
// Use mob.UpdateAppearance() instead.

// Simpler. Don't specify UI in order for the mob to use its own.
/mob/proc/UpdateAppearance(var/list/UI=null)
	return FALSE

/mob/living/carbon/human/UpdateAppearance(var/list/UI=null)

	if(UI!=null)
		src.dna.UI=UI
		src.dna.UpdateUI()

	dna.check_integrity()

	fingerprint          = dna.fingerprint
	unique_enzymes       = dna.unique_enzymes
	set_skin_colour(       rgb(dna.GetUIValueRange(DNA_UI_SKIN_R,255),  dna.GetUIValueRange(DNA_UI_SKIN_G,255),  dna.GetUIValueRange(DNA_UI_SKIN_B,255)))
	set_eye_colour(        rgb(dna.GetUIValueRange(DNA_UI_EYES_R,255),  dna.GetUIValueRange(DNA_UI_EYES_G,255),  dna.GetUIValueRange(DNA_UI_EYES_B,255)))
	skin_tone            = 35 - dna.GetUIValueRange(DNA_UI_SKIN_TONE, 220) // Value can be negative.


	// TODO: update DNA gender to not be a bool - use bodytype and pronouns
	//Body markings
	for(var/tag in dna.heritable_sprite_accessories)
		var/obj/item/organ/external/E = GET_EXTERNAL_ORGAN(src, tag)
		if(E)
			var/list/marklist = dna.heritable_sprite_accessories[tag]
			if(length(marklist))
				for(var/accessory in marklist)
					E.set_sprite_accessory(accessory, null, marklist[accessory], skip_update = TRUE)
			else
				E.clear_sprite_accessories(skip_update = TRUE)

	//Base skin and blend
	for(var/obj/item/organ/organ in get_organs())
		organ.set_dna(dna)

	force_update_limbs()
	update_hair(update_icons = FALSE)
	update_eyes()
	return TRUE

// Used below, simple injection modifier.
/proc/probinj(var/pr, var/inj)
	return prob(pr+inj*pr)
