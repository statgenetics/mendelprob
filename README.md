# MendelProb Manual

`mendelprob` is an R package to determine the probability of observing variants within a gene in multiple families/cases and to establish how many families/cases need to be screened to detect multiple observations of potentially pathogenic variants within a gene. 

## Installation

```R
install.packages("devtools")
library("devtools")
install_github('mendelprob','statgenetics')
library("mendelprob")
```

## Probability Calculation

`mendel_prob` function can be used to determine the probability of detecting a minimum number of families or unrelated cases with pathogenic variants in the same gene or the probability of detecting genes with pathogenic variants in different data types, for example, identifying a variant in a minimum of one family which can establish linkage and at least two additional families regardless of size.

Example:

```R
mendel_prob(num_family = 125, 
            num_case = 500, 
            gene_freq = 0.005,
            min_num_total_mutation = 2, 
            min_num_family_mutation = 1)
```

Where

+ `num_family` is the number of families
+ `num_case` is the number of unrelated cases
+ `gene_freq` is the proportion of affected individuals explained by one gene
+ `min_num_total_mutation` is the minimum number of families and cases with pathogenic variant(s) in the same gene 
+ `min_num_family_mutation` is the minimum number of families with pathogenic variant(s) in the same gene 

## Sample Size Calculation

`mendel_sample_size` can be used to determine the number of samples (families + cases) which need to be screened to detect a minimum number of observations of potentially pathogenic variants within the same gene. 

Example:

```R
mendel_sample_size(prob = 0.8, 
                   family_prop = 0.2,
                   gene_freq = 0.005,
                   min_num_total_mutation = 2, 
                   min_num_family_mutation = 1)
```

Where

- `prob` is the probability
- `family_prop` is the proportion of family
- `gene_freq` is the proportion of affected individuals explained by one gene
- `min_num_total_mutation` is the minimum number of families and cases with pathogenic variant(s) in the same gene 
- `min_num_family_mutation` is the minimum number of families with pathogenic variant(s) in the same gene 

## Reference & Contact

+ Please refer `?mendel_prob` or `?mendel_sample_size` in R console for detailed function description. 
+ If you found the tool is usful, please cite XXX . 
+ For any questions, comments, suggestions, bug reports etc, feel free to contact
  + Suzanne Leal, sleal@bcm.edu
  + Zongxiao He, hezongxiao@gmail.com





