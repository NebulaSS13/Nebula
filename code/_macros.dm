#define any2ref(x) "\ref[x]"

#define PUBLIC_GAME_MODE SSticker.master_mode

#define CLAMP01(x) 		(clamp(x, 0, 1))

#define get_turf(A) get_step(A,0)

#define get_area(A) (get_step(A, 0)?.loc)

#define get_x(A) (get_step(A, 0)?.x || 0)

#define get_y(A) (get_step(A, 0)?.y || 0)

#define get_z(A) (get_step(A, 0)?.z || 0)

#define isAI(A) istype(A, /mob/living/silicon/ai)

#define isanimal(A) istype(A, /mob/living/simple_animal)

#define isairlock(A) istype(A, /obj/machinery/door/airlock)

#define isatom(A) isloc(A)

#define isbrain(A) istype(A, /mob/living/brain)

#define isclient(A) istype(A, /client)

#define iscorgi(A) istype(A, /mob/living/simple_animal/corgi)

#define isdrone(A) istype(A, /mob/living/silicon/robot/drone)

#define isEye(A) istype(A, /mob/observer/eye)

#define ishuman(A) istype(A, /mob/living/human)

#define isitem(A) istype(A, /obj/item)

#define isliving(A) istype(A, /mob/living)

#define ismouse(A) istype(A, /mob/living/simple_animal/passive/mouse)

#define islizard(A) istype(A, /mob/living/simple_animal/lizard)

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

#define isbot(A) istype(A, /mob/living/bot)

#define isexosuit(A) istype(A, /mob/living/exosuit)

#define isunderwear(A) istype(A, /obj/item/underwear)

#define isvirtualmob(A) istype(A, /mob/observer/virtual)

#define isweakref(A) istype(A, /weakref)

#define attack_animation(A) if(istype(A)) A.do_attack_animation(src)

#define isplunger(A) istype(A, /obj/item/plunger)

#define isassembly(A) istype(A, /obj/item/assembly)

#define isigniter(A) istype(A, /obj/item/assembly/igniter)

#define istimer(A) istype(A, /obj/item/assembly/timer)

#define sequential_id(key) uniqueness_repository.Generate(/datum/uniqueness_generator/id_sequential, key)

#define random_id(key,min_id,max_id) uniqueness_repository.Generate(/datum/uniqueness_generator/id_random, key, min_id, max_id)

/proc/place_meta_charset(content)
	if(istext(content))
		content = "<!DOCTYPE html><meta charset=\"utf-8\">" + content
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
#define ftp_to(target, file_entry, suggested_name)          target << ftp(file_entry, suggested_name)
#define open_file_for(target, file)                         target << run(file)
#define to_savefile(target, key, value)                     target[(key)] << (value)
#define from_savefile(target, key, value)                   target[(key)] >> (value)
#define to_output(target, output_content, output_args)      target << output((output_content), (output_args))
// Avoid using this where possible, prefer the other helpers instead.
#define direct_output(target, value)                        target << (value)

/proc/html_icon(var/thing) // Proc instead of macro to avoid precompiler problems.
	. = "\icon[thing]"

#define MAP_IMAGE_PATH "nano/images/[global.using_map.path]/"

