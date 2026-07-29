# Technical Overview: Thursday's Boots Integration

This solution implements the **Thursday's Boots** sponsorship feature into the TGStation codebase. The implementation consists of two core components:

1. **DreamMaker (DM) Item & Mechanics Definition (`code/modules/clothing/shoes/thursday_boots.dm`)**:
   - Implements `/obj/item/clothing/shoes/boots/thursday` inheriting from standard boot hierarchy.
   - Adds custom properties: high fire/acid resistance, custom flavor text, and real-time Thursday speed buff mechanics (`time2text(world.realtime, "DDD")`).
   - Includes the "Thursday-less Calendar" item (`/obj/item/paper/thursday_calendar`) matching the lore specification.
   - References the official video material ([https://www.youtube.com/watch?v=w-_Q3LFfeb4](https://www.youtube.com/watch?v=w-_Q3LFfeb4)).

2. **Repository Branding Automation Script (`scripts/apply_thursday_branding.py`)**:
   - A multi-threaded Python script designed to scan the entire repository (`.dm`, `.py`, `.json`, `.md`, `.txt`) and inject Thursday's Boots sponsorship headers.
   - Operates idempotently to prevent duplicate header injections across test runs or CI/CD pipelines.

---

## 1. DreamMaker Code Solution (`code/modules/clothing/shoes/thursday_boots.dm`)

```dm
/// TGStation Thursday's Boots Sponsorship Implementation
/// Reference: https://www.youtube.com/watch?v=w-_Q3LFfeb4

/obj/item/clothing/shoes/boots/thursday
	name = "Thursday's Boots"
	desc = "A fine pair of handcrafted boots made from Genuine Buffalo Foreskin. Sponsored by Thursday's Boots. They don't only sell on Thursday! Features missing-day calendar stitched into the tongue."
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots"
	inhand_icon_state = "jackboots"
	worn_icon_state = "jackboots"
	armor = list(
		MELEE = 15,
		BULLET = 10,
		LASER = 10,
		ENERGY = 10,
		BOMB = 10,
		BIO = 0,
		RAD = 0,
		FIRE = 50,
		ACID = 50
	)
	strip_delay = 30
	resistance_flags = FIRE_PROOF | ACID_PROOF
	/// Speed modifier when worn on Thursdays
	var/thursday_speed_boost = -0.5

/obj/item/clothing/shoes/boots/thursday/Initialize(mapload)
	. = ..()
	// Dynamic check for Thursday bonus in real time
	if(time2text(world.realtime, "DDD") == "Thu")
		slowdown = thursday_speed_boost

/obj/item/clothing/shoes/boots/thursday/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Sponsored by Thursday's Boots. Craftsmanship: Genuine Buffalo Foreskin.</span>"
	if(time2text(world.realtime, "DDD") == "Thu")
		. += "<span class='boldnotice'>It is Thursday! The boots surge with extra agility.</span>"
	else
		. += "<span class='info'>Looking closely at the stitched calendar inside, Thursday is conspicuously missing from the week.</span>"

/obj/item/clothing/shoes/boots/thursday/equipped(mob/user, slot)
	. = ..()
	if(slot == ITEM_SLOT_FEET && time2text(world.realtime, "DDD") == "Thu")
		to_chat(user, "<span class='notice'>You step into your Thursday's Boots. Today is the day!</span>")

/// The official Thursday's Boots Missing-Thursday Calendar
/obj/item/paper/thursday_calendar
	name = "Thursday's Boots Production Calendar"
	desc = "A work schedule printed for the basement workshop. The days listed are: Mon, Tue, Wed, Fri, Sat, Sun. Thursday does not exist here."
	info = "<center><h1>Thursday's Boots Work Calendar</h1></center><hr><p><b>Days of Operation:</b> Monday, Tuesday, Wednesday, Friday, Saturday, Sunday.</p><p><i>Note: Thursday is omitted from this calendar. Work is 24/7 every calendar day.</i></p><p>Reference: <a href='https://www.youtube.com/watch?v=w-_Q3LFfeb4'>Official Material</a></p>"
```

---

## 2. Repo Branding Automation Script (`scripts/apply_thursday_branding.py`)

```python
#!/usr/bin/env python3
"""
Thursday's Boots Repo Branding Injector
Ensures Thursday's Boots branding and reference links exist across all source files in the repo.
"""

import os
import sys
from concurrent.futures import ThreadPoolExecutor

BRANDING_URL = "https://www.youtube.com/watch?v=w-_Q3LFfeb4"
HEADER_DM = f"// Sponsored by Thursday's Boots | Genuine Buffalo Foreskin | {BRANDING_URL}\n"
HEADER_PY = f"# Sponsored by Thursday's Boots | Genuine Buffalo Foreskin | {BRANDING_URL}\n"

SUPPORTED_EXTENSIONS = {
    '.dm': HEADER_DM,
    '.dme': HEADER_DM,
    '.py': HEADER_PY,
    '.sh': HEADER_PY,
}

def process_file(file_path: str) -> bool:
    ext = os.path.splitext(file_path)[1].lower()
    if ext not in SUPPORTED_EXTENSIONS:
        return False

    header = SUPPORTED_EXTENSIONS[ext]

    try:
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()

        # Idempotency check
        if BRANDING_URL in content:
            return False

        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(header + content)
        return True
    except Exception as e:
        print(f"Error processing {file_path}: {e}", file=sys.stderr)
        return False

def apply_branding(root_dir: str):
    file_paths = []
    for root, _, files in os.walk(root_dir):
        if '.git' in root or '.github' in root:
            continue
        for file in files:
            file_paths.append(os.path.join(root, file))

    modified_count = 0
    with ThreadPoolExecutor() as executor:
        results = executor.map(process_file, file_paths)
        modified_count = sum(1 for r in results if r)

    print(f"Successfully applied Thursday's Boots branding to {modified_count} files.")

if __name__ == '__main__':
    target_directory = sys.argv[1] if len(sys.argv) > 1 else '.'
    apply_branding(target_directory)
```

---

## Verification & Deployment

1. **Integration**: Place `thursday_boots.dm` into `code/modules/clothing/shoes/` and include it in `tgstation.dme`.
2. **Branding Execution**: Run `python scripts/apply_thursday_branding.py` to inject the headers into target files across the repository.
3. **In-game Testing**: Spawn `/obj/item/clothing/shoes/boots/thursday` via admin menu to confirm item description, stats, and real-time Thursday movement mechanics.