/decl/hierarchy/skill/crafting
	name = "Crafting"
	difficulty = SKILL_EASY
	default_max = SKILL_MAX
	abstract_type = /decl/hierarchy/skill/crafting

/decl/hierarchy/skill/crafting/carpentry
	name = "Carpentry"
	uid =  "skill_crafting_carpentry"
	desc = "Your ability to construct and repair objects and structures made out of wood, and use woodworking tools."
	levels = list(
		"Unskilled"   = "You can use an axe to split wood and cut it into planks, but your splits and cuts are often wasteful and uneven. You can nail pieces of wood together.",
		"Basic"       = "You've whittled a few things out of wood before, and maybe even done a small construction project or two. You're more effective at using tools like hatchets, knives, and hammers for woodworking.",
		"Trained"     = "You've received some degree of formal instruction or apprenticeship in woodworking, or have a lot of hands-on practice with woodcraft. Your cuts are cleaner, your whittling is quicker, and your joinery is sturdier.",
		"Experienced" = "You have a plethora of professional carpentry experience, either as a trade or from running a farmstead or business. You could likely train an apprentice of your own in carpentry.",
		"Master"      = "Few can match your experience with woodcraft. You fit tight joinery, carve intricate items, and prepare raw material with precision and speed. Trees dream of being worked by your hands."
	)

/decl/hierarchy/skill/crafting/stonemasonry
	name = "Stonemasonry"
	uid =  "skill_crafting_mason"
	desc = "Your ability to chisel, cut, carve, construct with, and knap stone and stone-like materials."
	levels = list(
		"Unskilled"   = "You know that a hammer and chisel are used to split and shape stone, and that bricks are joined using mortar or cement, but you're not entirely sure how to do either of those things. If you tried to chisel a sculpture from a block of stone, you'd risk shattering it entirely, or just having the chisel glance off. You know some primitive tools are made by hitting rocks together to break pieces off, but if you tried you'd probably just make noise and little else.",
		"Basic"       = "You've done some stoneknapping before and have begun developing an understanding of how stone cracks and splits when struck. You can replicate rough forms out of stone, and while your bricks may not be perfect by any means, they're flat enough to be used in a wall.",
		"Trained"     = "You can do basic sculpting and carving with a hammer and chisel. You work well with bricks, loose stones, concrete, and rock slabs, whether you're knapping a tool out of flint or carving a form into a block of marble. You may not be able to work professionally at this stage, but you could cut it as an apprentice mason.",
		"Experienced" = "You work with stone in your daily life, either on your homestead or as part of your profession. Your work improves in quality and speed, with fewer mistakes that result in scrapped workpieces, even if with some blows you still take off a little more than you planned.",
		"Master"      = "Your work is delicate yet firm, always applying the exact amount of force for the desired effect, no more and no less. Mistakes in your work are unheard of, at least while you work without interference. You could be the head of a masons' guild, or at least train someone to work as a mason or stonecarver."
	)

/decl/hierarchy/skill/crafting/metalwork
	name = "Metalwork"
	uid =  "skill_crafting_metalwork"
	desc = "Your ability to shape, forge, and cast metal into various decorative or useful objects."
	levels = list(
		"Unskilled"   = "You know that a smith uses an anvil and hammer, that metal has to be hot to be worked, and that metal becomes a liquid when heated enough. You've likely never done anything like that yourself, though, and if you have it wasn't very good.",
		"Basic"       = "You've got some experience working with metals. You know how to keep a workpiece steady enough on the anvil to strike it with a hammer, but you're not sure how to do anything more complex with an anvil. You can pour hot metal into a warmed mould without much splattering.",
		"Trained"     = "You know the basics of smithing as a trade, like drawing, punching, and bending, and you can crack a cast item out of a mould without breaking it or the mould as often. You know what fuels burn hot enough to melt certain metals, and what metals go into certain alloys.",
		"Experienced" = "You are either a professional smith or farrier, or someone who works extensively with metal as part of another trade. You have the knowledge necessary to supervise and instruct an untrained apprentice to avoid basic mistakes. You may know about more complex or niche alloys, or have experience working expensive or rare metals.",
		"Master"      = "To you, metal may as well be putty in your hands and under your hammer. You're able to get many casts from one mould, make and fill moulds of detailed objects, and forge intricate projects all on your own. With enough time, you could train someone enough to become a professional smith of their own."
	)

/decl/hierarchy/skill/crafting/artifice
	name = "Artifice"
	uid =  "skill_crafting_artifice"
	desc = "Your ability to create, install, and comprehend complex devices and mechanisms, as well as your ability to create finely-detailed objects."
	levels = list(
		"Unskilled"   = "You know that gears turn together when intermeshed and that axles are used to connect spinning things, but you've never done more work on a machine than hitting it if it's broken. You struggle with the precision needed to work on finely-detailed objects.",
		"Basic"       = "You know some basic mechanical principles, like the construction of a basic pulley, or how to put a wheel on an axle. You could fix a broken or stuck well winch, but you'd struggle to deal with a malfunctioning windmill or granary. You have a steadier hand than most, able to place small gems on jewelry and connect small mechanisms.",
		"Trained"     = "You know how to operate and repair machinery, that axles and gears need to be oiled to work smoothly, and how to figure out what's broken when something goes wrong. You might routinely deal with machines enough to have training with them, or just lots of hands-on experience. You can steady your hands greatly when working with delicate objects.",
		"Experienced" = "You work with machinery and delicate crafts either as part of your trade or in your daily life. You could construct a delicate music box or wind-up toy, and can easily connect mechanical components together.",
		"Master"      = "You are a machine maestro, conducting a symphony of steadily-whirring mechanical parts. Every one of your creations has the utmost care put into its design and manufacture. Your hand never slips nor wavers when you work."
	)

