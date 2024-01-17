import scipy.stats as sps
import pandas as pd

if __name__ == '__main__':
    norm = sps.norm.rvs(loc=2, scale=30, size=200)
    print('Rozkład normalny')
    print(sps.ttest_1samp(norm, 2.5))

    data = pd.read_csv('napoje.csv', delimiter=';')
    print('Lech')
    print(sps.ttest_1samp(data['lech'], 60500))
    print('Cola')
    print(sps.ttest_1samp(data['cola'], 222000))
    print('Regionalne')
    print(sps.ttest_1samp(data['regionalne'], 43500))

    print('badanie normalności')
    for x in data:
        print(f"badanie normalności kolumny {x}: {sps.normaltest(data[x])}")

    print('badanie równości średnich')
    print('okocim - lech')
    print(sps.ttest_ind(data['okocim'], data['lech']))
    print('fanta - regionalne')
    print(sps.ttest_ind(data['fanta '], data['regionalne']))
    print('cola - pepsi')
    print(sps.ttest_ind(data['cola'], data['pepsi']))

    print('badanie równości wariancji')
    print('okocim - lech')
    print(sps.levene(data['okocim'], data['lech']))
    print('żywiec - fanta')
    print(sps.levene(data['żywiec'], data['fanta ']))
    print('regionalne - cola')
    print(sps.levene(data['regionalne'], data['cola']))

    print('badanie równości średnich między latami')
    print('regionalne:2001 - 2015')
    print(sps.ttest_ind(data[data['rok'] == 2001]['regionalne'], data[data['rok'] == 2015]['regionalne']))

    data2 = pd.read_csv('napoje_po_reklamie.csv', delimiter=';')
    data_2016 = data[data['rok'] == 2016]
    print('badanie równości średnich (z założeniem zależności zmiennych)')
    print('cola: 2016 - po reklamie')
    print(sps.ttest_rel(data_2016['cola'], data2['cola']))
    print('fanta: 2016 - po reklamie')
    print(sps.ttest_rel(data_2016['fanta '], data2['fanta ']))
    print('pepsi: 2016 - po reklamie')
    print(sps.ttest_rel(data_2016['pepsi'], data2['pepsi']))
