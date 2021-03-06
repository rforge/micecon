\name{summary.cesEst}
\alias{summary.cesEst}
\alias{print.summary.cesEst}
\title{Summarize Estimation of a CES Function}

\description{
   \code{summary} method for objects of class \code{\link{cesEst}}.
}

\usage{
\method{summary}{cesEst}( object, rSquaredLog = object$multErr, ela = TRUE, \dots )
\method{print}{summary.cesEst}( x, ela = TRUE, digits = max(3, getOption("digits") - 3),
   \dots )
}

\arguments{
   \item{object}{an object returned by \code{\link{cesEst}}.}
   \item{rSquaredLog}{logical.
      If \code{FALSE} (the default for models with additive error term),
      the returned \eqn{R^2}-value measures the fraction of the explained
      variance of the dependent variable in natural units.
      If \code{TRUE} (the default for models with multiplicative error term),
      the returned \eqn{R^2}-value measures the fraction of the explained
      variance of the \emph{logarithmized} dependent variable.}
   \item{ela}{logical. If \code{TRUE} (the default), 
      the \code{summary} method calculates 
      the (co)variances of the constant elasticities of substitution
      and the \code{print} method prints these elasticities 
      together with corresponding summary statistics.
      If \code{FALSE}, 
      the \code{summary} method does not 
      calculate the (co)variances of the constant elasticities of substitution
      and the \code{print} method does not print these elasticities.}
   \item{x}{an object returned by \code{summary.cesEst}.}
   \item{digits}{number of digits.}
   \item{\dots}{further arguments are currently ignored.}
}

\value{
   \code{summary.cesEst} returns a list of class \code{summary.cesEst}
   that contains the elements of the provided \code{object} with with
   following changes or additions:
   \item{coefficients}{a matrix with four columns:
      the estimated coefficients/parameters of the CES
      (including a possible fixed \eqn{\rho}{rho}),
      their standard errors, the t-statistic,
      and corresponding (two-sided) P-values.}
   \item{sigma}{square root of the estimated (asymptotic) variance
      of the random error
      (calculated without correcting for degrees of freedom).}
   \item{r.squared}{\eqn{R^2}-value, i.e. the
      \sQuote{fraction of variance explained by the model}.
      If argument \code{rSquaredLog} is \code{TRUE},
      the \eqn{R^2}-value measures the fraction of the explained
      variance of the \emph{logarithmized} dependent variable.}
   \item{vcov}{covariance matrix of the estimated parameters
      (including a possible fixed \eqn{\rho}{rho}).}
   \item{ela}{a matrix with four columns:
      the estimated elasticities of substitution,
      their standard errors, the t-statistic,
      and corresponding (two-sided) P-values
      (only if argument \code{ela} is \code{TRUE}).}
   \item{elaCov}{covariance matrix of the estimated 
      elasticities of substitution
      (only if argument \code{ela} is \code{TRUE}).}
}

\seealso{\code{\link{cesEst}} and \code{\link{cesCalc}}.}

\author{Arne Henningsen}

\examples{
   data( germanFarms, package = "micEcon" )
   # output quantity:
   germanFarms$qOutput <- germanFarms$vOutput / germanFarms$pOutput
   # quantity of intermediate inputs
   germanFarms$qVarInput <- germanFarms$vVarInput / germanFarms$pVarInput


   ## CES: Land & Labor
   cesLandLabor <- cesEst( "qOutput", c( "land", "qLabor" ), germanFarms )

   # print summary results
   summary( cesLandLabor )
}

\keyword{models}
