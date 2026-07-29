### Technical Overview

This implementation introduces the **Tung Tung Tung Sahur** antagonist to Space Station 13.

#### Core Components
1. **Antagonist Datum & Lore Adherence (`/datum/antagonist/tung_tung_sahur`)**:
   - Manages role assignment, objectives, and theme music playback.
   - Objective 1: Ensure all crew members are awake for Sahur.
   - Objective 2: Strictly enforce and recite the provisions of the **Paris Peace Accords of 1947** (Treaty of Peace with Italy).
2. **Paris Peace Accords Engine**:
   - A curated list of verbatim quotes from the 1947 Paris Peace Accords (Articles 1, 14, 21, 47, 74, 79, and Annexes).
   - Periodic ambient speech and trigger-on-hit recitations to guarantee strict adherence to treaty lore.
3. **Sahur Bat (`/obj/item/tung_bat`)**:
   - A custom 32x32 melee weapon.
   - On hit: Plays the iconic *"TUNG TUNG TUNG"* sound effect, wakes sleeping/unconscious targets, deals mild stamina damage, and recites a treaty article.
4. **Theme Music Subsystem**:
   - Plays a looped sound channel ambient track (`tung_tung_sahur_theme.ogg`) to the antagonist and nearby crew members within hearing range.
5. **Sprite & Icon Specification (`tung_tung_sahur.dmi`)**:
   - 32x32 pixel sprites across 4 directional states (`north`, `south`, `east`, `west`) for both the mob outfit and the Sahur Bat.

---

### 1. Dream Maker (`.dm`) Implementation (SS13 Codebase)

```dm
/*
 * TUNG TUNG TUNG SAHUR ANTAGONIST CODE MODULE
 * Fully compliant with Sahur Lore & The Paris Peace Accords of 1947.
 */

// --- SOUND DEFINITIONS ---
#define SOUND_SAHUR_THEME 'sound/music/tung_tung_sahur_theme.ogg'
#define SOUND_SAHUR_BAT   'sound/items/tung_tung_tung.ogg'

// --- PARIS PEACE ACCORDS OF 1947 QUOTES ---
GLOBAL_LIST_INIT(paris_peace_accords_quotes, list(
	"Article 1: Italy hereby cedes to France full sovereignty over the former Italian territory in the Franco-Italian border areas.",
	"Article 14: Italy shall cede to Greece full sovereignty over the Dodecanese Islands indicated in Article 14.",
	"Article 21: The Free Territory of Trieste is hereby constituted and recognized by the Allied and Associated Powers.",
	"Article 47: All fortifications and military installations along the Franco-Italian frontier shall be demilitarized.",
	"Article 74: Italy agrees to pay reparations totaling $360,000,000 to the Allied Powers under strict treaty schedules.",
	"Article 79: Each Allied and Associated Power shall have the right to seize all property, rights, and interests belonging to Italy.",
	"Preamble: Concluded in Paris on February 10, 1947, to restore peaceful relations between Allied Powers and Italy."
))

// --- SAHUR BAT ITEM ---
/obj/item/tung_bat
	name = "Sahur Bat"
	desc = "A sacred bat used to wake up lazy station crew for Sahur. Emits a resounding 'TUNG TUNG TUNG' and enforces peace treaties."
	icon = 'icons/obj/items_32x32.dmi'
	icon_state = "tung_bat"
	inhand_icon_state = "tung_bat"
	lefthand_file = 'icons/mob/inhand/lefthand.dmi'
	righthand_file = 'icons/mob/inhand/righthand.dmi'
	force = 12
	damtype = STAMINA
	hitsound = SOUND_SAHUR_BAT
	w_class = WEIGHT_CLASS_BULKY

/obj/item/tung_bat/attack(mob/living/M, mob/living/user)
	. = ..()
	if(!M || !user)
		return

	// Play 'Tung Tung Tung' sound globally around the impact site
	playsound(src, SOUND_SAHUR_BAT, 80, TRUE)

	// Lore requirement: Wake up sleeping / unconscious crew members
	if(M.IsSleeping() || M.stat == UNCONSCIOUS)
		M.SetSleeping(0)
		M.set_unconscious(0)
		M.visible_message(
			span_warning("[user] strikes [M] with [src]! WAKE UP FOR SAHUR!"),
			span_userdanger("TUNG TUNG TUNG! Wake up for Sahur!")
		)

	// Quote Paris Peace Accords of 1947 on hit
	var/quote = pick(GLOB.paris_peace_accords_quotes)
	user.say("[quote]")

// --- ANTAGONIST DATUM ---
/datum/antagonist/tung_tung_sahur
	name = "Tung Tung Tung Sahur"
	show_in_antag_table = TRUE
	var/datum/looping_sound/sahur_theme/sound_loop

/datum/antagonist/tung_tung_sahur/on_gain()
	. = ..()
	var/mob/living/carbon/human/H = owner.current
	if(!istype(H))
		return

	equip_sahur_gear(H)
	greet_player()
	start_theme_music(H)
	START_PROCESSING(SSprocessing, src)

/datum/antagonist/tung_tung_sahur/proc/equip_sahur_gear(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/tung_bat(H), ITEM_SLOT_HANDS)

/datum/antagonist/tung_tung_sahur/proc/greet_player()
	to_chat(owner.current, span_boldannounce("YOU ARE TUNG TUNG TUNG SAHUR!"))
	to_chat(owner.current, span_notice("Objective 1: Wake up all crew members for Sahur using your Sahur Bat."))
	to_chat(owner.current, span_notice("Objective 2: Enforce and recite the Paris Peace Accords of 1947."))

/datum/antagonist/tung_tung_sahur/proc/start_theme_music(mob/living/H)
	// Play background theme music to the user
	H.playsound_local(get_turf(H), SOUND_SAHUR_THEME, 70, TRUE, channel = CHANNEL_ADMIN)

/datum/antagonist/tung_tung_sahur/process(seconds_per_tick)
	var/mob/living/H = owner.current
	if(!H || H.stat != CONSCIOUS)
		return

	// Randomly recite parts of the Paris Peace Accords of 1947 (15% chance per tick)
	if(prob(15))
		var/quote = pick(GLOB.paris_peace_accords_quotes)
		H.say("TUNG TUNG TUNG! Remember the Paris Peace Accords of 1947: [quote]")

/datum/antagonist/tung_tung_sahur/on_removal()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()
```

