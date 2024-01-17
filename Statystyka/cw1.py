import statistics

import numpy as np
import pandas as pd
import scipy.stats as scs
import matplotlib.pyplot as plt
from pandas import plotting


def zadanie1():
    data = pd.read_csv('MDR_RR_TB_burden_estimates_2024-01-16.csv')
    selected_data = np.array(data['e_rr_pct_ret_lo'])
    print(f'e_rr_pct_ret_lo minimum: {selected_data.min()}')
    print(f'e_rr_pct_ret_lo maksimum: {selected_data.max()}')
    print(f'e_rr_pct_ret_lo średnia: {selected_data.mean()}')
    print(f'e_rr_pct_ret_lo odchylenie standardowe: {selected_data.std()}')
    print(f'e_rr_pct_ret_lo mediana: {np.median(selected_data)}')
    print(f'e_rr_pct_ret_lo wariancja: {np.var(selected_data)}')


def zadanie2():
    data = np.loadtxt('Wzrost.csv', delimiter=',')
    print(f'Wzrost średnia: {statistics.mean(data)}')
    print(f'Wzrost mediana: {statistics.median(data)}')
    print(f'Wzrost dominanta: {statistics.mode(data)}')
    print(f'Wzrost wariancja: {statistics.variance(data)}')
    print(f'Wzrost odchylenie standardowe: {statistics.stdev(data)}')


def zadanie3():
    data = np.loadtxt('Wzrost.csv', delimiter=',')
    print(scs.describe(data))
    print(f'Wzrost tstd: {scs.tstd(data)}')
    print(f'Wzrost dominanta: {scs.mode(data)}')


def zadanie4():
    data = pd.read_csv('brain_size.csv', delimiter=';')
    print(data)
    print(f"Brain size VIQ średnia: {data['VIQ'].mean()}")
    data_grouped = data.groupby('Gender')
    for gender, value in data_grouped['Gender']:
        print(gender, value.count())
    #plotting.scatter_matrix(data[['VIQ', 'PIQ', 'FSIQ']])
    plotting.hist_frame(data[['VIQ', 'PIQ', 'FSIQ']])
    plt.show()

    for gender, value in data_grouped[['VIQ', 'PIQ', 'FSIQ']]:
        if gender == 'Female':
            plotting.hist_frame(value[['VIQ', 'PIQ', 'FSIQ']])
            plt.show()




if __name__ == '__main__':
    # zadanie1()
    # zadanie2()
    # zadanie3()
    zadanie4()
