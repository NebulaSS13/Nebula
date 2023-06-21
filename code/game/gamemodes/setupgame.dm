/////////////////////////
// (mostly) DNA2 SETUP
/////////////////////////

// Randomize block, assign a reference name, and optionally define difficulty (by making activation zone smaller or bigger)
// The name is used on /vg/ for species with predefined genetic traits,
//  and for the DNA panel in the player panel.
/proc/getAssignedBlock(var/name,var/list/blocksLeft, var/activity_bounds=DNA_DEFAULT_BOUNDS)
	if(blocksLeft.len==0)
		warning("[name]: No more blocks left to assign!")
		return 0
	var/assigned = pick(blocksLeft)
	blocksLeft.Remove(assigned)
	assigned_blocks[assigned]=name
	dna_activity_bounds[assigned]=activity_bounds
	//testing("[name] assigned to block #[assigned].")
	return assigned

/proc/setupgenetics()

	if (prob(50))
		// Currently unused.  Will revisit. - N3X
		global.BLOCKADD = rand(-300,300)
	if (prob(75))
		global.DIFFMUT = rand(0,20)

	var/list/numsToAssign=new()
	for(var/i=1;i<DNA_SE_LENGTH;i++)
		numsToAssign += i

	//testing("Assigning DNA blocks:")

	// Standard muts, imported from older code above.
	global.BLINDBLOCK         = getAssignedBlock("BLINDED",    numsToAssign)
	global.DEAFBLOCK          = getAssignedBlock("DEAFENED",   numsToAssign)
	global.TELEBLOCK          = getAssignedBlock("TELE",       numsToAssign, DNA_HARD_BOUNDS)
	global.FIREBLOCK          = getAssignedBlock("FIRE",       numsToAssign, DNA_HARDER_BOUNDS)
	global.XRAYBLOCK          = getAssignedBlock("XRAY",       numsToAssign, DNA_HARDER_BOUNDS)
	global.CLUMSYBLOCK        = getAssignedBlock("CLUMSY",     numsToAssign)
	global.FAKEBLOCK          = getAssignedBlock("FAKE",       numsToAssign)
	global.REMOTETALKBLOCK    = getAssignedBlock("REMOTETALK", numsToAssign, DNA_HARDER_BOUNDS)

	//
	// Static Blocks
	/////////////////////////////////////////////.

	// Monkeyblock is always last.
	global.MONKEYBLOCK = DNA_SE_LENGTH

	// And the genes that actually do the work. (domutcheck improvements)
	var/list/blocks_assigned[DNA_SE_LENGTH]
	var/list/all_genes = decls_repository.get_decls_of_subtype(/decl/gene)
	for(var/gene_type in all_genes)
		var/decl/gene/gene = all_genes[gene_type]
		if(gene.block)
			if(gene.block in blocks_assigned)
				warning("DNA2: Gene [gene.name] trying to use already-assigned block [gene.block] (used by [english_list(blocks_assigned[gene.block])])")
			var/list/assignedToBlock[0]
			if(blocks_assigned[gene.block])
				assignedToBlock=blocks_assigned[gene.block]
			assignedToBlock.Add(gene.name)
			blocks_assigned[gene.block]=assignedToBlock
