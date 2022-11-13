
#############################################################
#  Part I. Some real time series data;
#############################################################
# I.1 monthly temperatures data
library(TSA)  # install.packages("TSA")
data(tempdub) # access this data from TSA into R
plot(tempdub,ylab='Temperature',type='o') # Time plot of data

# I.2 color property data
data(color) # access this data from TSA into R
plot(color,ylab='Color Property',type='o') # Time plot of data

# I.3 Oil prices data
data(oil.price) # access this data from TSA into R
plot(oil.price, ylab='Price per Barrel',type='l') # Time plot of data

# I.4 US electricity**
par(mfrow=c(1,3),mai=c(0.8,0.8,0.8,0.1))
# release the dataset "electricity" from package "TSA", and plot it
data(electricity); plot(electricity); 
#plot the sequence after log transformation
log.electricity <- log(electricity); plot(log.electricity);
#plot the sequence after log transformation and differencing
plot(diff(log.electricity)) 

# I.5 Air Passengers**
par(mfrow=c(1,2),mai=c(0.8,0.8,0.3,0.1))
data(AirPassengers)
plot(AirPassengers); plot(log(AirPassengers));
par(mfrow=c(1,1),mai=c(0.3,0.3,0.3,0.1))

# I.6 generate random walk time plots
n <- 100; 
e <- rnorm(n); z <- as.numeric(); z[1] <- e[1]
for(i in 2:n){
 z[i]=z[i-1]+e[i]
}
plot(z); lines(z);

#############################################################
#  Part II. Model identification;
#############################################################
library(TSA)
# II.1   Moving average (MA) models
# II.1.1 Time plot of an MA model
n <- 100; e <- rnorm(n+1)
z <- as.numeric(); z[1] <- e[2]-0.5*e[1]
for(i in 2:n){
  z[i]=e[i+1]-0.5*e[i]
}
par(mfrow=c(2,2),mai=c(0.8,0.8,0.8,0.1))
plot(z); lines(z)

# II.1.2 Population ACF and PACF of an MA model
coef.ma <- c(-0.5,-0.3);
acf.ma <- ARMAacf(ma=coef.ma,lag.max=20, pacf=FALSE);
plot(y=acf.ma,x=c(1:length(acf.ma)-1), ylab='ACF', xlab='Lag'); lines(y=acf.ma,x=c(1:length(acf.ma)-1),type='h'); abline(h=0)

# II.1.3 Sample ACF and sample PACF of an MA model
acf(z,ci.type='ma')
pacf(z)
par(mfrow=c(1,1),mai=c(0.8,0.8,0.8,0.1))

# II.2   Autoregressive (AR) models
# II.2.1 Time plot of an AR model
n <- 1000; order.p <- 1; n.offset <- 10;
e <- rnorm(n+n.offset)
z <- as.numeric(); z <- e[1:order.p]
for(i in (order.p+1):(n+n.offset)){
  z[i]=0.5*z[i-1]+e[i]
}

par(mfrow=c(2,2),mai=c(0.8,0.8,0.8,0.1))
plot(z); lines(z)

# II.2.2 ACF and PACF of an AR model
coef.ar <- c(-0.5,-0.25);
acf.ar <- ARMAacf(ar=coef.ar,lag.max=20, pacf=FALSE);
plot(y=acf.ar,x=c(1:length(acf.ar)-1), ylab='ACF', xlab='Lag'); lines(y=acf.ar,x=c(1:length(acf.ar)-1),type='h'); abline(h=0)

# II.2.3 Sample ACF and sample PACF of an MA model
acf(z,ci.type='ma')
pacf(z)

par(mfrow=c(1,1),mai=c(0.8,0.8,0.8,0.1))

# II.3  Nonstationary time series
# II.3.1 Analyzing the oil prices
# II.3.1.1 The original sequence together with its ACF and PACF
data(oil.price)
plot(oil.price); 
par(mfrow=c(1,3),mai=c(0.8,0.8,0.8,0.1))
plot(oil.price); acf(oil.price,main=''); pacf(oil.price)

# II.3.1.2 The logged sequence together with its ACF and PACF
l.oil.price <- log(oil.price)
plot(l.oil.price); acf(l.oil.price); pacf(l.oil.price)

# II.3.1.3 The log and differenced sequence together with its ACF and PACF
dl.oil.price <- diff(l.oil.price)
plot(dl.oil.price); acf(dl.oil.price); pacf(dl.oil.price)

par(mfrow=c(1,1))

# II.3.2 ADF tests
library(aTSA)
adf.test(oil.price, nlag=5)   

#############################################################
#  Part III Parameter estimation;
#############################################################
# III.1 Generate an AR(1) process
n <- 100; order.p <- 1; n.offset <- 10;
e <- rnorm(n+n.offset)
z <- as.numeric(); z <- e[1:order.p]
for(i in (order.p+1):(n+n.offset)){
  z[i]=0.5*z[i-1]+e[i]
}

