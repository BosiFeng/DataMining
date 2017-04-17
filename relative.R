algae<-read.table('horse.txt',header=F,dec='.',col.names=c('season','size','speed','mxPH','mn02','C1','NO3',
                                                           'NH4','oPO4','PO4','Chla','a1','a2','a3','a4','a5',
                                                           'a6','a7','a8','a9','a10','a11','a12','a13','a14',
                                                           'a15','a16','a17'),na.strings=c('?'))
#用数据对象之间的相似性填补
library(DMwR)
algae<-knnImputation(algae,k=7)
#保存结果在data4.txt里面
write.table (algae, file ="data4.txt",row.names =F, col.names =F, quote =TRUE)
