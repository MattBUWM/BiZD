import cx_Oracle as cx
import matplotlib.pyplot as plt
import pandas as pd

cutout = 100
with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        cur = cursor.callfunc('srednie_elo_narodowosci', cx.CURSOR, [])
        countries_data = pd.DataFrame(data=cur.fetchall(), columns=['country', 'count', 'avg', 'median', 'std_dev'])
        print(countries_data)
        plt.figure(figsize=(40, 8.5))
        plt.bar(countries_data.index-0.3, countries_data['count'], width=0.2)
        plt.bar(countries_data.index-0.1, countries_data['avg'], width=0.2)
        plt.bar(countries_data.index+0.1, countries_data['median'], width=0.2)
        plt.bar(countries_data.index+0.3, countries_data['std_dev'], width=0.2)
        plt.title('Statystyki ELO według narodowości')
        plt.xticks(list(range(len(countries_data))), countries_data['country'])
        plt.tick_params(axis='x', labelrotation=90)
        plt.legend(['ilość graczy', 'srednia ELO', 'mediana ELO', 'odchylenie standardowe ELO'])
        plt.show()