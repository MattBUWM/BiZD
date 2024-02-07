import cx_Oracle as cx
import matplotlib.pyplot as plt


with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        cur = cursor.execute('SELECT elo FROM gracz')
        elo_ranges = {}
        while True:
            row = cur.fetchone()
            if row is None:
                break
            if row[0] == 0 or row[0] is None:
                continue
            div_elo = row[0] // 50
            if div_elo/2 in elo_ranges.keys():
                elo_ranges[div_elo/2] = elo_ranges[div_elo/2] + 1
            else:
                elo_ranges[div_elo/2] = 1
        print(elo_ranges)
        plt.bar(elo_ranges.keys(), elo_ranges.values(), width=0.4)
        plt.title('Rozkład ELO')
        plt.xlabel('Grupy ELO (XX00)')
        plt.show()
