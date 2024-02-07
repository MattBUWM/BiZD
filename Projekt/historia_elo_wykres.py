import datetime

import cx_Oracle as cx
import matplotlib.pyplot as plt
import numpy as np
from sklearn.linear_model import LinearRegression
from sklearn.linear_model import SGDRegressor
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.ensemble import GradientBoostingRegressor

with cx.connect(user='barskid', password='dawid', dsn='213.184.8.44:1521/orcl', encoding="UTF-8") as connection:
    with connection.cursor() as cursor:
        cur = cursor.callfunc('hist_elo_gracza', cx.CURSOR, [90])
        data = []
        points_count = 0
        while True:
            row = cur.fetchone()
            if row is None:
                break
            data.append(row)
            points_count += 1
        numpy_data = np.array(data).T
        lin_reg = LinearRegression().fit(np.array([x.toordinal() for x in numpy_data[2]]).reshape(-1, 1), numpy_data[1])
        sgd_reg = make_pipeline(StandardScaler(), SGDRegressor(max_iter=100, tol=1e-3))
        sgd_reg.fit(np.array([x.toordinal() for x in numpy_data[2]]).reshape(-1, 1), numpy_data[1])
        gbr_reg = make_pipeline(StandardScaler(), GradientBoostingRegressor())
        gbr_reg.fit(np.array([x.toordinal() for x in numpy_data[2]]).reshape(-1, 1), numpy_data[1])
        points_for_predictions = np.array([x.toordinal() for x in numpy_data[2]]).reshape(-1, 1)
        dates_for_prediction = []
        for x in range(30):
            points_for_predictions = np.append(points_for_predictions, [731382+x+1])
        points_for_predictions = points_for_predictions.reshape(-1, 1)
        for x in points_for_predictions:
            dates_for_prediction.append(datetime.date.fromordinal(x[0]))
        lin_prediction = lin_reg.predict(points_for_predictions)
        sgd_prediction = sgd_reg.predict(points_for_predictions)
        gbr_prediction = gbr_reg.predict(points_for_predictions)
        plt.figure(figsize=(10, 8.5))
        plt.plot(dates_for_prediction[:points_count], numpy_data[1], label='ELO', linewidth=5)
        plt.plot(dates_for_prediction, lin_prediction, label='Regresja liniowa')
        plt.plot(dates_for_prediction, sgd_prediction, label='Regresja SGD')
        plt.plot(dates_for_prediction, gbr_prediction, label='Regresja GBR')
        plt.legend()
        plt.title('Historia ELO gracza', size=20)
        plt.tick_params(axis='x', labelrotation=90)
        plt.show()