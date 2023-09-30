# detect where index and template folder is 

from pathlib import Path

def find_temp_static():
    one = Path.cwd() / 'templates'
    two = Path(__file__).parent.parent / 'templates'
    three = Path(__file__).parent / 'templates'
    four = Path(__file__).parent.parent.parent / 'templates'
    if one.exists() and one.is_dir():
        return one, one.parent / 'static'
    elif two.exists() and two.is_dir():
        return two, two.parent / 'static'
    elif three.exists() and three.is_dir():
        return three, three.parent / 'static'
    elif four.exists() and four.is_dir():
        return four, four.parent / 'static'
    
    
if __name__ == '__main__':
    print(str(find_temp_static()))