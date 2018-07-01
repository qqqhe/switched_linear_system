# AMPL model for optimal switching sequence problem with multiple matrices

param n; # dimension of the system
param K; # total number of periods
param m; # number of matrices

set ROWS := 1 .. n; # set of components of the states
set COLS  := 1 .. n; # set of components of the states
set MATRICES := 1 .. m; # set of matrices

set PERIODS ordered := 0 .. K; # set of time periods

param A {MATRICES, ROWS, COLS}; # matrices

param a {ROWS}; # initial vector

var x{PERIODS, ROWS};
var z{k in PERIODS, l in MATRICES : ord(k) > 1} binary; # Binary variables are defined for periods 1 to K, excluding period 0.

maximize l2norm_squared: sum{i in ROWS} x[K, i]*x[K, i];

subject to dynamics{i in ROWS, k in PERIODS: ord(k) > 1}: x[k, i] = sum{l in MATRICES, j in COLS}A[l,i,j]*x[prev(k),j]*z[k,l];

subject to cardinality {k in PERIODS: ord(k) > 1}: sum{l in MATRICES} z[k,l] = 1;

subject to init_condition {i in ROWS}: x[0,i] = a[i];

#option solver baron;
#option baron_options 'threads=1';
#option baron_options 'maxtime=60'
