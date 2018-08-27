library(XML)
library(rvest)
library(httr)
library(ggmap)


stionnum=read.csv("STNUM.txt",header=F,stringsAsFactors = F)
rf<-c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)


aa<-Sys.Date()
bb<-as.integer(aa)
cc<-bb-1
dd<-as.Date(cc,origin="1970-01-01")
ddd<-format(dd,"%Y%m%d")
aaa<-format(aa,"%Y%m%d")



linecont<-nrow(stionnum)
sn<-linecont

for(j in 1:sn){

for (i in 1:1){




url<-paste("http://opendata.kwater.or.kr/openapi-data/service/pubd/dam/sluicePresentCondition/hour/list?damcode=",stionnum[j,1],"&stdt=",ddd,"&eddt=",ddd,"&numOfRows=99&pageNo=1&ServiceKey=xcipP6iDVOmrjwn0NzrEoOr5Z%2BPYZXWIrdbsTJ3fDwkzUggZ24yV7P2Tu2enu%2BPz8Om7YAyk2S%2FUOR5KRo4uiw%3D%3D")
url<-gsub(" ","",url)
print(url)
Sys.sleep(1)


tryCatch(plants <- xmlParse(url),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)
tryCatch(xmlRoot(plants),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)

tryCatch(df<-xmlToDataFrame(getNodeSet(plants,"//item")),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)
if(errorn>1){
  for(errorp in 1:999){
    url<-paste("http://opendata.kwater.or.kr/openapi-data/service/pubd/dam/sluicePresentCondition/hour/list?damcode=",stionnum[j,1],"&stdt=",ddd,"&eddt=",ddd,"&numOfRows=99&pageNo=1&ServiceKey=xcipP6iDVOmrjwn0NzrEoOr5Z%2BPYZXWIrdbsTJ3fDwkzUggZ24yV7P2Tu2enu%2BPz8Om7YAyk2S%2FUOR5KRo4uiw%3D%3D")
    url<-gsub(" ","",url)
    print(url)
    Sys.sleep(1)
    
    
    tryCatch(plants <- xmlParse(url),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)
    tryCatch(xmlRoot(plants),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)
    tryCatch(df<-xmlToDataFrame(getNodeSet(plants,"//item")),error = function(e) errorn<-2, warnig = function(w) print("I am warning"), finally = errorn<-0)
    if(errorn<1){break;}
  }
}
print('ok')
yline<-ncol(df)
if(yline<7){
  df <- cbind(df[,c(1:3)],rf,df[,c(4:6)])
}
else{
  
}

if(i==1){
  dfa<-df
}
else{
  dfa<-rbind(dfa,df)
  
}
rm(url)
rm(plants)
rm(df)
}
  

  linecont<-nrow(dfa)
  dfan<-linecont
  
  dateorigin<-dfa[,3]

  datemonth<-substr(dateorigin,1,2)
  dateday<-substr(dateorigin,4,5)
  datehr<-substr(dateorigin,7,8)
  
  datetotal<-datemonth
  datetotal<-cbind(datetotal,dateday,datehr)
  
  
  jdaybaseyr<-substr(ddd,1,4)
  jdaybase<-paste(jdaybaseyr,"-01-01")
  jdaybase<-gsub(" ","",jdaybase)
  jdaybase2<-as.Date(jdaybase)
  jdaybase2n<-as.numeric(jdaybase2)
  
  for(k in 1:dfan){
    if(k==1){
      datadateo<-paste(jdaybaseyr,"-",datemonth[k],"-",dateday[k])
      datadateo<-gsub(" ","",datadateo)
      datadate<-datadateo
    }
    else{
      datadateo<-paste(jdaybaseyr,"-",datemonth[k],"-",dateday[k])
      datadateo<-gsub(" ","",datadateo)
      datadate<-rbind(datadate,datadateo)
    }
  }
  
  for(kk in 1:dfan){
    datadatei<-as.Date(datadate[kk])
    datehr1<-as.numeric(datehr[kk])
    date11<-as.numeric(datadatei)
    
    jday <-datadatei-jdaybase2+1+(datehr1/24)

    if(kk==1){
      jdaytotal<-jday
    }
    else{
      jdaytotal<-rbind(jdaytotal,jday)
    }
    
  }
  
  inflowqy<-gsub(",","",dfa$inflowqy)
  rsvwtqy<-gsub(",","",dfa$rsvwtqy)
  totdcwtrqy<-gsub(",","",dfa$totdcwtrqy)
  rsvwtrt<-gsub(",","",dfa$rsvwtrt)
  dfa<-cbind(inflowqy,dfa[,c(2:4)],rsvwtqy,totdcwtrqy,rsvwtrt)
  
  totaldata<-jdaytotal
  totaldata<-cbind(totaldata,dfa)
  colnames(totaldata)=c("JDAY","inflowqy","lowlevel","obsrdt","fr","rsvwtqy","rsvwtrt","totdcwtrqy")
  
  
  savefile<-paste(jdaybaseyr,"/",ddd,"/",stionnum[j,1],"_",stionnum[j,2],"_",ddd,".csv")
  savefile<-gsub(" ","",savefile)
  write.csv(totaldata,savefile,row.names=FALSE,quote=F)
  

}

for(fi in 1:sn){
  openfile_name<-paste(jdaybaseyr,"/total/",stionnum[fi,1],"_",stionnum[fi,2],".csv")
  openfile_name<-gsub(" ","",openfile_name)
  ttotaldata=read.csv(openfile_name,header=T,stringsAsFactors = F)  
  ttotaldata<-rbind(ttotaldata,totaldata)
  write.csv(ttotaldata,openfile_name,row.names=FALSE,quote=F)
  
  
}









