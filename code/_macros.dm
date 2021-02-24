#define any2ref(x) "\ref[x]"

#if DM_VERSION < 513

#define islist(A) istype(A, /list)

#define ismovable(A) istype(A, /atom/movable)

/proc/copytext_char(T, Start = 1, End = 0)
	return copytext(T, Start, End)

/proc/length_char(E)
	return length(E)

/proc/findtext_char(Haystack, Needle, Start = 1, End = 0)
	return findtext(Haystack, Needle, Start, End)

/proc/replacetextEx_char(Haystack, Needle, Replacement, Start = 1, End = 0)
	return replacetextEx(Haystack, Needle, Replacement, Start, End)

#endif

#define PUBLIC_GAME_MODE SSticker.master_mode

#define Clamp(value, low, high) (value <= low ? low : (value >= high ? high : value))
#define CLAMP01(x) 		(Clamp(x, 0, 1))

#define get_turf(A) get_step(A,0)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isalien(A) istype(A, /mob/living/carbon/alien)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isatom(A) isloc(A)

#define isbrain(A) istype(A, /mob/living/carbon/brain)

#define iscarbon(A) istype(A, /mob/living/carbon)

#define iscolorablegloves(A) (istype(A, /obj/item/clothing/gloves/color)||istype(A, /obj/item/clothing/gloves/insulated)||istype(A, /obj/item/clothing/gloves/thick))

#define isclient(A) istype(A, /client)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define is_drone(A) istype(A, /mob/living/silicon/robot/drone)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/carbon/human)

#define isitem(A) istype(A, /obj/item)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_animal/mouse)

#define isnewplayer(A) istype(A, /mob/new_player)

#define isobj(A) istype(A, /obj)

#define iseffect(A) istype(A, /obj/effect)

#define isghost(A) istype(A, /mob/observer/ghost)

#define isobserver(A) istype(A, /mob/observer)

#define isorgan(A) istype(A, /obj/item/organ/external)

#define isstack(A) istype(A, /obj/item/stack)

#define isspacearea(A) istype(A, /area/space)

#define isspaceturf(A) istype(A, /turf/space)

#define ispAI(A) istype(A, /mob/living/silicon/pai)

#define isrobot(A) istype(A, /mob/living/silicon/robot)

#define issilicon(A) istype(A, /mob/living/silicon)

#define isunderwear(A) istype(A, /obj/item/underwear)

#define isvirtualmob(A) istype(A, /mob/observer/virtual)

#define isweakref(A) istype(A, /weakref)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

#define isplunger(A) istype(A, /obj/item/plunger)

/proc/isspecies(A, B)
	if(!iscarbon(A))
		return FALSE
	var/mob/living/carbon/C = A
	return C.species?.name == B

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

/proc/place_meta_charset(content)
	if(istext(content))
		content = "<meta charset=\"utf-8\">" + content
	return content

#define to_chat(target, message)                            target << (message)
#define to_world(message)                                   world << (message)
#define to_world_log(message)                               world.log << (message)
#define sound_to(target, sound)                             target << (sound)
#define to_file(file_entry, source_var)                     file_entry << (source_var)
#define from_file(file_entry, target_var)                   file_entry >> (target_var)
#define show_browser(target, browser_content, browser_name) target << browse(place_meta_charset(browser_content), browser_name)
#define close_browser(target, browser_name)                 target << browse(null, browser_name)
#define show_image(target, image)                           target << (image)
#define send_rsc(target, rsc_content, rsc_name)             target << browse_rsc(rsc_content, rsc_name)
#define open_link(target, url)                              target << link(url)

/proc/html_icon(var/thing) // Proc instead of macro to avoid precompiler problems.
	. = "\icon[thing]"

#define MAP_IMAGE_PATH "nano/images/[GLOB.using_map.path]/"

#define map_image_file_name(z_level) "[GLOB.using_map.path]-[z_level].png"

#define RANDOM_BLOOD_TYPE pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) (CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define CanPhysicallyInteractWith(user, target) (target.CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null; }

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

//Currently used in SDQL2 stuff
#define send_output(target, msg, control) target << output(msg, control)
#define send_link(target, url) target << link(url)

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define FLAGS_EQUALS(flag, flags) ((flag & (flags)) == (flags))

#define JOINTEXT(X) jointext(X, null)

#define SPAN_ITALIC(X) "<span class='italic'>[X]</span>"

#define SPAN_BOLD(X) "<span class='bold'>[X]</span>"

#define SPAN_NOTICE(X) "<span class='notice'>[X]</span>"

#define SPAN_WARNING(X) "<span class='warning'>[X]</span>"

#define SPAN_STYLE(style, X) "<span style=\"[style]\">[X]</span>"

#define SPAN_DANGER(X) "<span class='danger'>[X]</span>"

#define SPAN_OCCULT(X) "<span class='cult'>[X]</span>"

#define SPAN_MFAUNA(X) "<span class='mfauna'>[X]</span>"

#define SPAN_SUBTLE(X) "<span class='subtle'>[X]</span>"

#define SPAN_INFO(X) "<span class='info'>[X]</span>"

#define STYLE_SMALLFONTS_OUTLINE(X, S, C1, C2) "<span style=\"font-family: 'Small Fonts'; color: [C1]; -dm-text-outline: 1 [C2]; font-size: [S]px\">[X]</span>"

#define FONT_COLORED(color, text) "<font color='[color]'>[text]</font>"

#define FONT_SMALL(X) "<font size='1'>[X]</font>"

#define FONT_NORMAL(X) "<font size='2'>[X]</font>"

#define FONT_LARGE(X) "<font size='3'>[X]</font>"

#define FONT_HUGE(X) "<font size='4'>[X]</font>"

#define FONT_GIANT(X) "<font size='5'>[X]</font>"

#define PRINT_STACK_TRACE(X) get_stack_trace(X, __FILE__, __LINE__)