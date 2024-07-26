from peewee import PostgresqlDatabase

def db():
    return PostgresqlDatabase(database='wexlqizj', user='wexlqizj', password='6RrqsNEMPMAwnnNZ1lFRxLgsh0BJp5nA', host='baasu.db.elephantsql.com', port=5432)

def db_cfg():
    return {
    'database': 'wexlqizj',
    'user': 'wexlqizj',
    'password': '6RrqsNEMPMAwnnNZ1lFRxLgsh0BJp5nA',
    'host': 'baasu.db.elephantsql.com',
    'port': '5432'
    # Add any other keyword arguments here
}
