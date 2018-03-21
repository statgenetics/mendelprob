# MendelProb Manual

`MendelProb` is an Rpackage to determine the probability of observing a minimum number ofpotentially pathogenic variants within a gene in multiple families and/or casesand to also establish how many probands need to be screened to detect multipleobservations of potentially pathogenic variants within a gene. 

 

`MendelProb` canbe used for the design of Mendelian disease sequencing studies (candidate gene,exome and whole genome) and grant proposals. For genetic studies, it is necessary toperform power calculations. Although for Mendelian diseases the power ofdetecting linkage for pedigree(s) can be determined, it is also of greatinterest to determine the probability of identifying multiple pedigrees orunrelated cases with potentially pathogenic variants in the same gene or estimatethe number of probands which need to be screened to detect potentiallypathogenic variants. For many Mendelian diseases, due to extreme locusheterogeneity this probability can be small or the number of probands whichneed to be screened very large. If onlyone family is observed segregating a variant classified as potentiallypathogenic or of unknown significance, the gene cannot be implicated in diseaseetiology. The probability ofidentifying additional Mendelian disease families or cases is dependent on the prevalenceof the disease due to a specific gene and the sample size to be screened.The observation of additional disease families or cases with potentially pathogenic variants in thesame gene as well as evidence of pathogenicity from other sources, e.g.,expression and functional studies, can aid in implicating a gene in diseaseetiology. 

## Installation

```R
install.packages("devtools")
```

If you are asked to select a CRAN mirror, choose a mirror site near your current location.

```R
library("devtools")
install_github('mendelprob','statgenetics')
library("mendelprob")
```

## Probability Calculations

The `mendel_prob` function can be used to determine the probability of detecting a minimum number of probands with potentially pathogenic variants in the same gene. It can also be used to determine the probability of detecting a minimum number of potentially pathogenic variants within a gene for different data types where it is required that a minimum number of potentially pathogenic variants are observed for one data type e.g., identifying at least three potentially pathogenic variants within a gene where at least one of the variants is observed in a proband who is a member of a family which can establish linkage.

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

- `num_probands`

- - is the total number of probands or if probands are being drawn for two types of data, e.g. families and unrelated cases, this is the number of probands of type I 

- `num_probands_type_2`

- - the number of probands of type 2

- `gene_freq` 

- - the percent of disease explained by a gene

- `min_num_variants` 

- - the minimum number of probands with potentially pathogenic variants in the same gene which need to be observed in the total sample. 

- `min_num_probands_variants` 

- - the minimum number of probands of the first type (in this example 125) which are required to be observed with potentially pathogenic variants in the same gene 

- note:  `min_num_probands_variants` cannot be greater than `min_num_variants`

## Sample Size Calculations

The `mendel_sample_size` functio can be used to determine the number of probands which need to be screened to detect a minimum number of potentially pathogenic variants within the same gene for a specified probability. It can also be used to determine the number of probands which need to be screened if it desired that a minimum number of probands of a certain type are observed with potentially pathogenic variants. For this situation, the proportion of probands of each type which are planned to be sequenced is provided, e.g., one-third of the probands will be from Mendelian families with multiple affected members and two-thirds of the probands are individual cases without additional affected family members.

Examples:

```R
mendel_sample_size(prob=0.8, 
                   gene_freq=0.01,
                   min_num_variants=2)

mendel_sample_size(prob=0.8, 
                   proband_prop=0.3,
                   gene_freq=0.005,
                   min_num_variants=3, 
                   min_num_probands_variants=1) 
```

Where

- `prob`

- - the probability of detecting the desired minimum number of potentially pathogenic variants

- `proband_prop` 

- - the proportion of probands of type I

- `gene_freq` 

- - the percent of disease explained by a gene

- `min_num_variants` 

- - the minimum number of probands with potentially pathogenic variants in the same gene which need to be observed for the entire sample. 

- `min_num_probands_variants` 

- - the minimum number of potentially pathogenic variants which need to be observed in probands of type I (in this example 0.30). 

- note: `min_num_probands_variants` cannot be greater than `min_num_variants`

## Reference & Contact **Information**

+ Please refer to `?mendel_prob` or `?mendel_sample_size` in R console for detailed function descriptions. 
+ For comments and bug reports, feel free to [create an issue](https://github.com/statgenetics/mendelprob/issues) on Github.
+ If you found the tool is useful, please cite XXX . 
+ For any questions and suggestions, feel free to contact
  + Suzanne Leal, suzannemleal@gmail.com\
  + Zongxiao He, hezongxiao@gmail.com





