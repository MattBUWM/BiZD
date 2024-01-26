import cx_Oracle as cx


with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        ref = cursor.callfunc('gracze_danej_narodowosci', cx.CURSOR, ['USA'])
        query_result = ref.fetchall()
        print(query_result)
