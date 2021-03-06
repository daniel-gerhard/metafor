\name{residuals.rma}
\alias{residuals.rma}
\alias{rstandard.rma.uni}
\alias{rstandard.rma.mh}
\alias{rstandard.rma.mv}
\alias{rstandard.rma.peto}
\alias{rstudent.rma.uni}
\alias{rstudent.rma.mh}
\alias{rstudent.rma.mv}
\alias{rstudent.rma.peto}
\title{Residual Values based on 'rma' Objects}
\description{
   The \code{residuals}, \code{rstandard}, and \code{rstudent} functions can be used to compute residuals, corresponding standard errors, and standardized residuals for models fitted with the \code{\link{rma.uni}}, \code{\link{rma.mh}}, \code{\link{rma.peto}}, and \code{\link{rma.mv}} functions.
}
\usage{
\method{residuals}{rma}(object, type="response", \dots)

\method{rstandard}{rma.uni}(model, digits, \dots)
\method{rstandard}{rma.mh}(model, digits, \dots)
\method{rstandard}{rma.mv}(model, digits, cluster, \dots)
\method{rstandard}{rma.peto}(model, digits, \dots)

\method{rstudent}{rma.uni}(model, digits, progbar=FALSE, \dots)
\method{rstudent}{rma.mh}(model, digits, progbar=FALSE, \dots)
\method{rstudent}{rma.mv}(model, digits, progbar=FALSE, cluster,
         reestimate=TRUE, parallel="no", ncpus=1, cl=NULL, \dots)
\method{rstudent}{rma.peto}(model, digits, progbar=FALSE, \dots)
}
\arguments{
   \item{object}{an object of class \code{"rma"} (for \code{residuals}).}
   \item{type}{the type of residuals which should be returned (by \code{residuals}). The alternatives are: \code{"response"} (default), \code{"rstandard"}, \code{"rstudent"}, and \code{"pearson"}.}
   \item{model}{an object of class \code{"rma.uni"}, \code{"rma.mh"}, \code{"rma.peto"}, or \code{"rma.mv"} (for \code{rstandard} and \code{rstudent}).}
   \item{cluster}{optional vector specifying a clustering variable to use for computing cluster-level multivariate standardized residuals (only for \code{"rma.mv"} objects).}
   \item{reestimate}{logical indicating whether variance/correlation components should be re-estimated after deletion of the \eqn{i}th study/cluster (the default is \code{TRUE}).}
   \item{parallel}{character string indicating whether parallel processing should be used (the default is \code{"no"}). For parallel processing, set to either \code{"snow"} or \code{"multicore"}. See \sQuote{Details}.}
   \item{ncpus}{integer specifying the number of processes to be used in the parallel processing.}
   \item{cl}{optional snow cluster to use if \code{parallel="snow"}. If not supplied, a cluster on the local machine is created for the duration of the call.}
   \item{digits}{integer specifying the number of decimal places to which the printed results should be rounded (if unspecified, the default is to take the value from the object).}
   \item{progbar}{logical indicating whether a progress bar should be shown (only for \code{rstudent}) (the default is \code{FALSE}).}
   \item{\dots}{other arguments.}
}
\details{
   The observed residuals (obtained with \code{residuals}) are simply equal to the \sQuote{observed - fitted} values. These can be obtained with \code{residuals(object)} (using the default \code{type="response"}).

   Dividing the observed residuals by the model-implied standard errors of the observed effect sizes or outcomes yields Pearson (or semi-standardized) residuals. These can be obtained with \code{residuals(object, type="pearson")}.

   Dividing the observed residuals by their corresponding standard errors yields (internally) standardized residuals. These can be obtained with \code{rstandard} or \code{residuals(object, type="rstandard")}.

   The \code{rstudent} function (or \code{residuals(object, type="rstudent")}) calculates externally standardized residuals (also called standardized deleted residuals or (externally) studentized residuals). The externally standardized residual for the \eqn{i}th case is obtained by deleting the \eqn{i}th case from the dataset, fitting the model based on the remaining cases, calculating the predicted value for the \eqn{i}th case based on the fitted model, taking the difference between the observed and the predicted value for the \eqn{i}th case (which yields the deleted residual), and then standardizing the deleted residual.

   If a particular study fits the model, its standardized residual follows (asymptotically) a standard normal distribution. A large standardized residual for a study therefore may suggest that the study does not fit the assumed model (i.e., it may be an outlier).

   For \code{"rma.mv"} objects, one can also specify a clustering variable. Then \code{rstandard} and \code{rstudent} also compute cluster-level multivariate (internally or externally) standardized residuals. If all outcomes within a cluster fit the model, then the multivariate standardized residual follows (asymptotically) a chi-square distribution with \if{latex}{\eqn{k_i}}\if{html}{\eqn{kᵢ}}\if{text}{\eqn{k_i}} degrees of freedom (where \if{latex}{\eqn{k_i}}\if{html}{\eqn{kᵢ}}\if{text}{\eqn{k_i}} denotes the number of outcomes within the cluster).

   See also \code{\link{influence.rma.uni}} and \code{\link{influence.rma.mv}} for other leave-one-out diagnostics that are useful for detecting influential cases in models fitted with the \code{\link{rma.uni}} and \code{\link{rma.mv}} functions.
}
\value{
   Either a vector with the residuals of the requested type (for \code{residuals}) or an object of class \code{"list.rma"}, which is a list containing the following components:
   \item{resid}{observed residuals (for \code{rstandard}) or deleted residuals (for \code{rstudent}).}
   \item{se}{corresponding standard errors.}
   \item{z}{standardized residuals (internally standardized for \code{rstandard} or externally standardized for \code{rstudent}).}

   When a clustering variable is specified for \code{"rma.mv"} objects, the returned object is a list with the first element as described above (with \code{cluster} added as another component) and another list element of class \code{"list.rma"} with:
   \item{X2}{cluster-level multivariate standardized residuals.}
   \item{k}{number of outcomes within the clusters.}

   The \code{"list.rma"} object is formatted and printed with \code{\link{print.list.rma}}.
}
\note{
   Right now, the externally standardized residuals are calculated by refitting the model \eqn{k} times (where \eqn{k} is the number of studies/clusters). Depending on how large \eqn{k} is, it may take a few moments to finish the calculations.

   On machines with multiple cores, one can usually speed things up by delegating the model fitting to separate worker processes, that is, by setting \code{parallel="snow"} or \code{parallel="multicore"} and \code{ncpus} to some value larger than 1 (only for objects of class \code{"rma.mv"}). Parallel processing makes use of the \code{\link[parallel]{parallel}} package, using the \code{\link[parallel]{makePSOCKcluster}} and \code{\link[parallel]{parLapply}} functions when \code{parallel="snow"} or using \code{\link[parallel]{mclapply}} when \code{parallel="multicore"} (the latter only works on Unix/Linux-alikes). With \code{parallel::detectCores()}, one can check on the number of available cores on the local machine.

   Alternatively (or in addition to using parallel processing), one can also set \code{reestimate=FALSE}, in which case any variance/correlation components in the model are not re-estimated after deleting the \eqn{i}th study/cluster from the dataset. Doing so only yields an approximation to the externally standardized residuals (and the cluster-level multivariate standardized residuals) that ignores the influence of the \eqn{i}th study/cluster on the variance/correlation components, but is considerably faster (and often yields similar results).

   It may not be possible to fit the model after deletion of the \eqn{i}th study/cluster from the dataset. This will result in \code{NA} values for that study/cluster when calling \code{rstudent}.

   Also, for \code{"rma.mv"} objects with a clustering variable specified, it may not be possible to compute the cluster-level multivariate standardized residual for a particular cluster (if the var-cov matrix of the residuals within a cluster is not of full rank). This will result in \code{NA} for that cluster.

   For objects of class \code{"rma.mh"} and \code{"rma.peto"}, \code{rstandard} actually computes Pearson (or semi-standardized) residuals.
}
\author{
   Wolfgang Viechtbauer \email{wvb@metafor-project.org} \url{http://www.metafor-project.org/}
}
\references{
   Hedges, L. V., & Olkin, I. (1985). \emph{Statistical methods for meta-analysis}. San Diego, CA: Academic Press.

   Viechtbauer, W. (2010). Conducting meta-analyses in R with the metafor package. \emph{Journal of Statistical Software}, \bold{36}(3), 1--48. \url{http://www.jstatsoft.org/v36/i03/}.

   Viechtbauer, W., & Cheung, M. W.-L. (2010). Outlier and influence diagnostics for meta-analysis. \emph{Research Synthesis Methods}, \bold{1}, 112--125.
}
\seealso{
   \code{\link{rma.uni}}, \code{\link{rma.mh}}, \code{\link{rma.peto}}, \code{\link{rma.glmm}}, \code{\link{rma.mv}}, \code{\link{influence.rma.uni}}, \code{\link{influence.rma.mv}}
}
\examples{
### meta-analysis of the log risk ratios using a random-effects model
res <- rma(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, data=dat.bcg)
rstudent(res)

### mixed-effects model with absolute latitude as a moderator
res <- rma(measure="RR", ai=tpos, bi=tneg, ci=cpos, di=cneg, mods = ~ ablat,
           data=dat.bcg)
rstudent(res)
}
\keyword{models}
