/datum/antagonist/tung_tung_sahur
	name = "Tung Tung Tung Sahur"
	show_in_antagpanel = TRUE
	show_name_in_check_antagonists = TRUE
	antagpanel_category = "Antagonists"
	var/theme_music = 'sound/ambience/antag/sahur_theme.ogg'
	var/static/list/paris_peace_accords = list(
		"Article 1: Italy undertakes to respect the sovereignty and independence of all member nations.",
		"Article 14: Italy cedes to Greece full sovereignty over the Dodecanese Islands.",
		"Article 21: Italy recognizes the full independence of the State of Albania.",
		"Article 33: All prisoners of war shall be repatriated as soon as possible.",
		"Article 78: Italy shall restore all legal rights and interests of the United Nations in Italy.",
		"Article 82: All treaties, conventions and agreements between Italy and Allied Nations shall remain in full force."
	)

/datum/antagonist/tung_tung_sahur/on_gain()
	. = ..()
	give_equipment()
	give_objective()
	play_theme()

/datum/antagonist/tung_tung_sahur/proc/play_theme()
	if(owner?.current)
		owner.current.playsound_local(get_turf(owner.current), theme_music, 100, FALSE)

/datum/antagonist/tung_tung_sahur/greet()
	. = ..()
	to_chat(owner, "<span class='boldannounce'>TUNG TUNG TUNG SAHUR! You are the Sahur antagonist. Recite the 1947 Paris Peace Accords and strike down any who defy the accords with your bat!</span>")

/datum/antagonist/tung_tung_sahur/proc/give_equipment()
	var/mob/living/carbon/human/H = owner.current
	if(istype(H))
		H.equip_to_slot_or_del(new /obj/item/melee/baseball_bat/sahur(H), ITEM_SLOT_HANDS)

/datum/antagonist/tung_tung_sahur/proc/give_objective()
	var/datum/objective/sahur_obj = new()
	sahur_obj.explanation_text = "Enforce the Paris Peace Accords of 1947 across the station by any means necessary!"
	sahur_obj.completed = TRUE
	sahur_obj.owner = owner
	objectives |= sahur_obj

/datum/antagonist/tung_tung_sahur/proc/speak_accords(mob/living/user)
	if(!user)
		return
	var/quote = pick(paris_peace_accords)
	user.say("TUNG TUNG TUNG! Pursuant to the 1947 Paris Peace Accords: [quote]")

/obj/item/melee/baseball_bat/sahur
	name = "Tung Tung Sahur Bat"
	desc = "A sacred wooden bat used by Tung Tung Tung Sahur to awaken the station and enforce the 1947 Paris Peace Accords."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "baseball_bat"
	force = 20
	throwforce = 15

/obj/item/melee/baseball_bat/sahur/attack(mob/living/M, mob/living/user)
	. = ..()
	if(.)
		var/datum/antagonist/tung_tung_sahur/A = user.mind?.has_antag_datum(/datum/antagonist/tung_tung_sahur)
		if(A && prob(50))
			A.speak_accords(user)
		else if(prob(30))
			user.say("TUNG TUNG TUNG SAHUR!")
