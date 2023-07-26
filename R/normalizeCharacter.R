#' Normalize a Character
#'
#' This function normalizes a morphological character measurement (a column in your tibble)
#' by another character, following an allometric scaling law.
#' It fits a power-law relationship (a linear relationship in the log-log space)
#' between the two features using both a linear model (lm) and a non-linear model (nls).
#' This methodology is the normalization procedure described in Hamilton et al., 2020 (Journal of Biogeography, 47(7), pp.1494-1509).
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr sym
#' @importFrom magrittr %>%
#' @importFrom stats lm
#' @importFrom stats nls

#' @param data A data frame that includes the two columns.
#' @param character The name of the column to be normalized (as a string).
#' @param normalize_by The name of the column to normalize by (as a string).
#' @param new_col_name The name of the new column that will be created (as a string). Default is `character` + "_normalized".
#'
#' @return The original data frame with the new column that represents the normalized character.
#'
#' @examples
#' \dontrun{
#' # Example 1
#' data <- data.frame(width_cm = rnorm(100, 10, 2), length_cm = rnorm(100, 50, 10))
#' normalizeCharacter(data, "width_cm", "length_cm")
#' # Example 2
#' library(dplyr)
#' my_tibble <- data.frame(width_cm = rnorm(100, 10, 2), length_cm = rnorm(100, 50, 10))
#' my_tibble %>% normalizeCharacter("width_cm", "length_cm")
#' }
#' @export
#' @references
#' Hamilton, A.M., Selwyn, J.D., Hamner, R.M., Johnson, H.K., Brown, T., Springer, S.K. & Bird, C.E., 2020.
#' Biogeography of shell morphology in over‐exploited shellfish reveals adaptive trade‐offs on human‐inhabited
#' islands and incipient selectively driven lineage bifurcation. Journal of Biogeography, 47(7), pp.1494-1509.

normalizeCharacter <-
  function(data,
           character,
           # character = "width_cm",
           normalize_by,
           # normalize_by = "length_cm",
           # a_start = 0.5,
           # b_start = 1,
           new_col_name = paste(character,
                                "_normalized",
                                sep = "")){

    # estimate a and b values
    # https://www.statology.org/power-regression-in-r/
    # nls was throwing errors and this uses lm + transforms to solve
    # answers are slightly diff between lm and nls, so lm produces starting vals for nls
    allometric_formula_lm <-
      as.formula(paste("log(",
                       character,
                       ") ~ log(",
                       normalize_by,
                       ")",
                       sep = ""))
    model_lm <-
      lm(allometric_formula_lm,
         data = data)

    a_start <- exp(model_lm$coefficients[1])
    b_start <- model_lm$coefficients[2]

    # need to use variables to dynamically set formula
    # https://stackoverflow.com/questions/55877110/pass-dynamically-variable-names-in-lm-formula-inside-a-function
    allometric_formula_nls <-
      as.formula(paste(character,
                       " ~ a * ",
                       normalize_by,
                       "^b",
                       sep = ""))


    # # use non linear model to estimate coefficient b
    model_nls <-
      nls(allometric_formula_nls,
          start = list(a = a_start,
                       b = b_start),
          data = data)

    b <- summary(model_nls)$parameters["b", "Estimate"]

    # add column with normalized measure
    # can set column name from variable as long as it's a quosure and we use :=
    # https://stackoverflow.com/questions/26003574/use-dynamic-name-for-new-column-variable-in-dplyr
    # use sym() to coerce a character variable to a quosure
    # https://github.com/r-lib/rlang/issues/116
    data %>%
      dplyr::mutate(
        !!sym(new_col_name) :=
          !!sym(character) *
          (mean(!!sym(normalize_by),
                na.rm = TRUE) /
             !!sym(normalize_by)) ^
          b,

      ) #%>%
    #for trouleshooting
    # pull(!!sym(new_col_name))
  }
