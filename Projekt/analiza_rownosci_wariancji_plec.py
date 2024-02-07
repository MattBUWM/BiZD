import scipy.stats as sps
import cx_Oracle as cx


with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        cur = cursor.execute('SELECT elo FROM gracze_kobiety')
        elo_kobiety = []
        while True:
            row = cur.fetchone()
            if row is None:
                break
            if row[0] == 0 or row[0] is None:
                continue
            elo_kobiety.append(row[0])
        cur = cursor.execute('SELECT elo FROM gracze_mezczyzni')
        elo_mezczyzni = []
        while True:
            row = cur.fetchone()
            if row is None:
                break
            if row[0] == 0 or row[0] is None:
                continue
            elo_mezczyzni.append(row[0])
        test = sps.levene(elo_kobiety, elo_mezczyzni, center='mean')
        print('mean')
        print(test)
        test = sps.levene(elo_kobiety, elo_mezczyzni, center='median')
        print('median')
        print(test)
        test = sps.levene(elo_kobiety, elo_mezczyzni, center='trimmed')
        print('trimmed')
        print(test)

