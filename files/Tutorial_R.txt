######################################################################
# Chapter 2. Simple manipulations; numbers and vectors
# 2.1 Vectors and assignment
x <- c(10.4, 5.6, 3.1)
c(10.4, 5.6, 3.1) -> x
assign("x", c(10.4, 5.6, 3.1))
y <- c(x, 0, x)

# 2.2 Vector arithmetic
1/x
v <- 2*x+y+1

# 2.3 Generating regular sequences
a <- 2:6

seq(from=2,to=8,by=1)
seq(from=2,by=1,length=7) 

rep(x,times=3)
rep(x,each=3)

# 2.4 Logical vectors
a <- x>9
b <- x<4
a & b

#2.5 Missing values
z <- c(x,NA,0/0); is.na(z); is.nan(z)

# 2.6 Character vectors
a <- c('Tutorial',"in",'R'); 
paste("Today is", date())
paste(c("X","Y"), 1:3, sep="%")

# 2.7 Index vectors; selecting and modifying subsets of a data set
z; a <- !is.na(z); a; z[a]
x; x[2:3]; x[c(1,3,1,2)]
a <- rep(x,times=2); a; a[-(2:3)]
y <- x; names(y) <- c("orange", "banana", "apple"); y; y[c("banana", "apple")]
y <- x; y; y[2:3] <- c(4,7); y

######################################################################
# Chapter 3. Objects, their modes and attributes
# 3.1 Intrinsic attributes: mode and length
x; mode(x); length(x)
a <- x>9; a; as.integer(a)

# 3.2 Changing the length of an object
e <- numeric(); e[3] <- 2.5; e; length(e) <- 5; e; length(e) <- 3; e;

######################################################################
# Chapter 4. Ordered and unordered factors
state <- c("tas", "sa",  "qld", "nsw", "nsw", "nt",  "wa",  "wa",
             "qld", "vic", "nsw", "vic", "qld", "qld", "sa",  "tas",
             "sa",  "nt",  "wa",  "vic", "qld", "nsw", "nsw", "wa",
             "sa",  "act", "nsw", "vic", "vic", "act")
statef <- factor(state)
statef
levels(statef)
incomes <- c(60, 49, 40, 61, 64, 60, 59, 54, 62, 69, 70, 42, 56,
               61, 61, 61, 58, 51, 48, 65, 49, 49, 41, 48, 52, 46,
               59, 46, 58, 43)
tapply(incomes, statef, mean)

######################################################################
# Chapter 5. Arrays and matrices
A <- matrix(1:9,ncol=3,nrow=3); A; 
a <- 1:3; a

# three matrix functions
nrow(A); nrow(A); t(A); 

# the function of "diag"
diag(A); diag(a); diag(3)

# matrix multiplication 
t(a)%*%A%*%a

# matrix inversion
A[3,3] <- 10; solve(A); solve(A,a)

# matrix plus and minus
B <- diag(1:3); A+B; A-B

# eigenvalues and eigenvectors
ev <- eigen(A); names(ev); ev$values; ev$vectors

#Singular value decomposition
ss <- svd(A); names(ss); ss$u; ss$d; ss$v; ss$u%*%diag(ss$d)%*%t(ss$v); A
prod(svd(A)$d); det(A)

# Forming partioned matrices
A; a; cbind(A,a); rbind(A,a)

# Concatenation function
A <- matrix(c(1:9),ncol=3,nrow=3); A; as.vector(A); c(A);

# Frequency tables from factors
statefr <- table(statef)
factor(cut(incomes, breaks = 35+10*(0:7))) -> incomef
table(incomef,statef)

######################################################################
# Chapter 6 Lists and data frames
Lst <- list(name="Fred", wife="Mary", no.children=3,
              child.ages=c(4,7,9))

# Cite an element in the list
Lst[4]; Lst[[4]]; Lst$child.ages

# Adding new objects to the list
Lst$matrix <- A; Lst

