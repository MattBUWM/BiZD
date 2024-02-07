import cx_Oracle as cx
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression

cutout = 100
with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        cur = cursor.callfunc('narodowosci_list', cx.CURSOR, [])
        countries = []
        while True:
            row = cur.fetchone()
            if row is None:
                break
            countries.append(row)
        count_countries = {}
        count_countries['Pozostałe'] = 0
        for x in countries:
            print(x[0])
            current_count = 0
            cur = cursor.callfunc('gracze_danej_narodowosci', cx.CURSOR, [x[0]])
            while True:
                row = cur.fetchone()
                if row is None:
                    break
                current_count += 1
            if current_count < cutout:
                count_countries['Pozostałe'] += current_count
            else:
                count_countries[x[0]] = current_count
        plt.figure(figsize=(10, 8.5))
        plt.bar(count_countries.keys(), count_countries.values())
        plt.title('Rozkład graczy według narodowości')
        plt.tick_params(axis='x', labelrotation=90)
        plt.show()