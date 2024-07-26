# detect where index and template folder is 

from pathlib import Path

def find_temp_static():
    """
    return `temp, static = Path.cwd() / 'templates', Path.cwd() / 'static'`
    """
    one = Path.cwd() / 'templates'
    two = Path(__file__).parent.parent / 'templates'
    three = Path(__file__).parent / 'templates'
    four = Path(__file__).parent.parent.parent / 'templates'
    if one.exists() and one.is_dir():
        return Path(one).resolve(), Path(one.parent / 'static').resolve()
    elif two.exists() and two.is_dir():
        return Path(two).resolve(), Path(two.parent / 'static').resolve()
    elif three.exists() and three.is_dir():
        return Path(three).resolve(), Path(three.parent / 'static').resolve()
    elif four.exists() and four.is_dir():
        return Path(four).resolve(), Path(four.parent / 'static').resolve()
    
    
if __name__ == '__main__':
    print(str(find_temp_static()))