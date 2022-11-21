library(ggplot2)
library(rlang)
HMI56_1 <- read.csv("HMI56_000608.csv", row.names=NULL)
HMI56_1
Fig1 <-ggplot(HMI56_1, aes(x=HMI56_1$Phase, y=HMI56_1$RelExpr, col=HMI56_1$Phase))+ 
  geom_point(size=3, alpha=0.5)+ #get all data points to show but make them transparent 
  stat_summary(fun.y=mean,geom="point", size=4)+ #plot the mean
  stat_summary(fun.data = mean_se,geom = "errorbar", size=0.5, #plot the standard error
               alpha=0.7,position = position_dodge(0.01))+
  theme_bw() + #make black and white
  ylab("HMI56_000608 RelExpr") +  #change yaxis label
  theme(legend.position = "bottom", #put legend under graph
        legend.title = element_blank(), #remove legend titles
        text = element_text(size=18),
        axis.title.x=element_blank(), #remove Plot title
        axis.text.y = element_text(size=18, angle=45,hjust=0.5),
        axis.text.x = element_text(size=18, angle=45, hjust=1))   
Fig1

HMI56_2 <- read.csv("HMI56_001592.csv", row.names=NULL)
HMI56_2
Fig2 <-ggplot(HMI56_2, aes(x=HMI56_2$Phase, y=HMI56_2$RelExpr, col=HMI56_2$Phase))+ 
  geom_point(size=3, alpha=0.5)+ #get all data points to show but make them transparent 
  stat_summary(fun.y=mean,geom="point", size=4)+ #plot the mean
  stat_summary(fun.data = mean_se,geom = "errorbar", size=0.5, #plot the standard error
               alpha=0.7,position = position_dodge(0.01))+
  theme_bw() + #make black and white
  ylab("HMI56_001592 RelExpr") +  #change yaxis label
  theme(legend.position = "bottom", #put legend under graph
        legend.title = element_blank(), #remove legend titles
        text = element_text(size=18),
        axis.title.x=element_blank(), #remove Plot title
        axis.text.y = element_text(size=18, angle=45,hjust=0.5),
        axis.text.x = element_text(size=18, angle=45, hjust=1))   
Fig2

HMI56_3 <- read.csv("HMI56_006544.csv", row.names=NULL)
HMI56_3
Fig3 <-ggplot(HMI56_3, aes(x=HMI56_3$Phase, y=HMI56_3$RelExpr, col=HMI56_3$Phase))+ 
  geom_point(size=3, alpha=0.5)+ #get all data points to show but make them transparent 
  stat_summary(fun.y=mean,geom="point", size=4)+ #plot the mean
  stat_summary(fun.data = mean_se,geom = "errorbar", size=0.5, #plot the standard error
               alpha=0.7,position = position_dodge(0.01))+
  theme_bw() + #make black and white
  ylab("HMI56_006544 RelExpr") +  #change yaxis label
  theme(legend.position = "bottom", #put legend under graph
        legend.title = element_blank(), #remove legend titles
        text = element_text(size=18),
        axis.title.x=element_blank(), #remove Plot title
        axis.text.y = element_text(size=18, angle=45,hjust=0.5),
        axis.text.x = element_text(size=18, angle=45, hjust=1))   
Fig3

HMI56_4 <- read.csv("HMI56_007461.csv", row.names=NULL)
HMI56_4
Fig4 <-ggplot(HMI56_4, aes(x=HMI56_4$Phase, y=HMI56_4$RelExpr, col=HMI56_4$Phase))+ 
  geom_point(size=3, alpha=0.5)+ #get all data points to show but make them transparent 
  stat_summary(fun.y=mean,geom="point", size=4)+ #plot the mean
  stat_summary(fun.data = mean_se,geom = "errorbar", size=0.5, #plot the standard error
               alpha=0.7,position = position_dodge(0.01))+
  theme_bw() + #make black and white
  ylab("HMI56_007461 RelExpr") +  #change yaxis label
  theme(legend.position = "bottom", #put legend under graph
        legend.title = element_blank(), #remove legend titles
        text = element_text(size=18),
        axis.title.x=element_blank(), #remove Plot title
        axis.text.y = element_text(size=18, angle=45,hjust=0.5),
        axis.text.x = element_text(size=18, angle=45, hjust=1))   
Fig4

library(cowplot)
plot_grid(Fig1, Fig2, Fig3, Fig4, labels = "AUTO")
