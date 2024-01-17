import scipy.stats as sps
import matplotlib.pyplot as plt
import numpy as np

if __name__ == '__main__':
    p = 1/6
    bernoulli = sps.bernoulli.rvs(p, size=100)
    print('Bernoulli')
    print(f'mean: {np.mean(bernoulli)}, var: {np.var(bernoulli)}, skew: {sps.skew(bernoulli)}, kurt: {sps.kurtosis(bernoulli)}')

    dwumian = sps.binom.rvs(10, p, size=100)
    print('Dwumianowe')
    print(f'mean: {np.mean(dwumian)}, var: {np.var(dwumian)}, skew: {sps.skew(dwumian)}, kurt: {sps.kurtosis(dwumian)}')

    poisson = sps.poisson.rvs(p, size=100)
    print('Poisson')
    print(f'mean: {np.mean(poisson)}, var: {np.var(poisson)}, skew: {sps.skew(poisson)}, kurt: {sps.kurtosis(poisson)}')

    fig, ax = plt.subplots(1, 3)
    ax[0].hist(bernoulli)
    ax[1].hist(dwumian)
    ax[2].hist(poisson)
    plt.show()

    dwumian2 = sps.binom.pmf(np.arange(0, 21), n=20, p=p)
    print(np.sum(dwumian2))

    norm = sps.norm.rvs(loc=0, scale=2, size=100)
    print('Normal distribution')
    print(f'mean: {np.mean(norm)}, var: {np.var(norm)}, skew: {sps.skew(norm)}, kurt: {sps.kurtosis(norm)}')

    norm2 = sps.norm.rvs(loc=0, scale=2, size=1000)
    print('Normal distribution')
    print(f'mean: {np.mean(norm2)}, var: {np.var(norm2)}, skew: {sps.skew(norm2)}, kurt: {sps.kurtosis(norm2)}')

    fig, ax = plt.subplots(1, 1)
    x = np.linspace(-4, 4, 100)
    norm3 = sps.norm.rvs(loc=1, scale=2, size=100)
    ax.hist(norm3, density=True, histtype='bar', alpha=0.3)

    norm4 = sps.norm(loc=-1, scale=0.5)
    ax.plot(x, norm4.pdf(x), 'k-', lw=3)
    plt.show()