#define map_image_file_name(z_level) "[global.using_map.path]-[z_level].png"

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) (CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define CanPhysicallyInteractWith(user, target) (target.CanUseTopicPhysical(user) == STATUS_INTERACTIVE)

#define DROP_NULL(x) if(x) { x.dropInto(loc); x = null; }

#define ARGS_DEBUG log_debug("[__FILE__] - [__LINE__]") ; for(var/arg in args) { log_debug("\t[log_info_line(arg)]") }

/// Insert an object A into a sorted list using cmp_proc (/code/_helpers/cmp.dm) for comparison.
#define ADD_SORTED(list, A, cmp_proc) if(!list.len) {list.Add(A)} else {list.Insert(FindElementIndex(A, list, cmp_proc), A)}

//Currently used in SDQL2 stuff
#define send_output(target, msg, control) target << output(msg, control)
#define send_link(target, url) target << link(url)

// Spawns multiple objects of the same type
#define cast_new(type, num, args...) if((num) == 1) { new type(args) } else { for(var/i=0;i<(num),i++) { new type(args) } }

#define FLAGS_EQUALS(flag, flags) ((flag & (flags)) == (flags))

#define JOINTEXT(X) jointext(X, null)

#define SPAN_STYLE(S, X) "<span style='" + S + "'>" + X + "</span>"
#define SPAN_CLASS(C, X) "<span class='" + C + "'>" + X + "</span>"

#define SPAN_ITALIC(X)        SPAN_CLASS("italic",        X)
#define SPAN_BOLD(X)          SPAN_CLASS("bold",          X)
#define SPAN_NOTICE(X)        SPAN_CLASS("notice",        X)
#define SPAN_WARNING(X)       SPAN_CLASS("warning",       X)
#define SPAN_DANGER(X)        SPAN_CLASS("danger",        X)
#define SPAN_ROSE(X)          SPAN_CLASS("rose",          X)
#define SPAN_OCCULT(X)        SPAN_CLASS("cult",          X)
#define SPAN_CULT_ANNOUNCE(X) SPAN_CLASS("cultannounce",  X)
#define SPAN_MFAUNA(X)        SPAN_CLASS("mfauna",        X)
#define SPAN_SUBTLE(X)        SPAN_CLASS("subtle",        X)
#define SPAN_INFO(X)          SPAN_CLASS("info",          X)
#define SPAN_RED(X)           SPAN_CLASS("font_red",      X)
#define SPAN_ORANGE(X)        SPAN_CLASS("font_orange",   X)
#define SPAN_YELLOW(X)        SPAN_CLASS("font_yellow",   X)
#define SPAN_GREEN(X)         SPAN_CLASS("font_green",    X)
#define SPAN_BLUE(X)          SPAN_CLASS("font_blue",     X)
#define SPAN_VIOLET(X)        SPAN_CLASS("font_violet",   X)
#define SPAN_PURPLE(X)        SPAN_CLASS("font_purple",   X)
#define SPAN_GREY(X)          SPAN_CLASS("font_grey",     X)
#define SPAN_MAROON(X)        SPAN_CLASS("font_maroon",   X)
#define SPAN_PINK(X)          SPAN_CLASS("font_pink",     X)
#define SPAN_PALEPINK(X)      SPAN_CLASS("font_palepink", X)
#define SPAN_SINISTER(X)      SPAN_CLASS("sinister", X)
#define SPAN_MODERATE(X)      SPAN_CLASS("moderate", X)
#define SPAN_DEADSAY(X)       SPAN_CLASS("deadsay", X)
// placeholders
#define SPAN_GOOD(X)          SPAN_GREEN(X)
#define SPAN_NEUTRAL(X)       SPAN_BLUE(X)
#define SPAN_BAD(X)           SPAN_RED(X)
#define SPAN_HARDSUIT(X)      SPAN_BLUE(X)

#define CSS_CLASS_RADIO "radio"

#define STYLE_SMALLFONTS(X, S, C1) "<span style=\"font-family: 'Small Fonts'; color: [C1]; font-size: [S]px\">[X]</span>"

#define STYLE_SMALLFONTS_OUTLINE(X, S, C1, C2) "<span style=\"font-family: 'Small Fonts'; color: [C1]; -dm-text-outline: 1 [C2]; font-size: [S]px\">[X]</span>"

#define FONT_COLORED(color, text) "<font color='[color]'>[text]</font>"

#define FONT_SMALL(X) "<font size='1'>[X]</font>"

#define FONT_NORMAL(X) "<font size='2'>[X]</font>"

#define FONT_LARGE(X) "<font size='3'>[X]</font>"

#define FONT_HUGE(X) "<font size='4'>[X]</font>"

#define FONT_GIANT(X) "<font size='5'>[X]</font>"

#define PRINT_STACK_TRACE(X) get_stack_trace(X, __FILE__, __LINE__)

/// Checks if potential_weakref is a weakref of thing.
/// NOTE: These argments are the opposite order of TG's, because I think TG's are counterintuitive.
#define IS_WEAKREF_OF(potential_weakref, thing) (istype(thing, /datum) && !isnull(potential_weakref) && thing.weakref == potential_weakref)