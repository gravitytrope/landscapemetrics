% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calculate_lsm.R
\name{calculate_lsm}
\alias{calculate_lsm}
\alias{calculate_lsm.RasterLayer}
\alias{calculate_lsm.RasterStack}
\alias{calculate_lsm.RasterBrick}
\alias{calculate_lsm.stars}
\alias{calculate_lsm.list}
\title{calculate_lsm}
\usage{
calculate_lsm(landscape, what, level, metric, name, type, directions,
  count_boundary, consider_boundary, edge_depth, classes_max,
  neighbourhood, ordered, base, full_name, verbose, progress)

\method{calculate_lsm}{RasterLayer}(landscape, what = NULL,
  level = NULL, metric = NULL, name = NULL, type = NULL,
  directions = 8, count_boundary = FALSE, consider_boundary = FALSE,
  edge_depth = 1, classes_max = NULL, neighbourhood = 4,
  ordered = TRUE, base = "log2", full_name = FALSE, verbose = TRUE,
  progress = FALSE)

\method{calculate_lsm}{RasterStack}(landscape, what = NULL,
  level = NULL, metric = NULL, name = NULL, type = NULL,
  directions = 8, count_boundary = FALSE, consider_boundary = FALSE,
  edge_depth = 1, classes_max = NULL, neighbourhood = 4,
  ordered = TRUE, base = "log2", full_name = FALSE, verbose = TRUE,
  progress = FALSE)

\method{calculate_lsm}{RasterBrick}(landscape, what = NULL,
  level = NULL, metric = NULL, name = NULL, type = NULL,
  directions = 8, count_boundary = FALSE, consider_boundary = FALSE,
  edge_depth = 1, classes_max = NULL, neighbourhood = 4,
  ordered = TRUE, base = "log2", full_name = FALSE, verbose = TRUE,
  progress = FALSE)

\method{calculate_lsm}{stars}(landscape, what = NULL, level = NULL,
  metric = NULL, name = NULL, type = NULL, directions = 8,
  count_boundary = FALSE, consider_boundary = FALSE, edge_depth = 1,
  classes_max = NULL, neighbourhood = 4, ordered = TRUE,
  base = "log2", full_name = FALSE, verbose = TRUE,
  progress = FALSE)

\method{calculate_lsm}{list}(landscape, what = NULL, level = NULL,
  metric = NULL, name = NULL, type = NULL, directions = 8,
  count_boundary = FALSE, consider_boundary = FALSE, edge_depth = 1,
  classes_max = NULL, neighbourhood = 4, ordered = TRUE,
  base = "log2", full_name = FALSE, verbose = TRUE,
  progress = FALSE)
}
\arguments{
\item{landscape}{Raster* Layer, Stack, Brick or a list of rasterLayers.}

\item{what}{Selected level of metrics: either "patch", "class" or "landscape".
It is also possible to specify functions as a vector of strings, e.g. \code{what = c("lsm_c_ca", "lsm_l_ta")}.}

\item{level}{Level of metrics to calculate (e.g. 'landscape').}

\item{metric}{Abbreviation of metrics to calculate (e.g. 'area').}

\item{name}{Full name of metrics to calculate (e.g. 'core area').}

\item{type}{Metric types to calculate according to FRAGSTATS grouping (e.g. 'aggregation metric').}

\item{directions}{The number of directions in which patches should be
connected: 4 (rook's case) or 8 (queen's case).}

\item{count_boundary}{Include landscape boundary in edge length}

\item{consider_boundary}{Logical if cells that only neighbour the landscape
boundary should be considered as core}

\item{edge_depth}{Distance (in cells) a cell has the be away from the patch
edge to be considered as core cell}

\item{classes_max}{Potential maximum number of present classes}

\item{neighbourhood}{The number of directions in which cell adjacencies are considered as neighbours:
4 (rook's case) or 8 (queen's case). The default is 4.}

\item{ordered}{The type of pairs considered. Either ordered (TRUE) or unordered (FALSE).
The default is TRUE.}

\item{base}{The unit in which entropy is measured. The default is "log2",
which compute entropy in "bits". "log" and "log10" can be also used.}

\item{full_name}{Should the full names of all functions be included in the
tibble.}

\item{verbose}{Print warning messages}

\item{progress}{Print progress report}
}
\value{
tibble
}
\description{
Calculate a selected group of metrics
}
\examples{
\dontrun{
calculate_lsm(landscape)
calculate_lsm(landscape, what = c("patch", "lsm_c_te", "lsm_l_pr"))
calculate_lsm(landscape, level = c("class", "landscape"), type = "aggregation metric")
}

}
\references{
McGarigal, K., SA Cushman, and E Ene. 2012. FRAGSTATS v4: Spatial Pattern Analysis
Program for Categorical and Continuous Maps. Computer software program produced by
the authors at the University of Massachusetts, Amherst. Available at the following
web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html
}
