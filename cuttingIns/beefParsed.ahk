Weight := ["1 lb", "2 lbs", "5 lbs", "10 lbs"]
Tomahawks := ["*no", "Yes"]
thickness := ["1.5in", "1in", "1.25in", "1.75in", "0.75in"]
steaks := ["Whole", "Steaks", "Grind"]
NoPack := ["2", "3", "4", "1"]

shortRibs := Map(
    "Grind", "Grind",
    "Plate", "Plate",
    "English", Map(
        "Bone-in", Map(
            "3 X 2", "3 X 2",
            "4 X 2", "4 X 2",
            "2 X 2", "2 X 2"
        ),
        "Boneless", Map("Weight?", Weight)
    ),
    "Korean", "Korean",
    "Bacon", Map(
        "Celery", "Celery",
        "Nitrite", "Nitrite",
        "Slab", "Slab",
        "Sliced", "Sliced"
    )
)
chuck := Map(
    "Grind", "Grind",
    "Bone-in", Map(
        "Roasts", Map("Weight?", Weight),
        "Steaks", Map(
            "Flat irons", Map(
                "Whole or steaks", steaks,
                "Steaks", Map("multi", Map(
                    "Thickness", thickness,
                    "No./Pack", ["2", "3", "4", "1"]
                ))
            ),
            "Mock tender", Map(
                "Whole or steaks", steaks,
                "Steaks", Map("multi", Map(
                    "Thickness?", thickness,
                    "No./Pack", ["2", "3", "4", "1"]
                ))
            ),
            "Denver", ["Steaks", "Grind"],
            "Chuckeye", ["Steaks", "Grind"]
        )
    ),
    "Boneless", Map(
        "Roasts", Weight,
        "Steaks", Map(
            "Flat irons", Map(
                "Whole or steaks", steaks,
                "Steaks", Map("multi", Map(
                    "Thickness?", thickness,
                    "No./Pack", ["2", "3", "4", "1"]
                ))
            ),
            "Mock tender", Map(
                "Whole or steaks", steaks,
                "Steaks", Map("multi", Map(
                    "Thickness", thickness,
                    "No./Pack", ["2", "3", "4", "1"]
                ))
            ),
            "Denver", ["Steaks", "Grind"],
            "Chuckeye", ["Steaks", "Grind"]
        )
    )
)

arm := Map(
    "Grind", "Grind",
    "Bone-in", Map(
        "Roasts", Weight
    ),
    "Boneless", Map(
        "Roasts", Weight,
        "Ranch steaks", "Ranch steaks"
    )
)

ribEye := Map(
    "Grind", "Grind",
    "Bone-in", Map(
        "Steaks", Map("multi",Map(
            "Thickness", thickness,
            "Tomahawks", Tomahawks,
            "No./Pack", ["2", "1"]
        )),
        "Roasts", Map("multi", Map(
            "Size", ["Halved", "Whole", "Thirds"],
            "Frenched", ["No", "Yes"]
        ))
    ),
    "Boneless", Map(
        "Steaks", Map("multi", Map(
            "Thickness", thickness,
            "No./Pack", ["2", "3", "4", "1"],
            "Spare ribs", ["Yes", "Grind"]
        )),
        "Roasts", Map("multi", Map(
            "Size", ["Halved", "Whole", "Thirds"],
            "Spare ribs", ["Yes", "Grind"]
        )
    )
))

loinSteaks := Map(
    "Short loin MISSING TODO SERLOIN", Map(
        "TBone/porterhouse", Map(
            "No pack && thickness", thickness
        ),
        "Ny strip/Filet", Map(
            "Whole or steaks", Map(
                "Steaks", Map("multi", Map(
                    "Thickness", thickness,
                    "No per pack", ["2", "3", "4", "1"]
                ))
            ),
            "Roasts", Weight,
            "Steaks", Map("multi", Map(
                "Thickness", thickness,
                "No/Pack", ["2", "3", "4", "1"]
            )
        ))
    )
)

