
.mkq3d <- function() {
  structure(list(vb = NULL, ib = NULL, primitivetype = "quad",
                 material = list(), normals = NULL, texcoords = NULL), .Names = c("vb",
                                                                                  "ib", "primitivetype", "material", "normals", "texcoords"), class = c("mesh3d",
                                                                                                                                                        "shape3d"))

  }

#' @importFrom raster xmin xmax ymin ymax
edgesXY <- function(x) {
  ## report to Hijmans 2015-11-06
  #extract(r, expand.grid(c(xmin(r), xmax(r)), c(ymin(r), ymax(r))), method = "bilinear")
  #[1]   NA   NA 99.5   NA
  ## remove this eps fudge once bilinear works
  eps <- sqrt(.Machine$double.eps)
  as.matrix(expand.grid(seq(xmin(x), xmax(x) -eps, length = ncol(x) + 1),
                        seq(ymax(x), ymin(x) + eps, length = nrow(x) + 1)
  ))
}

#' @importFrom utils head tail
prs <- function(x) {
  cbind(head(x, -1), tail(x, -1))
}

p4 <- function(xp, nc) {
  (xp + c(0, 0, rep(nc, 2)))[c(1, 2, 4, 3)]
}


#' Create a quad-type mesh for use in rgl
#'
#' Convert a \code{\link[raster]{raster}} to a \code{\link[rgl]{mesh3d}} quadrangle mesh.
#' @param x raster object for mesh structure
#' @param z raster object for height values
#' @param na.rm remove quads where missing values?
#' @return mesh3d
#' @export
#' @importFrom raster extract extent values
#' @importFrom dplyr  bind_rows  distinct  group_by  inner_join  mutate row_number transmute
#' @examples
#' library(raster)
#' data(volcano)
#' r <- setExtent(raster(volcano), extent(0, 100, 0, 200))
#' qm <- quadmesh(r)
quadmesh <- function(x, z = x, na.rm = FALSE) {
  x <- x[[1]]  ## just the oneth raster for now
  ##exy <- as.matrix(expand.grid(edges(x), edges(x, "y")))
  exy <- edgesXY(x)
  ind <- apply(prs(seq(ncol(x) + 1)), 1, p4, nc = ncol(x) + 1)


  ## all face indexes
  ind0 <- as.vector(ind) +
    rep(seq(0, length = nrow(x), by = ncol(x) + 1), each = 4 * ncol(x))


  ## need to consider normalizing vertices here
  if (na.rm) {
    ind1 <- matrix(ind0, nrow = 4)
    ind0 <- ind1[,!is.na(values(x))]
  }
  ob <- .mkq3d()

  if (!is.null(z)) z <- extract(z, exy, method = "bilinear") else z <- 0
  ob$vb <- t(cbind(exy, z, 1))
  ob$ib <- matrix(ind0, nrow = 4)
  ob
}
