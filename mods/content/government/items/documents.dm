/obj/item/documents/scg/verified
	name = "secret government documents"
	desc = "\"Top Secret\" documents detailing SCG IFF codes, granting access into restricted sectors. \
	The majority of them are coordinates, codes for fellow ships, and clearance lists."
	description_antag = "These codes seem very odd for an exploration vessel: \
	a lot of them are SCG blacksites, covered up. You've never even heard of most of these."
	icon_state = "docs_verified"

/obj/item/documents/scg/brains
	name = "secret medical documents"
	desc = "Heavily classified medical documentation of brain scans and exploratory surgery \
	conducted across the entire length of the project. \
	It seems like they have been documenting how deep-space living has altered the structure of the brain."
	description_antag = "These studies were conducted, without consent, \
	while the patients were under anaesthesia for some other routine medical concern. \
	They detail some very unusual deformities within the deepest parts of the brain, \
	correlating them with the people and places visited 'for later assessment'. \
	The findings, and any 'viable specimens', are to be delivered to a black site on S/2004 N 1."
	icon_state = "docs_verified"

/obj/item/documents/scg/red
	name = "red secret documents"
	desc = "\"Top Secret\" protocols on what to do if the ship passes into SCG sectors. \
	The writing mostly goes over the diplomatic process, while constantly shaming \
	the Solars for their idiocy and ineffective bureaucracy."
	description_antag = "You notice that these protocols contain small,\
	 almost intentional snubbing efforts. Whoever wrote these may have been rooting for a war to start..."
	icon_state = "docs_red"

/obj/item/documents/scg/blue
	name = "blue secret documents"
	desc = "\"Top Secret\" documents detailing the a distant skrellian kingdom, \
	and their insistent requests upon specific priority sectors to investigate."
	description_antag = "The skrell seem to be guiding the ship, subtly, to a specific unmapped sector of the galaxy. \
	It's almost like they're too afraid to investigate it personally."
	icon_state = "docs_blue"

/obj/random/documents/scg/spawn_choices()
	return list (
		/obj/item/documents/scg/verified = 7,
		/obj/item/documents/scg/red      = 7,
		/obj/item/documents/scg/blue     = 7,
		/obj/item/documents/scg/brains   = 7
	)

/obj/item/clothing/gloves/ring/seal/secretary
	name = "\improper Secretary-General's official seal"
	desc = "The official seal of the Secretary-General of the Sol Central Government, featured prominently on a silver ring."
	use_material_name = FALSE