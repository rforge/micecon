\name{df.residual.aidsEst}
\alias{df.residual.aidsEst}

\title{Covariance matrix of an Almost Ideal Demand System}

\description{
   These method returns the covariance matrix of the coefficients from
   an Almost Ideal Demand System (AIDS).
}

\usage{
   \method{df.residual}{aidsEst}( object, ... )
}

\arguments{
  \item{object}{an object of class \code{aidsEst}.}
  \item{...}{currently not used.}
}

\value{
The \code{df.residual} method for objects of class \code{aidsEst}
returns a symmetric matrix: the covariance matrix of the coefficients.
}

\author{Arne Henningsen, \email{ahenningsen@agric-econ.uni-kiel.de}}

\seealso{\code{\link{aidsEst}}, \code{\link{coef.aidsEst}}}

\keyword{methods}
