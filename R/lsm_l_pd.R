#' PD (landscape level)
#'
#' @description Patch density (Aggregation metric)
#'
#' @param landscape Raster* Layer, Stack, Brick or a list of rasterLayers.
#' @param directions The number of directions in which patches should be
#' connected: 4 (rook's case) or 8 (queen's case).
#'
#' @details
#' \deqn{PD = \frac{N} {A} * 10000 * 100}
#' where \eqn{N} is the number of patches and \eqn{A} is the total landscape
#' area in square meters.
#'
#' PD is an 'Aggregation metric'. It describes the fragmentation the landscape, however,
#' does not necessarily contain information about the configuration or composition of the
#' landscape. In contrast to \code{\link{lsm_l_np}} it is standardized to the area and
#' comparisons among landscapes with different total area are possible.
#'
#' \subsection{Units}{Number per 100 hectares}
#' \subsection{Ranges}{0 < PD <= 1e+06}
#' \subsection{Behaviour}{Increases as the landscape gets more patchy. Reaches its maximum
#' if every cell is a different patch.}
#'
#' @seealso
#' \code{\link{lsm_c_np}},
#' \code{\link{lsm_l_ta}}, \cr
#' \code{\link{lsm_c_pd}}
#'
#' @return tibble
#'
#' @examples
#' lsm_l_pd(landscape)
#'
#' @aliases lsm_l_pd
#' @rdname lsm_l_pd
#'
#' @references
#' McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
#' Program for Categorical and Continuous Maps. Computer software program produced by
#' the authors at the University of Massachusetts, Amherst. Available at the following
#' web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
#'
#' @export
lsm_l_pd <- function(landscape, directions) UseMethod("lsm_l_pd")

#' @name lsm_l_pd
#' @export
lsm_l_pd.RasterLayer <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_pd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_pd
#' @export
lsm_l_pd.RasterStack <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_pd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_pd
#' @export
lsm_l_pd.RasterBrick <- function(landscape, directions = 8) {

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_pd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_pd
#' @export
lsm_l_pd.stars <- function(landscape, directions = 8) {

    landscape <- methods::as(landscape, "Raster")

    result <- lapply(X = raster::as.list(landscape),
                     FUN = lsm_l_pd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

#' @name lsm_l_pd
#' @export
lsm_l_pd.list <- function(landscape, directions = 8) {

    result <- lapply(X = landscape,
                     FUN = lsm_l_pd_calc,
                     directions = directions)

    dplyr::mutate(dplyr::bind_rows(result, .id = "layer"),
                  layer = as.integer(layer))
}

lsm_l_pd_calc <- function(landscape, directions, resolution = NULL) {

    if(class(landscape) != "matrix") {
        resolution <- raster::res(landscape)
        landscape <- raster::as.matrix(landscape)
    }

    # get patch area
    area_patch <- lsm_p_area_calc(landscape,
                                  directions = directions,
                                  resolution = resolution)

    # summarise for total landscape
    area_total <- dplyr::summarise(area_patch, value = sum(value))

    # number of patches for each class
    number_patches <- lsm_c_np_calc(landscape,
                                    directions = directions)

    # summarise for total landscape
    number_patches <- dplyr::summarise(number_patches, value = sum(value))

    # relative patch density
    patch_density <- (number_patches$value / area_total$value) * 100

    tibble::tibble(
        level = "landscape",
        class = as.integer(NA),
        id = as.integer(NA),
        metric = "pd",
        value = as.double(patch_density)
    )
}
