#define BODYTYPE_GRAFADREKA           "drake body"
#define BODYTYPE_GRAFADREKA_HATCHLING "hatchling drake body"
#define BP_DRAKE_GIZZARD              "drake gizzard"

/decl/modpack/grafadreka
	name = "Grafadreka Species"

/mob/living/human/grafadreka/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/grafadreka::uid
	. = ..()

// TODO rewrite for Nebula drakes
/obj/item/book/drake_handling
	name = "Care And Handling Of The Sivian Snow Drake v0.1.12b"
	author = "Xenoscience Team"
	title = "Care And Handling Of The Sivian Snow Drake v0.1.12b"
	dat = {"
	<html>
			<head>
				<style>
					h1 {font-size: 18px; margin: 15px 0px 5px;}
					h2 {font-size: 15px; margin: 15px 0px 5px;}
					li {margin: 2px 0px 2px 15px;}
					ul {margin: 5px; padding: 0px;}
					ol {margin: 5px; padding: 0px 15px;}
					body {font-size: 13px; font-family: Verdana;}
				</style>
			</head>
			<body>
				<p><i>This seems to be a notebook full of handwritten notes, loosely organized by topic. There's a crude index scribbled on the inside of the cover, but it's not very useful.</i></p>
				<h2>General behavior</h2>
				<p>Grafadreka (drakes) are actually pretty timid and easily spooked despite their size and appearance. In the wild, they hunt in groups and will hit and run using their stunning spit, avoiding direct engagement unless given no other option. They seem to have an inherent social structure, with a dominant packmember taking the lead but the pack as a whole working as a team. May be useful for training?</p>
				<p>Instinctive aggression towards spiders & smaller Sivian wildlife - can be trained out of them with difficulty. Wild populations can live entirely off spider meat or carrion.</p>
				<p>Quite social animals - will seek out humans or other creatures in the absence of packmembers just for company. Very food motivated! Seem to enjoy working with personnel out in the field or hanging out in social areas like the bar.</p>
				<p>Egg-layers - nests of 1-3 eggs in caves north of Cynosure - influenced by different environment? <i>Terrible</i> parents, hatchlings always wandering off & getting eaten by spiders.</p>
				<h2>Training results</h2>
				<p>Signal training very successful - almost every drake responds positively to audible cues like summon whistles, vocal cues like 'up' and 'down' - strong indicators of language understanding.</p>
				<p>Can be encouraged to be careful with spitting - related to pack hunting instincts? - not always reliable.</p>
				<p>Good visual memory, can be trained to seek out specific kinds of object with vocal cues - implies use of tools could be trainable if they had better manual dexterity.</p>
				<p>Can understand buttons/levers, door panels, access cards and automatic doors.</p>
				<h2>Medical care</h2>
				<ul>
					<li>DO NOT TAKE OFFPLANET. Listlessness, faded glow, shedding of skin and lining of innards, death in ~3 days. LEAVE THEM ON SIF.</li>
					<li>Per above, Security and Customs are very mad about import/export of controlled species. Don't take them on the shuttle.</li>
					<li>Their saliva has a lot of bacteria and Sivian organic chemicals in it. Good for encouraging healing in Sivian wildlife, poisonous to humans (but does stop bleeding).</li>
					<li>For minor injuries, they'll probably sort themselves out.</li>
					<li>Standard human-compatible bandages, biogels and ointments seem to work fine for them.</li>
					<li>Good reactions to bicaridine - use to reduce scarring & promote recovery from serious wounds.</li>
					<li>Don't try to feed them a pill, they're worse than cats.</li>
				</ul>
			</body>
		</html>
	"}
