; Define the PorkMap
PorkMap := Map(
    "Shoulder", Map(
        "Picnic Roast", Map(
            "Default", ["Grind", "Roasts", "Whole"]
        ),
        "Boston Butt", Map(
            "Default", ["Bone-in", "Boneless", "Grind"],
            "Bone-in", Map(
                "Default", ["Roasts", "Steaks"],
                "Roasts", Map(
                    "Weight", ["3-4 lbs", "4-5 lbs", "5-6 lbs", "2-3 lbs"]
                )
            ),
            "Boneless", Map(
                "Default", ["Roasts", "Steaks", "Stew Meat", "Cube Steak"],
                "Roasts", Map(
                    "Weight", ["3-4 lbs", "4-5 lbs", "5-6 lbs", "2-3 lbs"]
                ),
                "Stew Meat", Map(
                    "Weight", ["1 lb", "2 lbs", "5 lbs"]
                )
            )
        ),
        "Backbone", Map(
            "Default", ["Grind", "Slab", "Sections"]
        )
    ),
    "Loin", Map(
        "Fish Loin", ["Yes", "No"]
    ),
    "Ribs", Map(
        "Ribs", ["Halved", "Whole", "Grind"]
    ),
    "Side Meat", Map(
        "Default", ["Grind", "Whole", "Sections", "Thinly Sliced", "Bacon Cured & Smoked (Nitrites)", "Bacon Uncured & Smoked (Celery Powder)"],
        "Sections", ["Halved", "Thirds", "Quarters"],
        "Bacon Cured & Smoked (Nitrites)", Map(
            "Size", ["Sliced", "Slab", "Halved", "Thirds", "Quartered"]
        ),
        "Bacon Uncured & Smoked (Celery Powder)", Map(
            "Size", ["Sliced", "Slab", "Halved", "Thirds", "Quartered"]
        )
    ),
    "Hams", Map(
        "Hams", ["Grind", "Bone-in", "Boneless", "Cured & Smoked Hams (Nitrites)", "Uncured & Smoked Hams (Celery Powder)", "Cured & Smoked Sweetheart Hams (Nitrites)", "Uncured & Smoked Sweetheart Hams (Celery Powder)"],
        "Bone-in", Map(
            "Default", ["Roasts", "Steaks", "Whole"],
            "Roasts", Map(
                "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "5-6 lbs"]
            )
        ),
        "Boneless", Map(
            "Default", ["Roasts", "Steaks", "Whole"],
            "Roasts", Map(
                "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "5-6 lbs"]
            )
        ),
        "Cured & Smoked Hams (Nitrites)", Map(
            "Size", ["Whole", "Halved", "Quartered"]
        ),
        "Uncured & Smoked Hams (Celery Powder)", Map(
            "Size", ["Whole", "Halved", "Quartered"]
        )
    ),
    "Sausage", Map(
        "Trim Packed Unground", Map(
            "Default", ["No", "Yes"],
            "Yes", ["None", "Ranged input value by customer (10 lbs to 1000 lbs)"]
        ),
        "1st Priority", ["None", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"],
        "2nd Priority", ["None", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"],
        "3rd Priority", ["None", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"],
        "4th Priority", ["None", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"],
        "5th Priority", ["None", "Plain Ground Pork", "T&E Classic", "Breakfast", "Mild Italian", "Sweet Italian", "Hot Italian", "Garlic", "Chorizo"]
    ),
    "Offal", Map(
        "Heart", ["No", "Yes"],
        "Liver", Map(
            "Default", ["No", "Whole", "Roasts", "Sliced"],
            "Roasts", Map(
                "Weight", ["2-3 lbs", "3-4 lbs", "1-2 lbs"]
            )
        ),
        "Kidney", ["No", "Yes"],
        "Tongue", ["No", "Yes"]
    ),
    "Fat", Map(
        "Back Fat", ["No", "Yes"],
        "Kidney Fat", ["No", "Yes"]
    )
) ; Missing Parentheses
