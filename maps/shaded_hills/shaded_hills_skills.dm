/decl/hierarchy/skill/Initialize()
	. = ..()
	// Rename the default skill levels.
	var/static/list/replacement_levels = list(
		"Unskilled",
		"Beginner",
		"Apprentice",
		"Journeyman",
		"Master"
	)
	var/i = 0
	for(var/level in levels)
		i++
		var/old_string = levels[level]
		levels -= level
		levels[replacement_levels[i]] = old_string

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

/obj/item/food/butchery/offal
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

//overrides for base skills with more fitting names/level texts
/decl/hierarchy/skill/security
	name = "Combat"

/decl/hierarchy/skill/service
	name = "Domestic"

/decl/hierarchy/skill/organizational/finance
	name = "Finance"
	uid =  "skill_finance"
	desc = "Your ability to manage money and investments."
	levels = list(
		"Unskilled"   = "Your understanding of money starts and ends with personal finance. While you are able to perform basic transactions, you get lost in the details, and can find yourself ripped off on occasion.<br>- You get some starting money, increasing with level.",
		"Basic"       = "You have some limited understanding of financial transactions, and will generally be able to keep accurate records. You have little experience with investment, and managing large sums of money will likely go poorly for you.<br>- You can use the verb \"Appraise\" to see the value of different objects.",
		"Trained"     = "You are good at managing accounts, keeping records, and arranging transactions. You have some familiarity with loans, exchange rates and taxes, but may be stumped when facing more complicated financial situations.",
		"Experienced" = "With your experience, you are familiar with any financial entities you may run across, and are a shrewd judge of value. More often than not, investments you make will pan out well.",
		"Master"      = "You have an excellent knowledge of finance, will often make brilliant investments, and have an instinctive feel for kingdom-wide economics. Financial instruments are weapons in your hands. You likely have professional experience in the finance industry."
	)

/decl/hierarchy/skill/organizational/finance/update_special_effects(mob/mob, level)
	return //we don't want legalese here

/decl/hierarchy/skill/general/hauling
	name = "Athletics"
	uid =  "skill_hauling"
	desc = "Your ability to perform tasks requiring great strength, dexterity, or endurance."
	levels = list(
		"Unskilled"   = "You are not used to manual labor, tire easily, and are likely not in great shape. Extended heavy labor may be dangerous for you.<br>- You can pull objects but your stamina depends on your skill rank. Your strength increases with level.<br>- You can throw objects. Their speed, thrown distance, and force increases with level.<br>- You can sprint, the stamina consumption rate is lowered with each level.<br>- You can leap by holding Ctrl and clicking on a distant target with grab intent, leap range is increased and chances of falling over are decreased with each level.",
		"Basic"       = "You have some familiarity with manual labor, and are in reasonable physical shape. Tasks requiring great dexterity or strength may still elude you.<br>- You can throw \"huge\" items or normal-sized mobs without getting weakened.",
		"Trained"     = "You have sufficient strength and dexterity for even very strenuous tasks, and can work for a long time without tiring.",
		"Experienced" = "You have experience with heavy work in trying physical conditions, and are in excellent shape. You often work out.",
		"Master"      = "In addition to your excellent strength and endurance, you have a lot of experience with the specific physical demands of your job."
	)

/decl/hierarchy/skill/service/botany
	name = "Horticulture"
	uid =  "skill_botany"
	desc = "Describes how good you are at growing and maintaining plants."
	levels = list(
		"Unskilled"   = "You know next to nothing about plants. While you can attempt to plant, weed, or harvest, you are just as likely to kill the plant instead.",
		"Basic"       = "You've done some gardening. You can water, weed, fertilize, plant, and harvest, and you can recognize and deal with pests.<br>- You can safely plant and weed normal plants.<br>- You can tell weeds and pests apart from each other.",
		"Trained"     = "You are proficient at botany, and can grow plants for food, medicine or textile use. Your plants will generally survive and prosper. <br>- You can safely plant and weed exotic plants.",
		"Experienced" = "You are an experienced horticulturalist with an encyclopedic knowledge of plants and their properties.",
		"Master"      = "You're a specialized gardener. You can care for even the most exotic, fragile, or dangerous plants."
	)

