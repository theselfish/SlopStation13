/datum/antagonist/tung_tung_tung_sahur
	name = "Tung Tung Tung Sahur"
	show_in_antag_table = TRUE
	var/silent = FALSE

/datum/antagonist/tung_tung_tung_sahur/on_gain()
	. = ..()
	if(owner && owner.current)
		to_chat(owner.current, "<span class='boldwarning'>TUNG TUNG TUNG SAHUR! It is time to wake everyone up!</span>")

/mob/living/simple_animal/hostile/tung_tung_tung_sahur
	name = "Tung Tung Tung Sahur"
	desc = "TUNG TUNG TUNG SAHUR! SAHUR! SAHUR! Time to wake up!"
	gender = MALE
	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 25
	attack_verb_continuous = "tungs"
	attack_verb_simple = "tung"
	speak = list(
		"TUNG TUNG TUNG SAHUR!",
		"SAHUR! SAHUR!",
		"TUNG TUNG TUNG!",
		"WAKE UP IT'S SAHUR!"
	)
	speak_chance = 30
	faction = list("tung_tung_tung_sahur")
