#' CIRCLE_SD (Class level)
#'
#' @description Standard deviation of related circumscribing circle (Shape metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details
#' \deqn{CIRCLE_{SD} = sd(CIRCLE[patch_{ij}])}
#' where \eqn{CIRCLE[patch_{ij}]} is the related circumscribing circle of each patch.
#'
#' CIRCLE_SD is a 'Shape metric' and summarises each class as the standard deviation of
#' the related circumscribing circle of all patches belonging to class i. CIRCLE describes
#' the ratio between the patch area and the smallest circumscribing circle of the patch
#' and characterises the compactness of the patch. The metric describes the differences
#' among patches of the same class i in the landscape.
#'
#' \subsection{Units}{None}
#' \subsection{Range}{CIRCLE_SD >= 0}
#' \subsection{Behaviour}{Equals CIRCLE_SD if the related circumscribing circle is identical
#' for all patches. Increases, without limit, as the variation of related circumscribing
#' circles increases.}
#'
#' @seealso
#' \code{\link{lsm_p_circle}},
#' \code{\link{mean}}, \cr
#' \code{\link{lsm_c_circle_mn}},
#' \code{\link{lsm_c_circle_cv}}, \cr
#' \code{\link{lsm_l_circle_mn}},
#' \code{\link{lsm_l_circle_sd}},
#' \code{\link{lsm_l_circle_cv}}
#'
#' @return tibble
#'
#' @examples
#' lsm_c_circle_sd(landscape)
#'
#' @aliases lsm_c_circle_sd
#' @rdname lsm_c_circle_sd
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' Baker, W. L., and Y. Cai. 1992. The r.le programs for multiscale analysis of
#' landscape structure using the GRASS geographical information system.
#' Landscape Ecology 7: 291-302.
#'
#' @export
lsm_c_circle_sd <- function(landscape, directions) UseMethod("lsm_c_circle_sd")

#' @name lsm_c_circle_sd
#' @export
lsm_c_circle_sd.RasterLayer <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_c_circle_sd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_c_circle_sd
#' @export
lsm_c_circle_sd.RasterStack <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_c_circle_sd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_c_circle_sd
#' @export
lsm_c_circle_sd.RasterBrick <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_c_circle_sd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_c_circle_sd
#' @export
lsm_c_circle_sd.stars <- function(landscape, directions = 8) {

    landscape <- methods::as(landscape, "Raster")

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_c_circle_sd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_c_circle_sd
#' @export
lsm_c_circle_sd.list <- function(landscape, directions = 8) {

    result <- lapply(X = landscape,
                     FUN = lsm_c_circle_sd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

lsm_c_circle_sd_calc <- function(landscape, directions,
                                 resolution = NULL, points = NULL) {

    circle <- lsm_p_circle_calc(landscape,
                                directions = directions,
                                resolution = resolution, points = points)

    circle_sd <-  dplyr::summarize(dplyr::group_by(circle, class),
                                   value = stats::sd(value))

    tibble::tibble(
        level = "class",
        class = as.integer(circle_sd$class),
        id = as.integer(NA),
        metric = "circle_sd",
        value = as.double(circle_sd$value)
    )

}

