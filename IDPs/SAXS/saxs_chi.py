import numpy as np
import sys
from sklearn.linear_model import LinearRegression

# Load calculated SAXS data and extract intensities
calc_saxs = np.loadtxt(sys.argv[1])
calc_saxs = calc_saxs[...,1]

# Load original SAXS data and fit the calculated SAXS data
exp_saxs = np.loadtxt(sys.argv[2])
exp_i = exp_saxs[...,1]
exp_err = exp_saxs[...,2]
wlr = 1/(exp_err**2)

model = LinearRegression()
model.fit(calc_saxs.reshape(-1,1),exp_i,wlr)
alpha = model.coef_[0]
beta = model.intercept_

calc_saxs = alpha*calc_saxs+beta

# Calculate chi^2
N = len(calc_saxs)
chi2 = ((exp_i - calc_saxs)**2 / exp_err**2).sum()
chi2red = chi2/N

np.savetxt(sys.argv[4], calc_saxs ,header='chi2r '+str(chi2red))


# Load calculated SAXS data and extract intensities (again)
calc_saxs = np.loadtxt(sys.argv[1])
calc_saxs = calc_saxs[...,1]

# Load BIFT reweighted SAXS data and fit the calculated SAXS data
exp_saxs = np.loadtxt(sys.argv[3])
exp_i = exp_saxs[...,1]
exp_err = exp_saxs[...,2]
wlr = 1/(exp_err**2)

model = LinearRegression()
model.fit(calc_saxs.reshape(-1,1),exp_i,wlr)
alpha = model.coef_[0]
beta = model.intercept_

calc_saxs = alpha*calc_saxs+beta

# Calculated chi^2
N = len(calc_saxs)
chi2 = ((exp_i - calc_saxs)**2 / exp_err**2).sum()
chi2red = chi2/N

np.savetxt(f'bift_{sys.argv[4]}', calc_saxs ,header='chi2r '+str(chi2red))
