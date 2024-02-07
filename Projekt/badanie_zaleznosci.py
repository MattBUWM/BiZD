import cx_Oracle as cx
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from scipy.stats import pearsonr

if __name__ == '__main__':
    filename = 'file.csv'
    procedure_name = 'dodaj_gracza'
    with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
        with connection.cursor() as cursor:
            cursor.execute('SELECT plec, elo FROM gracz WHERE elo > 0')
            data = pd.DataFrame(data=cursor.fetchall(), columns=['plec', 'elo'])
            print(data)
        plt.figure(figsize=(8, 6))
        sns.boxplot(x='plec', y='elo', data=data)
        plt.title('Chess Elo vs. Gender')
        plt.xlabel('Gender')
        plt.ylabel('Elo Rating')
        plt.show()
        mapped_gender = data['plec'].map({'M': 1, 'K': 0})
        correlation_coefficient, p_value = pearsonr(data['elo'], mapped_gender)
        print(f'Correlation Coefficient: {correlation_coefficient}')
        print(f'P-value: {p_value}')