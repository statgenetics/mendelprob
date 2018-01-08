#' mendel_prob
#'
#' Determine the probability of detecting a minimum number of families or unrelated cases with pathogenic variants in the same gene.
#'
#' @param num_family number of families
#' @param num_case number of unrelated cases
#' @param gene_freq proportion of affected individuals explained by one gene
#' @param min_num_total_mutation minimum number of families and cases with pathogenic variant(s) in the same gene
#' @param min_num_family_mutation minimum number of families with pathogenic variant(s) in the same gene
#' @return probability
#' @export
#' @examples
#' mendel_prob(125, 500, 0.005, 2, 1)
mendel_prob <- function(num_family, num_case, gene_freq,
                        min_num_total_mutation, min_num_family_mutation) {
  # parameter check
  if (num_family < 0 || num_case < 0) {
    stop("number of family or proband needs to be >0")
  }
  if (gene_freq <= 0) {
    stop("gene frequency needs to be >0")
  }
  if (min_num_total_mutation < 0 || min_num_family_mutation < 0) {
    stop("minimum number of cases with mutation needs to be >0")
  }
  if (min_num_total_mutation < min_num_family_mutation) {
    stop("minimum number of cases with mutation needs to be greater than or
         equal to minimum number of families with mutation")
  }
  if (min_num_total_mutation > num_family + num_case) {
    stop("minimum number of cases with mutation needs to be less than or
         equal to number of total cases")
  }
  if (min_num_family_mutation > num_family) {
    stop("minimum number of families with mutation needs to be less than or
         equal to number of families")
  }

  if (min_num_family_mutation == min_num_total_mutation) {
    prob <- (1 - pbinom(min_num_family_mutation - 1, size=num_family, prob=gene_freq))
  }
  else if (min_num_family_mutation == 0) {
    prob <- (1 - pbinom(min_num_total_mutation - 1, size=num_family+num_case, prob=gene_freq))
  }
  else
  {
    prob <- 0

    for (fam in seq(min_num_family_mutation, min_num_total_mutation - 1)){
      prob <- prob + dbinom(fam, size=num_family, prob=gene_freq) *
        (1 - pbinom(min_num_total_mutation - fam - 1, size=num_case, prob=gene_freq))
    }
    prob <- prob + (1 - pbinom(min_num_total_mutation - 1, size=num_family, prob=gene_freq))
  }

  return(prob)
}

####### TEST #######
# mendel_prob(125, 500, 0.005, 2, 0)
# mendel_prob(125, 500, 0.005, 2, 1)
# mendel_prob(125, 500, 0.01, 2, 1)

#' mendel_prob_with_family_ratio
#'
#' internal use only.
mendel_prob_with_family_ratio <- function(num_family_plus_case, family_prop, gene_freq,
                                        min_num_total_mutation, min_num_family_mutation) {
  if (family_prop == -1) {
    prob <- mendel_prob(0, num_family_plus_case, gene_freq, min_num_total_mutation, 0)
  }
  else {
    num_family <- as.integer(round(num_family_plus_case * family_prop, 0))
    num_case <- as.integer(round(num_family_plus_case * (1 - family_prop), 0))
    prob <- mendel_prob(num_family, num_case, gene_freq, min_num_total_mutation, min_num_family_mutation)
  }
  return(prob)
}

#' mendel_sample_size
#'
#' Determine the number of families/cases which need to be screened to detect a minimum number of observations of potentially pathogenic variants within the same gene.
#'
#' @param prob probability
#' @param family_prop proportion of family
#' @param gene_freq proportion of affected individuals explained by one gene, -1 if the proportion is not specified
#' @param min_num_total_mutation minimum number of families and cases with pathogenic variant(s) in the same gene
#' @param min_num_family_mutation minimum number of families with pathogenic variant(s) in the same gene
#' @return return number of samples (num_family + num_case) needed to reach desired probability
#' @export
#' @examples
#' mendel_sample_size(0.8, 0.2, 0.005, 2, 1)
mendel_sample_size <- function(prob, family_prop, gene_freq,
                               min_num_total_mutation, min_num_family_mutation) {
  # parameter check
  if (prob < 0 || prob > 1) {
    stop("probability needs to be between 0 and 1")
  }
  if (!((family_prop >= 0 && family_prop <= 1) || family_prop == -1)) {
    stop("proportion of family needs to be between 0 and 1, or -1 (porportion is not specified)")
  }
  if (gene_freq <= 0) {
    stop("Gene frequency needs to be >0")
  }
  if (min_num_total_mutation < 0 || min_num_family_mutation < 0) {
    stop("minimum number of cases with mutation needs to be >0")
  }
  if (min_num_total_mutation < min_num_family_mutation) {
    stop("minimum number of cases with mutation needs to be greater than or
         equal to minimum number of families with mutation")
  }

  num_sample_upper_bound <- min_num_total_mutation
  p <- mendel_prob_with_family_ratio(num_sample_upper_bound, family_prop,
                                   gene_freq, min_num_total_mutation, min_num_family_mutation)

  if (p > prob) {
    num_sample_desired = num_sample_upper_bound
  } else {
    # determine lower and upper bound
    while(p < prob) {
      num_sample_lower_bound <- num_sample_upper_bound
      num_sample_upper_bound <- num_sample_upper_bound * 10
      p <- mendel_prob_with_family_ratio(num_sample_upper_bound, family_prop,
                                       gene_freq, min_num_total_mutation, min_num_family_mutation)
    }

    # binary search to find optimal sample size
    num_sample_desired <- 0
    while(num_sample_lower_bound < num_sample_upper_bound - 1) {
      num_case_mid <- as.integer(num_sample_lower_bound + (num_sample_upper_bound - num_sample_lower_bound)/2)
      p_mid <- mendel_prob_with_family_ratio(num_case_mid, family_prop,
                                           gene_freq, min_num_total_mutation, min_num_family_mutation)

      if (p_mid == prob) {
        num_sample_desired <- num_case_mid
        break
      } else if (p_mid > prob) {
        num_sample_upper_bound <- num_case_mid
      } else {
        num_sample_lower_bound <- num_case_mid
      }
    }

    p_lower <- mendel_prob_with_family_ratio(num_sample_lower_bound, family_prop,
                                           gene_freq, min_num_total_mutation, min_num_family_mutation)
    p_upper <- mendel_prob_with_family_ratio(num_sample_upper_bound, family_prop,
                                           gene_freq, min_num_total_mutation, min_num_family_mutation)

    if (abs(p_upper - prob) > abs(prob - p_lower)) {
      num_sample_desired = num_sample_lower_bound
    } else {
      num_sample_desired = num_sample_upper_bound
    }
  }

  return(num_sample_desired)
}

####### TEST #######
# mendel_sample_size(0.8, -1, 0.01, 2, 0)
# mendel_sample_size(0.8, -1, 0.01, 3, 0)
# mendel_sample_size(0.8, 0.33, 0.005, 3, 1)
# mendel_sample_size(0.8, 0.5, 0.005, 3, 1)
