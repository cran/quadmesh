% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/raster.R
\name{qm_as_raster}
\alias{qm_as_raster}
\title{Quadmesh to raster}
\usage{
qm_as_raster(x, index = NULL)
}
\arguments{
\item{x}{'mesh3d' object}

\item{index}{optional index to specify which z coordinate to use as raster values}
}
\value{
RasterLayer
}
\description{
Approximate re-creation of a raster from a quadmesh.
}
\details{
The raster is populated with the mean of the values at each corner, which is
closest to the interpretation use to create mesh3d from rasters. This can be over ridden
by setting 'index' to 1, 2, 3, or 4.
}
\examples{
qm_as_raster(quadmesh(etopo))
}
