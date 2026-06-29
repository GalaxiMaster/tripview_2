from add_type_column import add_type_column
from remove_mode import remove_mode
from merge_dbs import merge_dbs
from csv_to_db import csv_to_db
from verify_db import verify_and_fts

def main():
    # remove_mode(path='assets/old/raw/')
    # input()
    # csv_to_db(path='assets/old/raw/') # need to fix: outputs -cleaned versions
    # input()
    add_type_column(path='assets/old/raw/')
    input()
    merge_dbs(path='assets/old/raw/')
    input()
    verify_and_fts()
    
if __name__ == "__main__":
    main()