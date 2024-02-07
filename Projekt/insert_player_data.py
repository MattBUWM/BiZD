import cx_Oracle as cx
import numpy
import pandas as pd
import numpy as np

if __name__ == '__main__':
    filename = 'top_chess_players_aug_2020.csv'
    procedure_name = 'dodaj_gracza'
    data = pd.read_csv(filename)
    print(data)
    data = data.drop(columns=['Fide id','Rapid_rating','Blitz_rating','Inactive_flag','Title','Year_of_birth'])
    data = data.dropna()
    data = data.sample(frac=1)
    print(data)
    data_chunks = np.array_split(data, 1000)
    print(data_chunks[0])
    skipped = 0
    with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
        with connection.cursor() as cursor:
            count = 1
            for chunk in data_chunks:
                for _, line in chunk.iterrows():
                    names = line['Name'].split(', ')
                    if len(names) != 2:
                        skipped += 1
                        continue
                    gender = 'M' if line['Gender'] == 'M' else 'K'
                    parameters = [names[1], names[0], line['Federation'], gender, line['Standard_Rating']]
                    cursor.callproc(procedure_name, parameters)
                connection.commit()
                print(f'chunk {count} completed')
                count += 1
    print(f'skipped {skipped}')

