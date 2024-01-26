import cx_Oracle as cx
import pandas as pd

if __name__ == '__main__':
    filename = 'file.csv'
    procedure_name = 'dodaj_gracza'
    data = pd.read_csv(filename, header=None)
    print(data)
    with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
        with connection.cursor() as cursor:
            for _, line in data.iterrows():
                print(line)
                parameters = [line[0], line[1], line[3], line[2]]
                cursor.callproc(procedure_name, parameters)
            connection.commit()
