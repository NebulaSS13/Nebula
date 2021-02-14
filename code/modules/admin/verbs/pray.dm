/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	sanitize_and_communicate(/decl/communication_channel/pray, src, msg)
	SSstatistics.add_field_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/Centcomm_announce(var/msg, var/mob/Sender, var/iamessage)
	msg = "<span class='notice'><b><font color=orange>[uppertext(GLOB.using_map.boss_short)]M[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=show_round_status'>RS</A>) (<A HREF='?_src_=holder;Artillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder;CentcommReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"

	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	msg = "<span class='notice'><b><font color=crimson>ILLEGAL:</font>[key_name(Sender, 1)] (<A HREF='?_src_=holder;adminplayeropts=\ref[Sender]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[Sender]'>VV</A>) (<A HREF='?_src_=holder;narrateto=\ref[Sender]'>DN</A>) ([admin_jump_link(Sender)]) (<A HREF='?_src_=holder;secretsadmin=show_round_status'>RS</A>) (<A HREF='?_src_=holder;Artillery=\ref[Sender]'>BSA</A>) (<A HREF='?_src_=holder'>TAKE</a>) (<A HREF='?_src_=holder;SyndicateReply=\ref[Sender]'>RPLY</A>):</b> [msg]</span>"
	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			to_chat(C, msg)
			sound_to(C, 'sound/machines/signal.ogg')