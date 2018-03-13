#' mendel_prob
#'
#' Determine the probability of detecting a minimum number of families or unrelated cases with pathogenic variants in the same gene.
#'
#' @param num_probands number of probands
#' @param num_probands_type_2 number of unrelated cases
#' @param gene_freq proportion of affected individuals explained by one gene
#' @param min_num_variants minimum number of probands with pathogenic variant(s) in the same gene
#' @param min_num_probands_variants minimum number of proband being a member of a family with pathogenic variant(s) in the same gene (cannot be bigger than min_num_variants)
#' @return probability
#' @export
#' @examples
#' mendel_prob(125, 500, 0.005, 2, 1)
mendel_prob <- function(num_probands=0, num_probands_type_2=0, gene_freq=0.005,
                        min_num_variants=2, min_num_probands_variants=0) {
  # parameter check
  if (num_probands < 0 || num_probands_type_2 < 0) {
    stop("number of family or proband needs to be >0")
  }
  if (gene_freq <= 0) {
    stop("gene frequency needs to be >0")
  }
  if (min_num_variants < 0 || min_num_probands_variants < 0) {
    stop("minimum number of cases with mutation needs to be >0")
  }
  if (min_num_variants < min_num_probands_variants) {
    stop("minimum number of cases with mutation needs to be greater than or
         equal to minimum number of families with mutation")
  }
  if (min_num_variants > num_probands + num_probands_type_2) {
    stop("minimum number of cases with mutation needs to be less than or
         equal to number of total cases")
  }
  if (min_num_probands_variants > num_probands) {
    stop("minimum number of families with mutation needs to be less than or
         equal to number of families")
  }

  if (min_num_probands_variants == min_num_variants) {
    prob <- (1 - pbinom(min_num_probands_variants - 1, size=num_probands, prob=gene_freq))
  }
  else if (min_num_probands_variants == 0) {
    prob <- (1 - pbinom(min_num_variants - 1, size=num_probands+num_probands_type_2, prob=gene_freq))
  }
  else
  {
    prob <- 0

    for (fam in seq(min_num_probands_variants, min_num_variants - 1)){
      prob <- prob + dbinom(fam, size=num_probands, prob=gene_freq) *
        (1 - pbinom(min_num_variants - fam - 1, size=num_probands_type_2, prob=gene_freq))
    }
    prob <- prob + (1 - pbinom(min_num_variants - 1, size=num_probands, prob=gene_freq))
  }

  return(prob)
}

####### TEST #######
# mendel_prob(125, 500, 0.005, 2, 0) # 0.82
# mendel_prob(125, 500, 0.005, 2, 1) # 0.44
# mendel_prob(125, 500, 0.01, 2, 1) # 0.71

#' mendel_prob_with_family_ratio
#'
#' internal use only.
mendel_prob_with_family_ratio <- function(num_probands_total, proband_prop, gene_freq,
                                        min_num_variants, min_num_probands_variants) {
  if (is.null(proband_prop)) {
    prob <- mendel_prob(0, num_probands_total, gene_freq, min_num_variants, 0)
  }
  else {
    num_probands <- as.integer(round(num_probands_total * proband_prop, 0))
    num_probands_type_2 <- as.integer(round(num_probands_total * (1 - proband_prop), 0))
    prob <- mendel_prob(num_probands, num_probands_type_2, gene_freq, min_num_variants, min_num_probands_variants)
  }
  return(prob)
}

#' mendel_sample_size
#'
#' Determine the number of families/cases which need to be screened to detect a minimum number of observations of potentially pathogenic variants within the same gene.
#'
#' @param prob probability
#' @param proband_prop proportion of proband being a member of a family, NULL if the proportion is not specified
#' @param gene_freq proportion of affected individuals explained by one gene
#' @param min_num_variants minimum number of probands with pathogenic variant(s) in the same gene
#' @param min_num_probands_variants minimum number of proband being a member of a family with pathogenic variant(s) in the same gene (cannot be bigger than min_num_variants)
#' @return return number of samples (num_family + num_case) needed to reach desired probability
#' @export
#' @examples
#' mendel_sample_size(0.8, 0.2, 0.005, 2, 1)
mendel_sample_size <- function(prob=0.8, proband_prop=NULL, gene_freq=0.005,
                               min_num_variants=2, min_num_probands_variants=0) {
  # parameter check
  if (prob < 0 || prob > 1) {
    stop("probability needs to be between 0 and 1")
  }
  if (!((proband_prop >= 0 && proband_prop <= 1) || is.null(proband_prop))) {
    stop("the proportion of family needs to be between 0 and 1, or NULL (porportion is not specified)")
  }
  if (gene_freq <= 0) {
    stop("Gene frequency needs to be >0")
  }
  if (min_num_variants < 0 || min_num_probands_variants < 0) {
    stop("minimum number of cases with mutation needs to be >0")
  }
  if (min_num_variants < min_num_probands_variants) {
    stop("minimum number of cases with mutation needs to be greater than or
         equal to minimum number of families with mutation")
  }

  num_sample_upper_bound <- max(min_num_variants, as.integer(round(min_num_probands_variants/proband_prop), 0))
  p <- mendel_prob_with_family_ratio(num_sample_upper_bound, proband_prop,
                                   gene_freq, min_num_variants, min_num_probands_variants)

  if (p > prob) {
    num_sample_desired = num_sample_upper_bound
  } else {
    # determine lower and upper bound
    while(p < prob) {
      num_sample_lower_bound <- num_sample_upper_bound
      num_sample_upper_bound <- num_sample_upper_bound * 10
      p <- mendel_prob_with_family_ratio(num_sample_upper_bound, proband_prop,
                                       gene_freq, min_num_variants, min_num_probands_variants)
    }

    # binary search to find optimal sample size
    num_sample_desired <- 0
    while(num_sample_lower_bound < num_sample_upper_bound - 1) {
      num_case_mid <- as.integer(num_sample_lower_bound + (num_sample_upper_bound - num_sample_lower_bound)/2)
      p_mid <- mendel_prob_with_family_ratio(num_case_mid, proband_prop,
                                           gene_freq, min_num_variants, min_num_probands_variants)

      if (p_mid == prob) {
        num_sample_desired <- num_case_mid
        break
      } else if (p_mid > prob) {
        num_sample_upper_bound <- num_case_mid
      } else {
        num_sample_lower_bound <- num_case_mid
      }
    }

    p_lower <- mendel_prob_with_family_ratio(num_sample_lower_bound, proband_prop,
                                           gene_freq, min_num_variants, min_num_probands_variants)
    p_upper <- mendel_prob_with_family_ratio(num_sample_upper_bound, proband_prop,
                                           gene_freq, min_num_variants, min_num_probands_variants)

    if (abs(p_upper - prob) > abs(prob - p_lower)) {
      num_sample_desired = num_sample_lower_bound
    } else {
      num_sample_desired = num_sample_upper_bound
    }
  }

  return(num_sample_desired)
}

####### TEST #######
# mendel_sample_size(0.8, NULL, 0.01, 2, 0) # 298
# mendel_sample_size(0.8, NULL, 0.01, 3, 0) # 427
# mendel_sample_size(0.8, 0.33, 0.005, 3, 1) # 1108
# mendel_sample_size(0.8, 0.5, 0.005, 3, 1) # 923