/decl/hierarchy/skill/service/cooking
	name = "Cooking"
	uid =  "skill_cooking"
	desc = "Describes your skill at preparing meals and other consumable goods. This includes mixing alcoholic beverages."
	levels = list(
		"Unskilled"   = "You barely know anything about cooking, and rely on others when you can. The stove is a device of black magic to you, and you avoid it when possible.",
		"Basic"       = "You can make simple meals and do the cooking for your family. Things like roasted meat, boiled vegetables, or simple mixed drinks are your usual fare.",
		"Trained"     = "You can make most meals while following instructions, and they generally turn out well. You have some experience with hosting, catering, and/or bartending.",
		"Experienced" = "You can cook professionally, keeping an entire inn fed easily. Your food is tasty and you don't have a problem with tricky or complicated dishes. You can be depended on to make just about any commonly-served drink.",
		"Master"      = "You are an expect chef capable of preparing a meal fit for a king! Not only are you good at cooking and mixing drinks, but you can manage a kitchen staff and cater for special events. You can safely prepare exotic foods and drinks that would be poisonous if prepared incorrectly."
	)

/decl/hierarchy/skill/security/combat
	name = "Melee Combat"
	uid =  "skill_combat"
	desc = "This skill describes your training with melee weapons such as swords and spears. It also dictates how good you are at hand-to-hand combat."
	levels = list(
		"Unskilled"   = "You have little to no experience with melee combat, you can swing or stab with a weapon, but you don't know how to do so effectively.<br>- You can disarm, grab, and hit. Their success chance depends on the fighters' skill difference.<br>- The chance of falling over when tackled is reduced with level.",
		"Basic"       = "You have some basic training on how to use a weapon in combat, but are still a beginner. You can handle yourself if you really have to, and know the basics of how to swing a sword.",
		"Trained"     = "You have had more melee training, and can easily defeat unskilled opponents. Melee combat may not be your specialty, and you don't engage in it more than needed, but you know how to handle yourself in a fight.<br>- You can parry with weapons. This increases with level.<br>- You can do grab maneuvers (pinning, dislocating).<br>- You can grab targets when leaping at them and not fall over, if your species is able to do so.",
		"Experienced" = "You're good at melee combat. You've trained explicitly with one or more types of weapon, you can use them competently and you can think strategically and quickly in a melee. You're in good shape and you spend time training.",
		"Master"      = "You specialize in melee combat. You are in good shape  and skilled with multiple types of weapon. You spend a lot of time practicing. You can take on just about anyone, use just about any weapon, and usually come out on top. You may be a professional athlete or knight."
	)

/decl/hierarchy/skill/security/weapons
	name = "Marksmanship"
	uid =  "skill_weapons"
	desc = "This skill describes your expertise with ranged weapons such as bows and slings."
	levels = list(
		"Unskilled"   = "You have little to no experience with a ranged weapon, and are likely to miss your target, injure yourself or missfire. <br>- You might fire your weapon randomly.",
		"Basic"       = "You know how to handle weapons safely, and you're comfortable using simple weapons. Your aim is decent and you can usually be trusted not to do anything stupid with a weapon you are familiar with, but your training isn't automatic yet and your performance will degrade in high-stress situations.<br>- You can use ranged weapons. Their accuracy depends on your skill level.",
		"Trained"     = "You have had extensive weapons training, or have used weapons in combat. Your aim is better now. You are familiar with most types of weapons and can use them in a pinch. You have an understanding of tactics, and can be trusted to stay calm under fire. You may have military or guardsman experience and you probably carry a weapon on the job.",
		"Experienced" = "You've used ranged weapons in high-stress situations, and your skills have become automatic. Your aim is good.",
		"Master"      = "You are a master marksman with great aim, you can hit a moving target, even from afar."
	)

