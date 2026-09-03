/obj/item/projectile/webball
	name = "ball of web"
	icon_state = "bola"
	damage = 10
	muzzle_type = null

/obj/item/projectile/webball/on_hit(var/atom/target, var/blocked = 0)
	if(isturf(target.loc))
		var/obj/effect/spider/stickyweb/web = locate() in get_turf(target)
		if(!web && prob(75))
			visible_message(SPAN_DANGER("\The [src] splatters a layer of web on \the [target]!"))
			new /obj/effect/spider/stickyweb(target.loc)
	..()