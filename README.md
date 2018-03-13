# MendelProb Manual

`mendelprob` is an R package to determine the probability of observing variants within a gene in multiple families/cases and to establish how many families/cases need to be screened to detect multiple observations of potentially pathogenic variants within a gene. 

## Installation

```R
install.packages("devtools")
```

In case you are asked to select a CRAN mirror, choose a mirror near your current location.  

```R
library("devtools")
install_github('mendelprob','statgenetics')
library("mendelprob")
```

## Probability Calculation

`mendel_prob` function can be used to determine the probability of detecting a minimum number of probands with pathogenic variants in the same gene or the probability of detecting genes with pathogenic variants in different data types, for example, identifying a variant with at least one proband being a member of a family which can establish linkage.

Examples:

```R
mendel_prob(num_probands=625, 
            gene_freq=0.005,
            min_num_variants=2)

mendel_prob(num_probands=125, 
            num_probands_type_2=500, 
            gene_freq=0.005,
            min_num_variants=2, 
            min_num_probands_variants=1)
```

Where

+ `num_probands` is the number of probands
+ `num_probands_type_2` is the number of unrelated cases in the total probands
+ `gene_freq` is the proportion of affected individuals explained by one gene
+ `min_num_variants` is the minimum number of probands with pathogenic variant(s) in the same gene 
+ `min_num_probands_variants` is the minimum number of proband being a member of a family with pathogenic variant(s) in the same gene (note: `min_num_probands_variants`  cannot be bigger than  `min_num_variants`)

## Sample Size Calculation

`mendel_sample_size` can be used to determine the number of samples (families + cases) which need to be screened to detect a minimum number of observations of potentially pathogenic variants within the same gene. 

Examples:

```R
mendel_sample_size(prob=0.8, 
                   gene_freq=0.1,
                   min_num_variants=2)

mendel_sample_size(prob=0.8, 
                   proband_prop=0.5,
                   gene_freq=0.005,
                   min_num_variants=3, 
                   min_num_probands_variants=1) 
```

Where

- `prob` is the probability
- `proband_prop` is the proportion of proband being a member of a family
- `gene_freq` is the proportion of affected individuals explained by one gene
- `min_num_variants` is the minimum number of probands with pathogenic variant(s) in the same gene 
- `min_num_probands_variants` is the minimum number of proband being a member of a family with pathogenic variant(s) in the same gene (note: `min_num_probands_variants`  cannot be bigger than  `min_num_variants`)

## Reference & Contact

+ Please refer `?mendel_prob` or `?mendel_sample_size` in R console for detailed function description. 
+ For comments and bug reports, feel free to [create a issue](https://github.com/statgenetics/mendelprob/issues) on Github.
+ If you found the tool is usful, please cite XXX . 
+ For any questions and suggestions, feel free to contact
  + Suzanne Leal, sleal@bcm.edu
  + Zongxiao He, hezongxiao@gmail.com





