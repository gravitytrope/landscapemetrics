#' DCORE_SD (landscape level)
#'
#' @description Standard deviation number of disjunct core areas (Core area metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#' @param consider_boundary Logical if cells that only neighbour the landscape
#' boundary should be considered as core
#' @param edge_depth Distance (in cells) a cell has the be away from the patch
#' edge to be considered as core cell
#'
#' @details
#' \deqn{DCORE_{SD} = sd(NCORE[patch_{ij}])}
#' where \eqn{NCORE[patch_{ij}]} is the number of core areas.
#'
#' DCORE_SD is an 'Core area metric'. It summarises the landscape as the standard deviation
#' of all patches. A cell is defined as core if the cell has no neighbour with a different
#' value than itself (rook's case). NCORE counts the disjunct core areas, whereby a core
#' area is a 'patch within the patch' containing only core cells. The metric describes the
#' differences among all patches in the landscape.
#'
#' \subsection{Units}{None}
#' \subsection{Range}{DCORE_SD >= 0}
#' \subsection{Behaviour}{Equals DCORE_SD = 0 if all patches have the same number of disjunct
#' core areas. Increases, without limit, as the variation of number of disjunct core areas
#' increases.}
#'
#' @seealso
#' \code{\link{lsm_p_ncore}},
#' \code{\link{sd}}, \cr
#' \code{\link{lsm_c_dcore_mn}},
#' \code{\link{lsm_c_dcore_sd}}, \cr
#' \code{\link{lsm_c_dcore_cv}},
#' \code{\link{lsm_l_dcore_mn}},
#' \code{\link{lsm_l_dcore_cv}}
#'
#' @return tibble
#'
#' @examples
#' lsm_l_dcore_sd(landscape)
#'
#' @aliases lsm_l_dcore_sd
#' @rdname lsm_l_dcore_sd
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' @export
lsm_l_dcore_sd <- function(landscape, directions, consider_boundary, edge_depth) UseMethod("lsm_l_dcore_sd")

#' @name lsm_l_dcore_sd
#' @export
lsm_l_dcore_sd.RasterLayer <- function(landscape,
                                       directions = 8,
                                       consider_boundary = FALSE,
                                       edge_depth = 1) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_dcore_sd_calc,
                     directions = directions,
                     consider_boundary = consider_boundary,
                     edge_depth = edge_depth)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_dcore_sd
#' @export
lsm_l_dcore_sd.RasterStack <- function(landscape,
                                       directions = 8,
                                       consider_boundary = FALSE,
                                       edge_depth = 1) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_dcore_sd_calc,
                     directions = directions,
                     consider_boundary = consider_boundary,
                     edge_depth = edge_depth)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_dcore_sd
#' @export
lsm_l_dcore_sd.RasterBrick <- function(landscape,
                                       directions = 8,
                                       consider_boundary = FALSE,
                                       edge_depth = 1) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_dcore_sd_calc,
                     directions = directions,
                     consider_boundary = consider_boundary,
                     edge_depth = edge_depth)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_dcore_sd
#' @export
lsm_l_dcore_sd.stars <- function(landscape,
                                 directions = 8,
                                 consider_boundary = FALSE,
                                 edge_depth = 1) {

    landscape <- methods::as(landscape, "Raster")

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_dcore_sd_calc,
                     directions = directions,
                     consider_boundary = consider_boundary,
                     edge_depth = edge_depth)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_dcore_sd
#' @export
lsm_l_dcore_sd.list <- function(landscape,
                                directions = 8,
                                consider_boundary = FALSE,
                                edge_depth = 1) {

    result <- lapply(X = landscape,
                     FUN = lsm_l_dcore_sd_calc,
                     directions = directions,
                     consider_boundary = consider_boundary,
                     edge_depth = edge_depth)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

lsm_l_dcore_sd_calc <- function(landscape, directions, consider_boundary, edge_depth,
                                points = NULL){

    dcore_sd <- dplyr::summarise(lsm_p_ncore_calc(landscape,
                                                  directions = directions,
                                                  consider_boundary = consider_boundary,
                                                  edge_depth = edge_depth,
                                                  points = points),
                                 value = stats::sd(value))

    tibble::tibble(
        level = "landscape",
        class = as.integer(NA),
        id = as.integer(NA),
        metric = "dcore_sd",
        value = as.double(dcore_sd$value)
    )
}
