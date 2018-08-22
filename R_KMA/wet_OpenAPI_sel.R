library(XML)
library(rvest)
library(httr)
library(ggmap)

stnm=read.table("LIST_wet.txt",header=F,stringsAsFactors = F)
stday=read.table("DATE_wet.txt",header=F,stringsAsFactors = F)

stcont<-nrow(stnm)
nn<-stcont

for(ii in 1:nn){
  
linecont<-nrow(stday)
n<-linecont

for(i in 1:n){
  url<-paste("http://data.kma.go.kr/apiData/getData?type=xml&dataCd=ASOS&dateCd=HR&startDt=",stday[i,1],"&startHh=00&endDt=",stday[i,1],"&endHh=23&stnIds=",stnm[ii,1],"&schListCnt=100&pageIndex=1&apiKey=VqiOgHQ69nSztT32yg3%2BlWlqKEvWF%2Bx8OKWzhW5N7nVht%2BlraEw4LSVbDodJTs7r")
  url<-gsub(" ","",url)
  print(url)
  Sys.sleep(3)
  
  
  plants <- xmlParse(rawToChar(GET(url)$content))
  
  
  plants.l <- t(xmlToList(plants, simplify = TRUE))
  plcont<-length(plants.l)
  
  #데이터 가져오기
  for(j in 4:plcont){
    c1<-unlist(plants.l[j])
    rns<-names(c1)
    rnsn<-grep('RN',rns)
    rnsn2<-grep('RNUM',rns)
    rnsn3<- 1
    rnsn3<-cbind(rnsn3,grep('TA',rns))
    rnsn3n<-ncol(rnsn3)
    rnsn3n<-as.numeric(rnsn3n)
    c2<-t(c1) 
    
    #기온
    if(rnsn3n > 1){
      if(j<5){
        if(i<2){
          cc<-subset(c2, select=c(TA))
          ctotal<-cc  
        }
        else{
          cc<-subset(c2, select=c(TA))
          ctotal<-rbind(ctotal,cc)
        }
      }
      if(j>=5){
        cc<-subset(c2, select=c(TA))
        ctotal<-rbind(ctotal,cc)
      }
    }
    else{
      if(j<5){
        if(i<2){
          cc<- -999
          ctotal<-cc  
        }
        else{
          cc<- -999
          ctotal<-rbind(ctotal,cc)
        }
      }
      if(j>=5){
        cc<- -999
        ctotal<-rbind(ctotal,cc)
      }
    }
      
    
    #지점
    if(j<5){
      if(i<2){
        cc3<-subset(c2, select=c(STN_NM))
        ctotal3<-cc3  
      }
      else{
        cc3<-subset(c2, select=c(STN_NM))
        ctotal3<-rbind(ctotal3,cc3)
      }
    }
    if(j>=5){
      cc3<-subset(c2, select=c(STN_NM))
      ctotal3<-rbind(ctotal3,cc3)
    }
    
    #강수량
    
    if(rnsn != rnsn2){
      if(j<5){
        if(i<2){
          cc2<-subset(c2, select=c(RN))
          ctotal2<-cc2  
        }
        else{
          cc2<-subset(c2, select=c(RN))
          ctotal2<-rbind(ctotal2,cc2)
        }
      }
      if(j>=5){
        cc2<-subset(c2, select=c(RN))
        ctotal2<-rbind(ctotal2,cc2)
      }
    }
    
    else if(rnsn == rnsn2){
      if(j<5){
        if(i<2){
          cc2<- -999
          ctotal2<-cc2  
        }
        else{
          cc2<- -999
          ctotal2<-rbind(ctotal2,cc2)
        }
      }
      if(j>=5){
        cc2<- -999
        ctotal2<-rbind(ctotal2,cc2)
      }
    }
    
    #지점
    if(j<5){
      if(i<2){
        cc4<-subset(c2, select=c(TM))
        ctotal4<-cc4  
      }
      else{
        cc4<-subset(c2, select=c(TM))
        ctotal4<-rbind(ctotal4,cc4)
      }
    }
    if(j>=5){
      cc4<-subset(c2, select=c(TM))
      ctotal4<-rbind(ctotal4,cc4)
    }
    

  }
  rm(plants)
  rm(plants.l)
  rm(url)
  rm(rnsn)
}
    
    ctotal4cont<-nrow(ctotal4)
    bi <- as.POSIXlt(as.Date(ctotal4[1]))
    x3<-bi$year+1900
    x3<-as.character(x3)
    x4<-as.Date(paste(x3,"0101"),"%Y%m%d")
    
    
    for(b in 1:ctotal4cont){
      ctotal4Date <- as.Date(ctotal4[b])
      ctotal4hr <- substr(ctotal4[b],12,13)
      ctotal4hr <- as.numeric(ctotal4hr)
      jday<-ctotal4Date-x4+1+(ctotal4hr/24)
    if(b==1){
      jdayData<-jday
    }
      else{
        jdayData<-rbind(jdayData,jday)
      }
  }
    
    
    
    totaldata <- ctotal4
    totaldata <- cbind(totaldata,jdayData)
    totaldata <- cbind(totaldata,ctotal)
    totaldata <- cbind(totaldata,ctotal2)
    totaldata <- cbind(totaldata,ctotal3)
    
    colnames(totaldata)=c("DATE","JDAY","TA","RN","ST")
    
    write.csv(totaldata,paste(stnm[ii,1],"Wet_data.csv"),row.names=FALSE,quote=F)
    
    
    
    
    
    }
    
    
    
    
    