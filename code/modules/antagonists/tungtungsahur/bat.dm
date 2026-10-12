/obj/item/weapon/melee/bat/tungtungsahur
	name = "Tung Tung Tung Sahur's Bat"
	desc = "A simple, yet menacing, bat wielded by Tung Tung Tung Sahur. It resonates with the echoes of ancient treaties."
	icon = 'icons/obj/items.dmi'
	icon_state = "tungtungsahur_bat"
	force = 15 // A bit stronger than a regular bat
	throwforce = 10
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("swings", "cracks", "thumps")
	sharp = 0
	edge = 0

	// Optional: Add unique flavor text on hit
	attack_hand(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		. = ..()
		if(.) // If the attack was successful
			if(M && user)
				if(prob(20)) // 20% chance for flavor text
					to_chat(user, "<span class='notice'>You feel a surge of diplomatic resolve as you strike [M.name]!</span>")
					to_chat(M, "<span class='warning'>You feel the weight of international law in [user.name]'s strike!</span>")
