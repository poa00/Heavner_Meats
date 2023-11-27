priorityMap := Map(
            "Default: (None)", "Vac Pack", "1oz Links", "2oz Links", "Bratwursts (4oz)", "Patties",
            "Vac Pack", ["Default: (1 lb)", "2 lbs", "5 lbs", "10 lbs"],
            "1 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "2 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "5 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "10 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "1oz Links", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "2oz Links", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "Bratwursts (4oz)", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "Patties", ["Default: (4oz)", "2oz", "3oz"],
            "2oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "3oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "4oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"])

MeatMap := Map(
    "Shoulder", Map(
        "Picnic Roast", ["Default: (Grind)", "Roasts", "Whole"],
        "Roasts", Map(
            "Weight", ["Default: (3-4 lbs)", "4-5 lbs", "5-6 lbs", "2-3 lbs"]
        )
    ),
    "Boston Butt", Map(
        "Default: (Bone-in)", "Boneless", "Grind",
        "Bone-in", Map(
            "Default: (Roasts)", "Steaks",
            "Roasts", Map(
                "Weight", ["Default: (3-4 lbs)", "4-5 lbs", "5-6 lbs", "2-3 lbs"]
            )
        ),
        "Boneless", Map(
            "Default: (Roasts)", "Steaks", "Stew Meat", "Cube Steak",
            "Roasts", Map(
                "Weight", ["Default: (3-4 lbs)", "4-5 lbs", "5-6 lbs", "2-3 lbs"]
            ),
            "Stew Meat", Map(
                "Weight", ["Default: (1 lb)", "2 lbs", "5 lbs"]
            )
        )
    ),
    "Backbone", ["Default: (Grind)", "Slab", "Sections"],
    "Loin", Map(
        "Fish Loin", ["Default: (Yes)", "No"]
    ),
    "Loin", Map(
        "Default: (Grind)", "Bone-in", "Boneless", "Cured & Smoked (Nitrites)", "Uncured & Smoked (Celery Powder)",
        "Bone-in", Map(
            "Default: (Roasts)", "Pork Chops", "Whole",
            "Roasts", Map(
                "Size", ["Default: (Halved)", "Thirds", "Quarters"]
            ),
            "Pork Chops", Map(
                "Thickness", ["Default: (1in)", "1.25in", "1.5in", "0.75in"]
            )
        ),
        "Boneless", Map(
            "Default: (Roasts)", "Boneless Chops", "Whole", "Thinly Sliced",
            "Roasts", Map(
                "Size", ["Default: (Halved)", "Thirds", "Quarters"]
            ),
            "Boneless Chops", Map(
                "Thickness", ["Default: (1in)", "1.25in", "1.5in", "0.75in"]
            )
        ),
        "Cured & Smoked (Nitrites)", Map(
            "Size", ["Default: (Canadian Bacon)", "Quartered", "Thirds", "Halved", "Whole"]
        ),
        "Uncured & Smoked (Celery Powder)", Map(
            "Size", ["Default: (Canadian Bacon)", "Quartered", "Thirds", "Halved", "Whole"]
        )
    ),
    "Ribs", ["Default: (Halved)", "Whole", "Grind"],
    "Side Meat", Map(
        "Default: (Grind)", "Whole", "Sections", "Thinly Sliced", "Bacon Cured & Smoked (Nitrites)", "Bacon Uncured & Smoked (Celery Powder)",
        "Sections", ["Default: (Halved)", "Thirds", "Quarters"],
        "Bacon Cured & Smoked (Nitrites)", Map(
            "Size", ["Default: (Sliced)", "Slab", "Halved", "Thirds", "Quartered"]
        ),
        "Bacon Uncured & Smoked (Celery Powder)", Map(
            "Size", ["Default: (Sliced)", "Slab", "Halved", "Thirds", "Quartered"]
        )
    ),
    "Hams", Map(
        "Default: (Grind)", "Bone-in", "Boneless", "Cured & Smoked Hams (Nitrites)", "Uncured & Smoked Hams (Celery Powder)", "Cured & Smoked Sweetheart Hams (Nitrites)", "Uncured & Smoked Sweetheart Hams (Celery Powder)",
        "Bone-in", Map(
            "Default: (Roasts)", "Steaks", "Whole",
            "Roasts", Map(
                "Weight", ["Default: (2-3 lbs)", "3-4 lbs", "4-5 lbs", "5-6 lbs"]
            )
        ),
        "Boneless", Map(
            "Default: (Roasts)", "Steaks", "Whole",
            "Roasts", Map(
                "Weight", ["Default: (2-3 lbs)", "3-4 lbs", "4-5 lbs", "5-6 lbs"]
            )
        ),
        "Cured & Smoked Hams (Nitrites)", Map(
            "Size", ["Default: (Whole)", "Halved", "Quartered"]
        ),
        "Uncured & Smoked Hams (Celery Powder)", Map(
            "Size", ["Default: (Whole)", "Halved", "Quartered"]
        )
    ),
    "Sausage", Map(
        "Trim Packed Unground", ["Default: (No)", "Yes"],
        "Yes", Map(
            "Quantity", ["Default: (None)", "Ranged input value by customer (10 lbs to 1000 lbs)"]
        ),
        "1st Priority", 
        ["Default: (None)", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"],
        "Plain Ground Pork", Map(
            "Default: (None)", "Vac Pack", "1oz Links", "2oz Links", "Bratwursts (4oz)", "Patties",
            "Vac Pack", ["Default: (1 lb)", "2 lbs", "5 lbs", "10 lbs"],
            "1 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "2 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "5 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "10 lb", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "1oz Links", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "2oz Links", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "Bratwursts (4oz)", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "Patties", ["Default: (4oz)", "2oz", "3oz"],
            "2oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "3oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"],
            "4oz", ["Default: (None)", "Input field for weight value (50 lb minimum)"]
        ),
        ; Repeat similar structures for T&E Classic, Breakfast, Mild Italian, Sweet Italian, Hot Italian, Garlic, Chorizo
        "2nd Priority", [],  ; Placeholder for options menu same as 1st priority
        "3rd Priority", [],  ; Placeholder for options menu same as 1st priority
        "4th Priority", [],  ; Placeholder for options menu same as 1st priority
        "5th Priority", []   ; Placeholder for options menu same as 1st priority
    ),
    "Offal", Map(
        "Heart", ["Default: (No)", "Yes"],
        "Liver", ["Default: (No)", "Whole", "Roasts", "Sliced",
            "Roasts", Map(
                "Weight", ["Default: (2-3 lbs)", "3-4 lbs", "1-2 lbs"]
            )
        ],
        "Kidney", ["Default: (No)", "Yes"],
        "Tongue", ["Default: (No)", "Yes"]
    ),
    "Fat", Map(
        "Back Fat", ["Default: (No)", "Yes"],
        "Kidney Fat", ["Default: (No)", "Yes"]
    ),
    "Pork Standard Cut Sheet", []   ; Placeholder for any additional actions at the end
)
