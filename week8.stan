data {
  int<lower=1> N; // observations
  int<lower=1> J; // counties
  int<lower=1, upper=J> county[N]; // the county for house i 
  vector[N] y; // log(activity)
  vector[N] x; // floor
  vector[J] u; // log(Uppm)
}
parameters {
  real gamma0;
  real gamma1;
  real<lower=0> sigma_alpha;
  vector[J] alpha;
  real beta;  
  real<lower=0> sigma_y;
}
model {
  vector[N] y_hat;
  vector[J] alpha_hat;
  for (i in 1:N) 
    y_hat[i] = alpha[county[i]] + x[i] * beta;
    
  for (j in 1:J) 
    alpha_hat[j] = gamma0 + gamma1*u[j];
  
  // priors
  alpha ~ normal(alpha_hat, sigma_alpha);
  beta ~ normal(0,1);
  sigma_y ~ normal(0,1);
  sigma_alpha ~ normal(0,1);
  
  y ~ normal(y_hat, sigma_y);
}
generated quantities {
  // posterior predictive distribution for a new household
  // specifically with county 2 and basement level measurement ==> x = 0
  real y_new_county2 = normal_rng(alpha[2] + beta * 0.0, sigma_y);
}