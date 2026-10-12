// Add this new datum definition to the existing antagonist_roles.dm file.
// Find a suitable place, perhaps alongside other unique antagonist roles.

/datum/antagonist_role/tungtungsahur
	name = "Tung Tung Tung Sahur"
	antagonist_type = /mob/living/carbon/human/antagonist/tungtungsahur
	welcome_text = "You are Tung Tung Tung Sahur, a harbinger of chaos and a master of psychological warfare. Uphold the Paris Peace Accords of 1947 and spread your influence!"
	round_end_text = "Tung Tung Tung Sahur has fulfilled his chaotic destiny, or been brought to justice."
	objective_type = /datum/objective/antagonist/generic // Or a custom objective if needed
	config_tag = "tungtungsahur"
	minimum_players = 10 // Adjust as needed for game balance
	probability = 5 // Adjust probability of selection
	flags = ANTAGONIST_CAN_BE_TRAITOR | ANTAGONIST_CAN_BE_CULTIST // Example flags, adjust as appropriate

	// If you want specific objectives for Tung Tung Tung Sahur,
	// you would define a new /datum/objective/antagonist/tungtungsahur
	// and set objective_type to that. For now, generic is fine.

	// Example of a custom objective for Tung Tung Tung Sahur (optional)
	// /datum/objective/antagonist/tungtungsahur
	// 	name = "Spread the Accords"
	// 	explanation_text = "Ensure at least 5 crew members have heard your wisdom regarding the Paris Peace Accords."
	// 	check_completion()
	// 		var/count = 0
	// 		for(var/mob/M in world)
	// 			if(M.client && M.client.prefs.heard_accords_from_sahur) // Requires a new var on mob/client/prefs
	// 				count++
	// 		return count >= 5