# III.2 Draw time plot, sample ACF and sample PACF
par(mfrow=c(1,3),mai=c(0.8,0.8,0.8,0.1))
plot(z); lines(z)
acf(z,ci.type='ma')
pacf(z)
par(mfrow=c(1,1),mai=c(0.8,0.8,0.8,0.1))

# III.3 Fit an ARIMA(0,0,1) model with ML method
m.fit <- arima(z, order=c(0,0,1), method='ML')

# III.3.1 We may try different etimation method for different models
arima(z, order=c(0,0,1), method='CSS') # CSS method for ARIMA(0,0,1)
arima(z, order=c(16,0,1), method='ML') # ML method for ARIMA(16,0,1)
arima(z, order=c(0,0,1)) # the default is to use CSS to find starting values, then ML.

#############################################################
#  Part IV Model diagnostics;
#############################################################
# IV.1 Time plot of residuals
plot(m.fit$residuals, ylab='Residuals'); abline(h=0)

# IV.2 Normality checking
qqnorm(m.fit$residuals); qqline(m.fit$residuals); 
hist(m.fit$residuals)

# IV.3 Autocorrelation checking to check residual autocorrelations individually
par(mfrow=c(1,2),mai=c(0.8,0.8,0.8,0.1))
acf(m.fit$residuals); pacf(m.fit$residuals) 
par(mfrow=c(1,1),mai=c(0.8,0.8,0.8,0.1))

# IV.4 Box-Pierce or Ljung-Box test to check residual autocorrelations jointly
Box.test(m.fit$residuals, lag = 10, type = c("Ljung-Box"), fitdf = 1)
#Box.test(m.fit$residuals, lag = 10, type = c("Box-Pierce"), fitdf = 1)

# IV.4.1 A useful function
library(TSA)
tsdiag(m.fit,gof=15)

#############################################################
#  Part V. Forecasting;
#############################################################
# V.1 Generate AR(1) process
n <- 100; order.p <- 1; n.offset <- 10;
e <- rnorm(n+n.offset)
z <- as.numeric(); z <- e[1:order.p]
for(i in (order.p+1):(n+n.offset)){
  z[i]=0.5*z[i-1]+e[i]
}
z <- z[(n.offset+1):(n.offset+n)]

# V.2 Draw time plot, Sample ACF and sample PACF, and then fit a model
par(mfrow=c(1,3),mai=c(0.8,0.8,0.8,0.1))
plot(z); lines(z)
acf(z,ci.type='ma')
pacf(z)
par(mfrow=c(1,1),mai=c(0.8,0.8,0.8,0.1))
ar <- arima(z, order=c(1,0,0), method='ML'); ar;

# V.3 Predict the next 6 observations
n.head <- 6
ar.pre <- predict(ar,n.ahead=n.head)

# V.4 Present the prediction on the plot
plot(y=z,x=1:n,type='l',xlim=c(-1,(n+n.head+2)))
lines(y=c(z[n],ar.pre$pred),x=c((n):(n+n.head)),col=4)
points(y=ar.pre$pred,x=c((n+1):(n+n.head)),col=4)
lines(y=ar.pre$pred+0.96*ar.pre$se,x=c((n+1):(n+n.head)),col=4)
points(y=ar.pre$pred+0.96*ar.pre$se,x=c((n+1):(n+n.head)),col=4)
lines(y=ar.pre$pred-0.96*ar.pre$se,x=c((n+1):(n+n.head)),col=4)
points(y=ar.pre$pred-0.96*ar.pre$se,x=c((n+1):(n+n.head)),col=4)

#############################################################
# Part VI. Conditional heteroscedastic time series models;
#############################################################

# Set the physical path
setwd("C:/Users/ligd/Google Drive/Presenations/Teaching/Rcode/")
# Read the file into R software
hsi <- read.csv(file = 'HSI.csv'); head(hsi)

hsi.return <- hsi$return[2:length(hsi$return)]
# Time plot of daily closing prices
plot(hsi$Close, type='l', ylab='Price', xlab='Time')
# Time plot of log returns
plot(hsi.return, type='l', ylab='Log Return', xlab='Time')

# Sample ACF and PACF of log returns
par(mfrow=c(1,2),mai=c(0.8,0.8,0.1,0.1))
acf(hsi.return, lag=100, main=''); pacf(hsi.return, lag=100, main='')
par(mfrow=c(1,1),mai=c(0.8,0.8,0.1,0.1))

# Sample ACF and PACF of squared log returns
hsi.return2 <- hsi.return*hsi.return
par(mfrow=c(1,2),mai=c(0.8,0.8,0.1,0.1))
acf(hsi.return2, lag=100, main=''); pacf(hsi.return2, lag=100, main='')
par(mfrow=c(1,1),mai=c(0.8,0.8,0.1,0.1))

# Fitting an GARCH model (need the package of "fGarch")
library(fGarch)
gfit <- garchFit(~garch(1,1), data=hsi.return, trace=FALSE, cond.dist = c("norm"),
include.mean = FALSE)
summary(gfit)

# Predict the next 10 values
predict(gfit, n.ahead = 10, plot=TRUE, conf=.95, nx=100)