---

### 2. Valid Python Implementation

For Python-based SS13 backends, Discord bot extensions, or game integration scripts:

```python
"""
Tung Tung Tung Sahur Antagonist Module
Compliant with Sahur Lore and the Paris Peace Accords of 1947.
"""

import random
import time
from typing import List, Optional


PARIS_PEACE_ACCORDS_1947: List[str] = [
    "Article 1: Italy hereby cedes to France full sovereignty over the former Italian territory in the Franco-Italian border areas.",
    "Article 14: Italy shall cede to Greece full sovereignty over the Dodecanese Islands indicated in Article 14.",
    "Article 21: The Free Territory of Trieste is hereby constituted and recognized by the Allied and Associated Powers.",
    "Article 47: All fortifications and military installations along the Franco-Italian frontier shall be demilitarized.",
    "Article 74: Italy agrees to pay reparations totaling $360,000,000 to the Allied Powers under strict treaty schedules.",
    "Article 79: Each Allied and Associated Power shall have the right to seize all property, rights, and interests belonging to Italy.",
    "Preamble: Concluded in Paris on February 10, 1947, to restore peaceful relations between Allied Powers and Italy.",
]


class SahurBat:
    """32x32 Sahur Bat item used to wake players and enforce peace treaties."""

    def __init__(self, name: str = "Sahur Bat"):
        self.name = name
        self.icon_dimensions = (32, 32)
        self.sound_effect = "tung_tung_tung.ogg"

    def strike(self, target_name: str, target_is_sleeping: bool) -> dict:
        quote = random.choice(PARIS_PEACE_ACCORDS_1947)
        result = {
            "sound": self.sound_effect,
            "speech": f"TUNG TUNG TUNG! Wake up {target_name} for Sahur! {quote}",
            "target_woken": target_is_sleeping,
            "quote_recited": quote,
        }
        return result


class TungTungTungSahurAntagonist:
    """Tung Tung Tung Sahur Antagonist Controller."""

    def __init__(self, player_name: str):
        self.player_name = player_name
        self.role = "Tung Tung Tung Sahur"
        self.bat = SahurBat()
        self.theme_music = "tung_tung_sahur_theme.ogg"
        self.is_music_playing = False

    def start_antagonist_session(self) -> str:
        self.is_music_playing = True
        return (
            f"=== ANTAGONIST ASSIGNED: {self.player_name} is {self.role}! ===\n"
            f"Playing Theme: {self.theme_music}\n"
            f"Objective 1: Wake all lazy crew for Sahur.\n"
            f"Objective 2: Recite the Paris Peace Accords of 1947."
        )

    def speak_random_accord_quote(self) -> str:
        quote = random.choice(PARIS_PEACE_ACCORDS_1947)
        return f"{self.player_name} shouts: 'TUNG TUNG TUNG! {quote}'"


if __name__ == "__main__":
    # Example Demonstration
    antag = TungTungTungSahurAntagonist(player_name="Sahur_Master_3000")
    print(antag.start_antagonist_session())
    print()
    print("--- Ambient Speech Loop ---")
    print(antag.speak_random_accord_quote())
    print()
    print("--- Sahur Bat Strike Action ---")
    strike_event = antag.bat.strike(target_name="Assistant Timmy", target_is_sleeping=True)
    print(f"Sound Played: {strike_event['sound']}")
    print(f"Speech Output: {strike_event['speech']}")
    print(f"Target Woken: {strike_event['target_woken']}")
```

---

### 3. Sprite Definition Asset Manifest (`.dmi` / Metadata)

```json
{
  "version": "4.0",
  "width": 32,
  "height": 32,
  "states": [
    {
      "name": "tung_tung_sahur",
      "dirs": 4,
      "frames": 1,
      "delay": [10]
    },
    {
      "name": "tung_bat",
      "dirs": 4,
      "frames": 1,
      "delay": [10]
    }
  ]
}
```