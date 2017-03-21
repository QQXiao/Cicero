#!usr/bin/env Rscript
library(methods)
library(Matrix)
library(MASS)
#library(Rcpp)
library(lme4)
# Read in your data as an R dataframe
basedir <- c("/seastor/helenhelen/Cicero")
resultdir <- paste(basedir,"pattern/ROI_based/ref_space/me/rs",sep="/")
setwd(resultdir)
r.itemInfo <- matrix(data=NA, nr=2, nc=4)
## read data
#get data for each trial
item_file <- paste(basedir,"pattern/ROI_based/ref_space/me/rs_mem_LIFG.txt",sep="/")
item_data <- read.table(item_file,header=FALSE)
act_file <- paste(basedir,"pattern/ROI_based/ref_space/me/act_LIFG.txt",sep="/")
act_data <- read.table(act_file,header=FALSE)
tdata=cbind(item_data,act_data)
colnames(tdata) <- c('rs_wl_wr','rs_bl_wr','rs_wl_br','rs_bl_br','sid','wid','Eact','Ract')
tdata$sid <- as.factor(tdata$sid)
ttdata <- subset(tdata,sid!=11 & sid!=28)


subhip_file <- paste(basedir,"pattern/ROI_based/ref_space/me/act_DG.txt",sep="/")
subhip_data <- read.table(subhip_file,header=FALSE)

data_all=cbind(ttdata,subhip_data)
colnames(data_all) <- c('rs_wl_wr','rs_bl_wr','rs_wl_br','rs_bl_br','sid','wid','Eact','Ract','sidH','widH','HEact','HRact')
data_all$sid <- as.factor(data_all$sid)
data_all$wid <- as.factor(data_all$wid)
data_all$rs <- data_all$rs_wl_br-data_all$rs_bl_br
subdata <- data_all

rs_Eact <- lmer(rs~HEact+(1+HEact|sid),REML=FALSE,data=subdata)
rs_Eact.null <- lmer(rs~1+(1+HEact|sid),REML=FALSE,data=subdata)
rs_Ract <- lmer(rs~HRact+(1+HRact|sid),REML=FALSE,data=subdata)
rs_Ract.null <- lmer(rs~1+(1+HRact|sid),REML=FALSE,data=subdata)

mainEffect.rs_Eact <- anova(rs_Eact,rs_Eact.null)
r.itemInfo[1,1]=mainEffect.rs_Eact[2,6]
r.itemInfo[1,2]=mainEffect.rs_Eact[2,7]
r.itemInfo[1,3]=mainEffect.rs_Eact[2,8]
r.itemInfo[1,4]=fixef(rs_Eact)[2];

mainEffect.rs_Ract <- anova(rs_Ract,rs_Ract.null)
r.itemInfo[2,1]=mainEffect.rs_Ract[2,6]
r.itemInfo[2,2]=mainEffect.rs_Ract[2,7]
r.itemInfo[2,3]=mainEffect.rs_Ract[2,8]
r.itemInfo[2,4]=fixef(rs_Ract)[2];

write.matrix(r.itemInfo,file="itemInfso_LIFG_DG.txt",sep="\t")