# Data frame
accountants <- data.frame(home=statef, loot=incomes, shot=incomef)

# Cite an element in the data frame
accountants$home

# Attach and detach functions
attach(Lst); 
matrix[1:2,1:2]; 
detach()
attach(accountants)
loot[1]
detach()

######################################################################
# Chapter 7. Reading data from files
getwd()
setwd('D:/temp')
list.files()

# read.table function
read.table('file1.txt') -> house
mode(house); names(house)

read.table('file2.txt') 
read.table('file2.txt',header=TRUE) -> house
mode(house); names(house)

# scan function
scan('file1.txt'); scan('file2.txt'); 
scan('file3.txt'); scan('file3.txt',list(0,0,0,0,""));

# Accessing builtin datasets
data(); data(co2); co2

# Loading data from other R packages
data(package="rpart")
data(solder,package="rpart")

# Editing data
xnew <- edit(house)
xnew <- edit(data.frame())

######################################################################
# Chapter 8. Probability distributions
# 8.1 Probability distributions
rnorm(5,mean=0,sd=1); qnorm(0.975,mean=0,sd=1); 
pnorm(1.96,mean=0,sd=1); dnorm(0,mean=0,sd=1)

# 8.2 Examining the distribution of a set of data
attach(faithful); eruptions; 
summary(eruptions); 

# Tukey's five number summary 
# (minimum, lower-hinge, median, upper-hinge, maximum)
fivenum(eruptions)

# Drawing histogram
hist(eruptions)
# make the bins smaller, make a plot of density
hist(eruptions, seq(1.6, 5.2, 0.2), prob=TRUE)
lines(density(eruptions, bw=0.1))
rug(eruptions) # show the actual data points

# Drawing empirical cumulative distribution function
plot(ecdf(eruptions), do.points=FALSE, verticals=TRUE)

# Drawing Q-Q plot
par(pty="s")       # arrange for a square figure region
qqnorm(eruptions); qqline(eruptions)

# Shapiro-Wilk test and Kolmogorov-Smirnov test 
shapiro.test(eruptions)
ks.test(eruptions, "pnorm", mean = mean(eruptions), sd = sqrt(var(eruptions)))

# 8.3 One- and two-sample tests
A <- c( 79.98, 80.04, 80.02, 80.04, 80.03, 80.03, 80.04, 79.97,
        80.05, 80.03, 80.02, 80.00, 80.02)
B <- c( 80.02, 79.94, 79.98, 79.97, 79.97, 80.03, 79.95, 79.97)

boxplot(A, B);
t.test(A,B)
var.test(A,B)
t.test(A,B,var.equal=TRUE)
wilcox.test(A,B)
ks.test(A,B)

######################################################################
# Chapter 9. Grouping, loops and conditional execution
# if statement
x <- 8
if(x<9){
a <- c("x<9")
}else
{
a <- c("x>=9")
}
a

# for loops
for(i in 1:5){
x <- 0.1*i;
y <- 2*i
}
x;y

######################################################################
# Chapter 10. Writing your own functions
# a function to calculate x^3+y^3

func1 <- function(x,y){
 a <- x^3+y^3
 a
}
func1(1,2)

######################################################################
# Chapter 11. Statistical models in R
data(); 
anscombe

lm(y1 ~ y2+y3,data=anscombe) -> fm1
fm1
names(fm1); 

# Updating the model
update(fm1, .~.+y4) -> fm2
update(fm2, .^2~.)

######################################################################
# Chapter 12. Graphical procedures

par(mai=c(1,0.5,0.5,0))
yy <- log(co2[1:30]); xx <- 1:30
plot(y=yy,x=xx,type='l',col=2,lty=2,
     xlim=c(0,35),ylim=c(5.74,5.78),
     xlab='xaxis',ylab='yaxis',main='Demo for MStat students')
y2 <- log(co2[31:60])
lines(y=y2,x=xx,lty=3,col=3)
points(y=y2,x=xx)
abline(h=5.76)