ground := Map(
    "Trim packed unground", Map(
        "No", "Finished.",
        "Yes", ["None", "Ranged input value by customer (10 lbs to 1000 lbs)"]
    ),
    "Ground beef", Map(
        "1 lb", ["100% 1 lb", "2 lbs (50%)", "5 lbs (50%)", "10 lbs (50%)"],
        "2 lb", ["100% 2 lbs", "1 lb (50%)", "5 lbs (50%)", "10 lbs (50%)"],
        "5 lb", ["100% 5 lbs", "1 lb (50%)", "2 lbs (50%)", "10 lbs (50%)"],
        "10 lb", ["100% 5 lbs", "1 lb (50%)", "2 lbs (50%)", "10 lbs (50%)"],
        "10 lbs", ["100% 10 lbs", "1 lb (50%)", "2 lbs (50%)", "5 lbs (50%)"]
    ),
    "Beef patties", Map(
        "None", "Finished.",
        "25 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "50 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "75 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        ),
        "100 lbs", Map(
            "Weight", ["4oz", "5oz", "6oz"]
        )
    )
)

londonBroil := Map(
    "Grind", "Finished.",
    "Thinly Sliced", Map("Yes", "No"),
    "Cube Steak",  Map("Yes", "No"),
    "Roasts", Map(
        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
    ),
    "Steaks", Map(
        "Thickness", thickness
    ),
    "Stew meat", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    ),
    "Fajita", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    ),
    "Kabob", Map(
        "Weight", ["1 lb", "2 lbs", "5 lbs"]
    )
)

offal := Map(
    "Liver", Map(
        "No", "No",
        "Whole", "Whole",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Sliced", "Sliced"
    ),
    "Kidney", ["No", "Yes"],
    "Oxtail", ["No", "Yes"],
    "Beef back fat", ["No", "Yes"],
    "Beef kidney fat", ["No", "Yes"]
)

BeefMap := Map(
    "Chuck", chuck,
    "Arm", arm,
    "Brisket", ["Grind", "Whole", "Halved", "Quartered"],
    "Sternum bacon", 
        [
            Map("Celery", ["Slab", "Sliced"]), 
            Map("Nitrite", ["Slab", "Sliced"]), 
        ],
    "Shanks", Map(
        "Grind", "Finished.",
        "Whole", "Finished.",
        "Shank cuts", ["2in", "1.5in", "1in"]
    ),
    "Skirt", Map("Grind", "Finished.", "Steak", "Finished."),
    "Bones", Map(
        "No", "No",
        "Marrow only", "Finished.",
        "Knuckles only", "Finished.",
        "Marrows & knuckles", "Finished."
    ),
    "Short ribs", shortRibs,
    "Ribeye", ribeye,
     "Hanger", ["Grind", "Steak"],
     "Flank", ["Grind", "Steak"],
    "Loin steaks", loinSteaks,
    "Tritip", "Yes",
    "London broil", londonBroil,
    "Top round", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        )
    ),
    "Bottom round", Map(
        "Grind", "Grind",
        "Roasts", Map(
            "Weight", Weight
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        )
    ),
    "Eye of round", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs, 5 lbs"]
        )
    ),
    "Sirloin tip", Map(
        "Grind", "Finished.",
        "Roasts", Map(
            "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
        ),
        "Steaks", Map(
            "Thickness", thickness
        ),
        "Stew meat", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Fajita", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        ),
        "Kabob", Map(
            "Weight", ["1 lb", "2 lbs", "5 lbs"]
        )
    ),
    "Fat", Map(
        "Backfat", "Yes",
        "Kidneyfat", "Yes",
        "Grind", "Yes"
    ),
    "Ground", ground,
    "Offal", offal
)

#Include <cJson>
FileOpen("beef.json", "w").Write(Json.Dump(BeefMap))