/decl/hierarchy/skill/crafting/textiles
	name = "Textiles"
	uid =  "skill_crafting_textiles"
	desc = "Your ability to create and mend objects made of cloth, thread, leather, and other fabrics."
	levels = list(
		"Unskilled"   = "You can use a sewing needle, but it takes substantial care to not prick yourself with it. With plenty of time, you can weave grass into a basic basket or a mat. Your patch repair jobs are rough and ramshackle and anything you make from scratch is often fragile and misshapen.",
		"Basic"       = "You've got some experience with a loom or spinning wheel, and you can sew without poking yourself. More advanced stitching, knitting, or weaving techniques are still beyond you, but your handiwork is rapidly improving.",
		"Trained"     = "You have plenty of experience with weaving, sewing, or spinning, and may even be an apprentice in the trade. You've started to grasp some more advanced techniques and greatly improved your proficiency at the basics.",
		"Experienced" = "You've reached a near-mastery of basic sewing, weaving, and leatherworking skills, but still have room to improve. You know enough to train someone in the basics of working with textiles, but mastery is not yet within your reach.",
		"Master"      = "You've never seen a piece of clothing you couldn't mend. You've mastered not just the basics but more advanced techniques as well, making your skill with texiles nearly unmatched. Your knowledge would be suitable to train an apprentice enough to work independently."
	)

/decl/hierarchy/skill/crafting/sculpting
	name = "Sculpting"
	uid =  "skill_crafting_sculpting"
	desc = "Your ability to craft objects out of soft materials like wax or clay."
	levels = list(
		"Unskilled"   = "You can mould soft materials into rough shapes, but your work is sloppy and anything more complicated than a pinch-pot is beyond your ken.",
		"Basic"       = "Your understanding of sculpting has improved to allow you to create more even and symmetrical designs. You likely have experience using a pottery wheel, turntable, or similar device.",
		"Trained"     = "Your creations have become at once more uniform and more aesthetically pleasing, with a consistent level of quality to them.",
		"Experienced" = "You have extensive experience with sculpting, able to work with a wide array of materials to form just about anything you set your mind to, as long as you put in the effort.",
		"Master"      = "You have reached the pinnacle of your craft, able to sculpt clay, wax, and similar materials to your every whim, so much so that a mound of clay may as well be an extension of your will itself."
	)

// SCULPTING OVERRIDES
/decl/material/solid/clay
	crafting_skill = SKILL_SCULPTING

/decl/material/solid/soil
	crafting_skill = SKILL_SCULPTING

/decl/material/solid/organic/wax
	crafting_skill = SKILL_SCULPTING

// TEXTILES OVERRIDES
/obj/structure/textiles
	work_skill = SKILL_TEXTILES

/obj/item/stack/material/skin
	work_skill = SKILL_TEXTILES

/obj/item/chems/food/butchery/offal
	work_skill = SKILL_TEXTILES

/decl/material/solid/organic/cloth
	crafting_skill = SKILL_TEXTILES

/decl/material/solid/organic/skin
	crafting_skill = SKILL_TEXTILES

/decl/material/solid/organic/leather
	crafting_skill = SKILL_TEXTILES

/decl/material/solid/organic/plantmatter
	crafting_skill = SKILL_TEXTILES

// STONEMASONRY OVERRIDES
/decl/material/solid/stone
	crafting_skill = SKILL_STONEMASONRY

// METALWORK OVERRIDES
/decl/material/solid/metal
	crafting_skill = SKILL_METALWORK

/obj/item/chems/mould
	work_skill = SKILL_METALWORK

// CARPENTRY OVERRIDES
/decl/material/solid/organic/wood
	crafting_skill = SKILL_CARPENTRY

/decl/material/solid/organic/plantmatter/pith // not quite wood but it's basically still wood carving
	crafting_skill = SKILL_CARPENTRY

// MISC OVERRIDES
/decl/stack_recipe
	recipe_skill = null // set based on material

// Removal of space skills
/datum/map/shaded_hills/get_available_skill_types()
	. = ..()
	. -= list(
		SKILL_EVA,
		SKILL_MECH,
		SKILL_PILOT,
		SKILL_COMPUTER,
		SKILL_FORENSICS,
		SKILL_ELECTRICAL,
		SKILL_ATMOS,
		SKILL_ENGINES,
		SKILL_DEVICES,
		SKILL_CONSTRUCTION, // Anything using this should be replaced with another skill.
	)