class porkParsed
{
    static Call()
    {
        shoulder := Map(
            "Picnic roast", Map(
                "Grind", "Finished.",
                "Roasts", Map(
                    "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                )
            ),
            "Boston butt", Map(
                "Bone-in", Map(
                    "Steaks", Map(
                        "Thickness", ["1.5in", "1in", "1.25in", "1.75in", "0.75in"],
                        "No./Pack", ["2", "3", "4", "1"]
                    ),
                    "Roasts", Map(
                        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                    )
                ),
                "Boneless", Map(
                    "Steaks", Map(
                        "Thickness", ["1.5in", "1in", "1.25in", "1.75in", "0.75in"],
                        "No./Pack", ["2", "3", "4", "1"]
                    ),
                    "Roasts", Map(
                        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                    ),
                    "Kebob", "Finished.", ; Specific quantity/pack details would be needed
                    "Shoulder bacon", Map(
                        "Celery", "Celery",
                        "Nitrite", "Nitrite"
                    ),
                    "Stew meat", Map(
                        "Weight", ["1 lb", "2 lbs", "5 lbs"]
                    ),
                    "Fajita", Map(
                        "Weight", ["1 lb", "2 lbs", "5 lbs"]
                    )
                ),
                "Jowels", Map(
                    "Fresh", "Finished.",
                    "Smoked", Map(
                        "Nitrite", "Nitrite",
                        "Celery Power", "Celery Power"
                    ),
                    "Grind", "Finished."
                ),
                "Backbone", Map(
                    "Yes", "Finished.",
                    "Grind", "Finished."
                )
            )
        )

        loin := Map(
            "Bone in", Map(
                "Roast", Map(
                    "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                ),
                "Chops", Map(
                    "Thickness", ["1.5in", "1in", "1.25in", "1.75in", "0.75in"],
                    "No./Pack", ["2", "3", "4", "1"]
                ),
                "Fishloin", Map(
                    "Pull", "Finished.",
                    "Keep", "Finished.",
                    "Grind", "Finished."
                )
            ),
            "Boneless", Map(
                "Roast", Map(
                    "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                ),
                "Chop", Map(
                    "Thickness", ["1.5in", "1in", "1.25in", "1.75in", "0.75in"],
                    "No./Pack", ["2", "3", "4", "1"]
                ),
                "Fishloin", Map(
                    "Pull", "Finished.",
                    "Grind", "Finished."
                )
            ),
            "Canadian bacon", Map(
                "Celery", "Celery",
                "Nitrite", "Nitrite",
                "Fishloin", Map(
                    "Pull", "Finished.",
                    "Grind", "Finished."
                )
            ),
            "Grind", "Finished."
        )

        side := Map(
            "Belly", Map(
                "Fresh", Map(
                    "Slab", "Finished.",
                    "Slice", "Finished."
                ),
                "Smoked", Map(
                    "Celery", "Celery",
                    "Nitrite", "Nitrite",
                    "Slab", "Finished.",
                    "Sliced", "Finished."
                )
            ),
            "Ribs", Map(
                "Split length", "Finished.",
                "Full", "Finished."
            )
        )

        hindQuarter := Map(
            "Hams", Map(
                "Bone in", Map(
                    "Whole", "Finished.",
                    "Roasts", Map(
                        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                    ),
                    "Steaks", Map(
                        "Thickness", ["1.5in", "1in", "1.25in", "1.75in", "0.75in"]
                    )
                ),
                "Boneless", Map(
                    "Whole", "Finished.",
                    "Roasts", Map(
                        "Weight", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"]
                    )
                ),
                "Smoked", Map(
                    "Celery", "Celery",
                    "Nitrite", "Nitrite",
                    "Whole", "Finished.",
                    "Halved", "Finished.",
                    "Quartered", "Finished."
                ),
                "Kebob", Map(
                    "LB/Pack", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"] ; Specific quantity/pack details would be needed
                ),
                "Stew meat", Map(
                    "LB/Pack", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"] ; Specific quantity/pack details would be needed
                ),
                "Fajita", Map(
                    "LB/Pack", ["2-3 lbs", "3-4 lbs", "4-5 lbs", "1-2 lbs"] ; Specific quantity/pack details would be needed
                ),
                "Grind", "Finished."
            ),
            "Sweetheart Hams", Map(
                "Smoked", Map(
                    "Celery", "Celery",
                    "Nitrite", "Nitrite"
                ),
                "Grind", "Finished."
            ),
            "Hocks", Map(
                "Fresh", "Finished.",
                "Smoked", Map(
                    "Celery", "Celery",
                    "Nitrite", "Nitrite"
                ),
                "Grind", "Finished."
            )
        )

        sausage := "Finished." ; Specific options would be needed if sausage has variations
        PorkMap := Map()
        PorkMap["Shoulder"] := shoulder
        PorkMap["Loin"] := loin
        PorkMap["Side"] := side
        PorkMap["HindQuarter"] := hindQuarter
        PorkMap["Sausage"] := sausage
        return PorkMap
    }
}

;#Include <cJson>
;FileOpen("pork.json", "w").Write(Json.Dump(PorkMap))