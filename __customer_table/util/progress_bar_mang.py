from progress.bar import Bar
from time import sleep

class ProgressBarManager:
    """    
    ::
    
    manager = ProgressBarManager("Processing", max_value=3)
    ::
    
    manager.start()
    ::
        
    manager.update()
    """
        
    def __init__(self, name, max):
        self.name = name
        self.max_value = max
        self.bar = None

    def start(self):
        self.bar = Bar(self.name, max=self.max_value)

    def next(self):
        if self.bar is None:
            print("\n")
            self.start()
        if self.bar.index + 1 < self.max_value:
            self.bar.next()
        else:
            self.bar.next()
            self.bar.finish()
            print("\n")
            print(f"\n====================\n{self.name} completed!\n====================\n")

def simple_prog_bar():
    pg = ProgressBarManager("Loading, patience please", max=10)
    pg.start()
    for i in range(10):
        sleep(0.5)
        pg.next()


# Example usage:
if __name__ == "__main__":
    manager = ProgressBarManager("Processing", max_value=3)
    manager.start()

    for _ in range(3):
        # Simulate some work
        # You can replace this with your actual work
        import time
        time.sleep(1)
        manager.update()
