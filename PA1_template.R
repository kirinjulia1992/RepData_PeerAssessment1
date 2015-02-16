#loading and preprocessing data
activity <- read.csv("~/Desktop/MOOC/Reproducible Research/activity.csv")

#average daily activity pattern
dates<-levels(activity$date)
steps_mean<-NULL
steps_sum<-NULL
for (i in 1:61)
{
  j<-as.character(i)
  j<-activity[activity$date %in% dates[i],]
  mstep<-mean(j$steps)
  sumstep<-sum(j$steps)
  steps_mean<-c(steps_mean,mstep)
  steps_sum<-c(steps_sum,sumstep)
}
new_dates<-as.vector(dates)
new_data<-data.frame(dates,steps_mean,steps_sum)
oldmean<-mean(steps_sum)
oldmedian<-median(steps_sum)
state0<-paste0("the new data set has a mean for total steps as ",oldmean," and a median for total steps as ",oldmedian)
print(state0)

png("~/Desktop/MOOC/Reproducible Research/plot1.png",width=480, height=480,)
hist(new_data$steps_sum)
dev.off()



b<-new_data$steps_sum
a<-new_data$dates
c<-new_data$steps_mean
png("~/Desktop/MOOC/Reproducible Research/plot2.png",width=480, height=480,)
with(new_data,plot(c,a,type="n",col="black",xlab="5-minute interval ",ylab="days",xaxt="n"))
with(new_data,points(c,a,type="l",yaxt="n",xaxt="n"))
dev.off()



#imputing missin values
stepsraw<-activity$steps
steps_na<-sum(is.na(stepsraw))
steps_sum[is.na(steps_sum)]=0
steps_mean[is.na(steps_mean)]=0
new_data2<-data.frame(dates,steps_mean,steps_sum)
state<-paste0("the number of NAs in the data set is ",steps_na)
print(state)
png("~/Desktop/MOOC/Reproducible Research/plot3.png",width=480, height=480,)
hist(steps_sum)
dev.off()
newmean<-mean(steps_sum)
newmedian<-median(steps_sum)
state2<-paste0("the new data set has a mean for total steps as ",newmean," and a median for total steps as ",newmedian)
print(state2)

#difference in weekdays and weekends
library(lattice)
library(datasets)
dummy1<-as.vector(dates)
dummy2<-as.Date(dummy1)
days<-weekdays(dummy2)
data_frame<-data.frame(days,steps_mean)
weekdays<-c('Monday','Tuesday','Wednesday','Thursday','Friday')
weekends<-c('Saturday','Sunday')
test<-days
test[test %in% weekdays] = 'weekdays'
test[test %in% weekends] = 'weekends'
id<-c(1:61)
test_frame<-data.frame(test,steps_mean,id)
library(lattice)
setwd("~/Desktop/MOOC/Reproducible Research/")
final<-xyplot(steps_mean~id|test,data=test_frame,type="l")
trellis.device(device="png", filename="xyplot.png")
print(final)
dev.off()