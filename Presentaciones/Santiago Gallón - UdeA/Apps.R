# Install
# install.packages("fda")                                                             # Functional Data Analysis (Ramsay, et al.)
# install.packages("rainbow")                                                         # Rainbow Plots, Bagplots and Boxplots for Functional Data (Shang and Hyndman)
# Load packages
library(fda)
library(rainbow)

rm(list = ls())                                                               	    # Remove objects from the environment

####### Reconstruction of functional curves (requires the "fda" package) #######
load("El_Nino.RData")                                                   # Monthly sea surface temperatures from January 1950 to December 2006
#load("C:/FDA/apps/French_mortality.RData")                                         # Age-specific mortality rates and population for France from 1816 to 2006.

X <- El_Nino  # French_mortality # El_Nino
class(X)

t <- 1:dim(X)[1]                                                              	    # Number of knots (K)
norder <- 4                                                                   	    # L-th order spline (i.e., degree + 1). Cubic spline (L=4)
nbasis <- length(t) - 2 + norder                                           	 	      # Number of basis expansion: knots + order spline
basis  <- create.bspline.basis(range(t), nbasis, norder, breaks=t)         	   	    # Create B-spline basis
plot(basis, xlab="t", ylab="B-spline basis")                                                                   	    # Graph of B-spline basis
Lfdobj <- 2                                                                   	    # m-th derivative in the roughness penalty
# Choice of the smoothing parameter by Generalized Cross Validation (GCV)
loglam <- seq(-2,2,0.1)
nlam <- length(loglam)
gcv <- rep(NA,nlam)
for (i in 1:nlam){
  fdpar  <- fdPar(basis, Lfdobj, lambda=10^loglam[i])
  smooth <- smooth.basis(t, X, fdpar)
  gcv[i] <- sum(smooth$gcv)
}
plot(loglam,gcv/10000, type="o", pch=20, ylab=expression(GCV(lambda)), xlab=expression(log[10](lambda)))

lambda <- 10^(loglam[which.min(gcv)])                                         	    # Minimum smoothing parameter lambda <- 10^(0.1)
fdpar  <- fdPar(basis, Lfdobj, lambda=lambda)                                 	    # Define a functional parameter object
Xs <- smooth.basis(t, X, fdpar)$fd                                            	    # Functional data object containing the smoothing data
SX <- eval.fd(t, Xs)                                                           	    # Values of a functional data object

# Graph
par(mfrow=c(1,2), mar=c(4.2,4.2,0.2,0.2))
matplot(t, X,  type="l", lty=1, xlab="t", ylab="Nonsmooth functions")
plot(Xs, lty=1, xlab="t", ylab="Smooth functions")

# Derivatives of functions
par(mfrow=c(1,2), mar=c(4.2,4.2,0.2,0.2))
plot(deriv.fd(Xs, 1), lty=1, xlab="t", ylab="First derivative")
plot(deriv.fd(Xs, 2), lty=1, xlab="t", ylab="Second derivative")
dev.off()

#### Some descriptions of dunctional data ####
mu <- mean.fd(Xs)                                                             	    # Mean function, mu(t)
plot(Xs, lty=1, xlab="t", ylab="Y(t)", col=gray(0.8))
plot(mu, xlab="t", ylab="Mean Function", add=TRUE)
legend("topright", "Mean function", lty=1, bty="n")

K <- var.fd(Xs)                                                               	    # Covariance function, K(s,t)
K_bi <- eval.bifd(t, t, K)                                                    	    # Evaluated covariance function
par(mfrow=c(1,1), mar=c(0,3,0,0))
persp(t, t, K_bi, theta=-45, phi=15, r=3, expand=0.75, ticktype="detailed", zlab="Variance", col=gray(0.8))
dev.off()

fpca2 <- pca.fd(Xs, nharm = 2)                                                	    # FPCA
plot.pca.fd(fpca2)                                                            	    # Plot of eigenfunctions
#
plot(fpca2$scores, ylab="Comp.2", xlab="Comp.1", pch=20, cex=0.5)                   # Scatterplot of PC scores
text(fpca2$scores, colnames(X), cex=0.8, pos=3, col=2)

####### Applications of bivariate and functional boxplots (require the "rainbow" package) #######
# Create functional objects
y <- fts(t, SX, start=1, frequency=dim(X)[1], xname="Month", yname="Sea surface temperature")
#y <- fts(t, SX, start=1, frequency=dim(X)[1], xname="Age", yname="log mortality rate")

#### Rainbow plots ####
plot(y, plot.type = "functions", plotlegend = TRUE)                           	    # Time ordering
#plot(y, plot.type = "depth", plotlegend = TRUE)                              	    # Depth ordering
#plot(y, plot.type = "density", plotlegend = TRUE)                            	    # Density ordering

#### Bivariate and Functional Bagplots ####
fboxplot(y, plot.type = "bivariate",  type = "bag")#, xlim=c(-5,11), ylim=c(-5,4.5))
fboxplot(y, plot.type = "functional", type = "bag")                           	    # Functional bagplot
fboxplot(y, plot.type = "bivariate",  type = "hdr", alpha=c(0.06,0.5))#, xlim=c(-6,11), ylim=c(-8,4.5))
fboxplot(y, plot.type = "functional", type = "hdr", alpha=c(0.06,0.5))        	    # Functional HDR boxplot

# Other application with simulation data 
plot(Simulationdata, col = rainbow(100), xlab="t", ylab="Y(t)")
lines(Simulationdata, index = 991:1000, col = "black")
#
fboxplot(Simulationdata, plot.type = "bivariate",  type = "bag")
fboxplot(Simulationdata, plot.type = "functional", type = "bag")
fboxplot(Simulationdata, plot.type = "bivariate",  type = "hdr", alpha=c(0.01,0.5))
fboxplot(Simulationdata, plot.type = "functional", type = "hdr", alpha=c(0.01,0.5))

# End #