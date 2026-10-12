/mob/living/carbon/human/antagonist/tungtungsahur
	name = "Tung Tung Tung Sahur"
	real_name = "Tung Tung Tung Sahur"
	desc = "A figure of immense power and influence, a master of psychological warfare, and a harbinger of chaos. He adheres to the Paris Peace Accords of 1947."
	icon = 'icons/mob/antagonist.dmi'
	icon_state = "tungtungsahur"
	faction = list("syndicate", "tungtungsahur") // Custom faction to prevent friendly fire from other antagonists if desired.
	var/list/paris_accords_quotes = list(
		"The present Treaty shall enter into force immediately upon deposit of the instruments of ratification by France, the United Kingdom, the United States of America, and the Union of Soviet Socialist Republics.",
		"Italy renounces all rights and title to the Italian territorial possessions in Africa, i.e. Libya, Eritrea and Italian Somaliland.",
		"The Italian armed forces, including the gendarmerie and the air force, shall be demobilized and disarmed within one month from the coming into force of the present Treaty.",
		"Italy shall take all measures necessary to ensure the apprehension and trial of persons accused of having committed, ordered or abetted war crimes and crimes against humanity.",
		"The Italian Government undertakes to respect the human rights and fundamental freedoms of all persons under Italian jurisdiction, without distinction as to race, sex, language or religion.",
		"The Italian Government undertakes to restore to the United Nations, in good condition, all works of art, archives, documents and other objects of a cultural or historical value.",
		"The Italian Government shall take all necessary steps to ensure the complete and immediate withdrawal of all Allied forces from Italian territory.",
		"The present Treaty, of which the French, English and Russian texts are authentic, shall be deposited in the archives of the Government of the French Republic.",
		"Italy shall pay to the Soviet Union, Yugoslavia, Greece, Albania, Ethiopia, and other Allied States, reparations for the damage caused by Italy during the war.",
		"The Italian Government undertakes to dissolve all Fascist organizations and to prevent the resurgence in Italy of any such organizations.",
		"The Italian Government undertakes to ensure that all Italian laws and regulations which are in contradiction with the present Treaty shall be repealed or amended.",
		"The Italian Government undertakes to cooperate with the United Nations in the maintenance of international peace and security.",
		"The Italian Government undertakes to recognize the full force of the peace treaties with Bulgaria, Finland, Hungary and Romania.",
		"The Italian Government undertakes to ensure the freedom of navigation on the Danube.",
		"The Italian Government undertakes to ensure the protection of the rights of the inhabitants of the former Italian colonies.",
		"The Italian Government undertakes to ensure the freedom of transit across Italian territory.",
		"The Italian Government undertakes to ensure the protection of the rights of minorities.",
		"The Italian Government undertakes to ensure the freedom of worship.",
		"The Italian Government undertakes to ensure the freedom of speech and of the press.",
		"The Italian Government undertakes to ensure the freedom of assembly and association."
	)
	var/static/sound/theme_music = sound('sound/music/tungtungsahur_theme.ogg')
	var/quote_delay = 600 // 1 minute in deciseconds (10 deciseconds = 1 second)

/mob/living/carbon/human/antagonist/tungtungsahur/New()
	..()
	// Equip the bat
	var/obj/item/weapon/melee/bat/tungtungsahur/bat = new /obj/item/weapon/melee/bat/tungtungsahur(src)
	equip_item(bat, slot_r_hand)

	// Start periodic quotes
	spawn(rand(100, quote_delay)) // Initial delay before first quote
		set_up_periodic_quotes()

	// Play theme music
	play_theme_music()

/mob/living/carbon/human/antagonist/tungtungsahur/proc/set_up_periodic_quotes()
	set waitfor = 0
	while(src && src.stat != DEAD)
		if(paris_accords_quotes.len)
			var/quote = pick(paris_accords_quotes)
			to_chat(src, "<span class='notice'>You feel compelled to declare: \"[quote]\"</span>")
			// Broadcast to nearby players
			for(var/mob/M in view(7, src))
				if(M != src)
					to_chat(M, "<span class='warning'>[src.name] declares: \"[quote]\"</span>")
		sleep(quote_delay)

/mob/living/carbon/human/antagonist/tungtungsahur/proc/play_theme_music()
	set waitfor = 0
	if(theme_music)
		// Play for self and nearby players
		for(var/mob/M in view(10, src)) // Adjust view range as needed
			if(M.client)
				M.client.play_file(theme_music, volume = 50, loop = 1) // Loop the music