/decl/hierarchy/skill/medical/medical
	name = "Medicine"
	uid =  "skill_medical"
	desc = "Covers an understanding of the body and medicine. At a low level, this skill gives a basic understanding of applying common types of medicine. At a high level, this skill grants exact knowledge of all the medicine available in these lands."
	levels = list(
		"Unskilled"   = "You know first aid, such as how to apply a bandage or salve to an injury. You can tell when someone is badly hurt and needs a doctor; you can see whether someone has a badly broken bone, is having trouble breathing, or is unconscious. You may have trouble telling the difference between unconscious and dead at distance.<br>- You can use basic first aid supplies, such as bandages and salves.",
		"Basic"       = "You are an apprentice healer. You can stop bleeding, perform resuscitation, apply a splint, take someone's pulse, apply trauma and burn treatments. You probably know that antitoxins help poisoning. You've been briefed on the symptoms of common emergencies like a punctured lung, appendicitis, alcohol poisoning, or broken bones, and though you can't treat them, you know that they need a doctor's attention. You can recognize most emergencies as emergencies and safely stabilize and transport a patient.",
		"Trained"     = "You are a healer, having recently finished your apprenticeship. You know how to treat most illnesses and injuries, though exotic illnesses and unusual injuries may still stump you. You have probably begun to specialize in some sub-field of medicine. In emergencies, you can think fast enough to keep your patients alive, and even when you can't treat a patient, you know how to find someone who can. <br>- You can apply splints without failing. You can perform simple surgery steps if you have Journeyman level Anatomy skill",
		"Experienced" = "You are a skilled doctor. You know how to use all of the medical supplies available to treat a patient. Your deep knowledge of the body and medications will let you diagnose and come up with a course of treatment for most ailments. You can perform all surgery steps if you have Journeyman level Anatomy skill",
		"Master"      = "You are an experienced doctor. You've seen almost everything there is to see when it comes to injuries and illness and even when it comes to something you haven't seen, you can apply your wide knowledge base to put together a treatment. In a pinch, you can do just about any medicine-related task, but your specialty, whatever it may be, is where you really shine."
	)

/decl/hierarchy/skill/medical/anatomy
	name = "Anatomy"
	uid =  "skill_anatomy"
	desc = "Gives you a detailed insight of the human body. A high skill in this is required to perform surgery."
	levels = list(
		"Unskilled"   = "You know what organs, bones, and such are, and you know roughly where they are. You know that someone who's badly hurt or sick may need surgery.",
		"Basic"       = "You've received tutoring on anatomy and you've spent at least some time poking around inside actual people. You know where everything is, more or less. You could assist in surgery, if you have the required medical skills. If you really had to, you could probably perform basic surgery such as an appendectomy, but you're not yet a qualified surgeon and you really shouldn't--not unless it's an emergency.",
		"Trained"     = "You have some training in anatomy. Diagnosing broken bones, damaged ligaments, arrow wounds, and other trauma is straightforward for you. You can splint limbs with a good chance of success and you know how to perform resuscitation. Surgery is still outside your training.<br>- You can do surgery (requires Apprentice level Medicine skill too) but you are very likely to fail at every step. Its speed increases with level.",
		"Experienced" = "You're a skilled doctor. You can put together broken bones, fix a damaged lung, patch up a liver, or remove an appendix without problems. But tricky surgeries, with an unstable patient or delicate manipulation of vital organs like the heart and brain, are at the edge of your ability, and you prefer to leave them to specialized surgeons. You can recognize when someone's anatomy is noticeably unusual.<br>- You can do all surgery steps safely, if you have Journeyman level Medicine skill too.",
		"Master"      = "You are an experienced surgeon. You can handle anything that gets rolled, pushed, or dragged to you, and you can keep a patient alive and stable even if there's no one to assist you. You can handle severe trauma cases or multiple organ failure, repair brain damage, and perform heart surgery. By now, you've probably specialized in one field, where you may have made new contributions to surgical technique. You can detect even small variations in the anatomy of a patient--very little will slip by your notice.<br>- The penalty from operating on improper operating surfaces is reduced."
	)

/decl/hierarchy/skill/medical/chemistry
	name = "Chemistry"
	uid =  "skill_chemistry"
	desc = "Experience with chemical ingredients, and an understanding of what the effect will be. This doesn't cover an understanding of the effect of reagents on the human body, as such the medical skill is also required for medical chemists."
	levels = list(
		"Unskilled"   = "You know that chemists work with various ingredients; you know that they can make medicine, poison or other useful concoctions.",
		"Basic"       = "You can make basic medication--things like anti-toxin or burn salves. You have some training in safety and you won't blow up the lab... probably.",
		"Trained"     = "You can accurately measure out ingredients, grind powders, and mix reagents. You may still lose some product on occasion, but are unlikely to endanger yourself or those around you.",
		"Experienced" = "You work as an pharmacist, or else you are a doctor with training in chemistry. If you are a pharmacist, you can make most medications. At this stage, you're working mostly by-the-book. <br>- You can examine held containers for some reagents.",
		"Master"      = "You specialized in chemistry or pharmaceuticals; you are either a medical researcher or professional chemist. You can create custom mixes and make even the trickiest of medications easily. You understand how your pharmaceuticals interact with the bodies of your patients. You are probably the originator of at least one new chemical innovation.<br>- You can examine held containers for all reagents."
	)
