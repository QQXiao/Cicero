#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
#library(Rcpp)
library(lme4)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/Cicero")
resultdir <- paste(basedir,"pattern/ROI_based/ref_space/me/rt",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"pattern/ROI_based/ref_space/me/rt_mem_LHIP.txt",sep="/")
item_data <- read.table(item_file,header=FALSE)
act_file <- paste(basedir,"pattern/ROI_based/ref_space/me/act_LHIP.txt",sep="/")
act_data <- read.table(act_file,header=FALSE)
tdata=cbind(item_data,act_data)
colnames(tdata) <- c('sED','lED','sid','wid','Eact','Ract')
tdata$sid <- as.factor(tdata$sid)
ttdata <- subset(tdata,sid!=11 & sid!=28)

subhip_file <- paste(basedir,"pattern/ROI_based/ref_space/me/act_DG.txt",sep="/")
subhip_data <- read.table(subhip_file,header=FALSE)

data_all=cbind(ttdata,subhip_data)
colnames(data_all) <- c('sED','lED','sid','wid','Eact','Ract','sidH','widH','HEact','HRact')
data_all$sid <- as.factor(data_all$sid)
data_all$wid <- as.factor(data_all$wid)
data_all$rt <- data_all$sED-data_all$lED
subdata <- data_all

rt_Eact <- lmer(rt~HEact+(1+HEact|sid),REML=FALSE,data=subdata)
rt_Eact.null <- lmer(rt~1+(1+HEact|sid),REML=FALSE,data=subdata)
rt_Ract <- lmer(rt~HRact+(1+HRact|sid),REML=FALSE,data=subdata)
rt_Ract.null <- lmer(rt~1+(1+HRact|sid),REML=FALSE,data=subdata)

mainEffect.rt_Eact <- anova(rt_Eact,rt_Eact.null)
r.itemInfo[1,1]=mainEffect.rt_Eact[2,6]
r.itemInfo[1,2]=mainEffect.rt_Eact[2,7]
r.itemInfo[1,3]=mainEffect.rt_Eact[2,8]
r.itemInfo[1,4]=fixef(rt_Eact)[2];

mainEffect.rt_Ract <- anova(rt_Ract,rt_Ract.null)
r.itemInfo[2,1]=mainEffect.rt_Ract[2,6]
r.itemInfo[2,2]=mainEffect.rt_Ract[2,7]
r.itemInfo[2,3]=mainEffect.rt_Ract[2,8]
r.itemInfo[2,4]=fixef(rt_Ract)[2];

write.matrix(r.itemInfo,file="itemInfso_LHIP_DG.txt",sep="\t")
