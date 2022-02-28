/* RIFERIMENTO: https://www.epicentro.iss.it/coronavirus/sars-cov-2-decessi-italia*/
/* RIF2: https://covid19.infn.it/iss/ */

const N = 6; /* number of age groups */

param A = 1000; /* population dimension */
/* number of new synthomatic cases generate, in average,
by a single case during its infective time,
in an entirely susceptible population at the start of an epidemic
or in contexts in which no measures have been taken to limit the infection.*/
param r0 = 2.28;

/* percentages of individuals for each age group */
const probIU50meet = 0.5445;
const probIO50U60meet = 0.1578;
const probIO60U70meet = 0.1235;
const probIO70U80meet = 0.10;
const probIO80U90meet = 0.061;
const probIO90meet = 0.0133;

/* infection incidence for each age group */
const positives0 = 0.0795;
const positives1 = 0.0823;
const positives2 = 0.0661;
const positives3 = 0.0596;
const positives4 = 0.0746;
const positives5 = 0.1218;

/* initial number of infected */
const n_I0_init = A*probIU50meet*positives0;
const n_I1_init = A*probIO50U60meet*positives1;
const n_I2_init = A*probIO60U70meet*positives2;
const n_I3_init = A*probIO70U80meet*positives3;
const n_I4_init = A*probIO80U90meet*positives4;
const n_I5_init = A*probIO90meet*positives5;

/* initial number of susceptible */
const n_S0_init = (A*probIU50meet)-n_I0_init;
const n_S1_init = (A*probIO50U60meet)-n_I1_init;
const n_S2_init = (A*probIO60U70meet)-n_I2_init;
const n_S3_init = (A*probIO70U80meet)-n_I3_init;
const n_S4_init = (A*probIO80U90meet)-n_I4_init;
const n_S5_init = (A*probIO90meet)-n_I5_init;

/* lethalities associated to each age group */
const lethality0 = 0.0006;
const lethality1 = 0.0061;
const lethality2 = 0.0277;
const lethality3 = 0.0929;
const lethality4 = 0.1996;
const lethality5 = 0.2801;

const avg_death_time = 13; /* days */

species S of [0, N]; /* susceptibles per age group 0=0-49, 1=50-59, 2=60-69, 3=70-79, 4=80-89, 5=90+ */
species I of [0, N]; /* infected per age group 0=0-49, 1=50-59, 2=60-69, 3=70-79, 4=80-89, 5=90+ */
species R of [0, N]; /* recovered per age group */
species D of [0, N]; /* dead per age group */
species I_COUNTER;   /* a specie to keep track of the total infections */

label susceptibles = {S[i for i in [0, N]]}
label infected = {I[i for i in [0, N]]}
label dead = {D[i for i in [0, N]]}
label recovered = {R[i for i in [0, N]]}
label alive = {S[i for i in [0, N]], I[i for i in [0, N]], R[i for i in [0, N]]}


/* Susceptibles to infected rule */

rule s_to_i for i in [0, N] and k in [0, N] {
    S[i]|I[k] -[ r0 * #I[k] / #alive ]-> I[i]|I[k]|I_COUNTER
}

/* Infected to dead rules */

rule i_to_d_U50 {
    I[0] -[ lethality0 ]-> D[0]
}

rule i_to_d_O50U60 {
    I[1] -[ lethality1 ]-> D[1]
}

rule i_to_d_O60U70 {
    I[2] -[ lethality2 ]-> D[2]
}

rule i_to_d_O70U80 {
    I[3] -[ lethality3 ]-> D[3]
}

rule i_to_d_O80U90 {
    I[4] -[ lethality4 ]-> D[4]
}

rule i_to_d_O90 {
    I[5] -[ lethality5 ]-> D[5]
}

/* Infected to recovered rule */

rule i_to_r for i in [0, N] {
    I[i] -[ 1/avg_death_time ]-> R[i]
}

measure n_infected = #infected;

measure n_dead = #dead;

measure n_susceptible = #susceptibles;

measure n_recovered = #recovered;

system corona = S[0]<n_S0_init>|S[1]<n_S1_init>|S[2]<n_S2_init>|S[3]<n_S3_init>|S[4]<n_S4_init>|S[5]<n_S5_init>|I[0]<n_I0_init>|I[1]<n_I1_init>|I[2]<n_I2_init>|I[3]<n_I3_init>|I[4]<n_I4_init>|I[5]<n_I5_init>;
