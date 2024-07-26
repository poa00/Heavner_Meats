from abc import ABC, abstractmethod

# Define an interface using an abstract base class
class IVehicle(ABC):
    
    @abstractmethod
    def start_engine(self):
        pass
        
    @abstractmethod
    def stop_engine(self):
        pass
        
    @abstractmethod
    def wheels(self):
        pass

# Implement the IVehicle interface in a Car class
class Car(IVehicle):
    def start_engine(self):
        print("Car engine started.")
        
    def stop_engine(self):
        print("Car engine stopped.")
        
    def wheels(self):
        return 4

# Implement the IVehicle interface in a Motorcycle class
class Motorcycle(IVehicle):
    def start_engine(self):
        print("Motorcycle engine started.")
        
    def stop_engine(self):
        print("Motorcycle engine stopped.")
        
    def wheels(self):
        return 2

def vehicle_info(vehicle: IVehicle):
    vehicle.start_engine()
    print(f"Vehicle has {vehicle.wheels()} wheels.")
    vehicle.stop_engine()

if __name__ == "__main__":
    my_car = Car()
    vehicle_info(my_car)
    
    my_motorcycle = Motorcycle()
    vehicle_info(my_motorcycle)
    
    """
    car has wheels, doors, frames
    
    iwheel
    
    if want to know 
    methods 
    
    wheels.howmany()
    rims.howmany()
    
    cars.howmany()
    
    
    """