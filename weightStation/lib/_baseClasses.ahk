#Include <cJson>
#Include onscreenKB.ahk

class BaseObjects
{
    static wsGUI =>
    {
        
    }
}





class Animals
{
    /**
     * Represents a collection of animals.
     */
    static storage := Map()
}

class Animal
{
    /**
     * Represents an animal with a specific species.
     * @param {string} species - The species of the animal.
     */
    __New(species)
    {
        /**
         * The species of the animal.
         * @type {string}
         */
        this.species := species

        /**
         * The event ID of the animal.
         * @type {number}
         */
        this.event_id := 0

        /**
         * The TEID of the animal.
         * @type {number}
         */
        this.teid := 0

        /**
         * The organ preferences of the animal.
         * @type {Map}
         */
        this.organs := Map()
        
        /**
         * The weight of the animal.
         * @type {number}
         */
        this.weight := 0
        /**
         * The comment handler object
         * @type {Map}
         */
        /**
         * The comment handler object
         * @type {Map}
         */
        this.comments := ""
    }
    
    /**
     * Selects and returns an instance of a specific animal species.
     * @param {string} str - The species of the animal to select.
     * @returns {Animal} - An instance of the selected animal species.
     */
    static selectSpecies(str)
    {
        if (str = "Cow")
        {
            return Cow()
        }
        else if (str = "Pig")
        {
            return Pig()
        }
        else
        {
            return 
        }
    }
}

class Cow extends Animal
{
    /**
     * Represents a cow, a type of animal.
     */
    __New()
    {
        super.__New("Cow")
        /**
         * The gender of the cow.
         * @type {string} [steer, bull, cow]
         */
        this.gender := ""
        /**
         * The manual weight of the cow.
         * @type {number}
         */
        this.manual_weight := 0
        /**
         * Indicates whether the cow is 30 months old.
         * @type {boolean}
         */
        this.is_over_30_months := false
    }
}

class Pig extends Animal
{
    /**
     * Represents a pig, a type of animal.
     */
    __New()
    {
        super.__New("Pig")
        /**
         * The gender of the pig.
         * @type {string} [steer, bull, cow]
         */
        this.gender := ""
    }
}
