library(RCurl)
library(XML)
library(stringr)
#获取站酷摄影图片
setwd('D:/Rscript')

#定义函数获取连接，返回urls

getPages<-function(){
  #baseurl<-htmlParse(url)
  max_url<-100
  
  add_url<-str_c('http://www.zcool.com.cn/works/33!0!!0!0!200!1!',seq(1,max_url,1),'!!!')
  urls_list<-unlist(as.list(add_url))
  return(urls_list)
}
#定义全局变量，获取数据
zcool_image_list<-c
zcool_image_title<-c

  
for(i in getPages()){
  get_zcool<-getURL(i)
  html_zcool<-htmlParse(get_zcool)  
  image_xpath<-"//ul[@class='layout camWholeBoxUl']/li/a/img/@src"
  zcool_image<-getHTMLLinks(i,xpQuery = image_xpath)
  zcool_title<-xpathSApply(html_zcool,"//ul[@class='layout camWholeBoxUl']/li/div/div/p/a",xmlValue)
  zcool_image_list<-append(zcool_image_list,zcool_image)
  zcool_image_title<-append(zcool_image_title,zcool_title)
}
  zcool_image_list[1]<-NULL
  zcool_image_title[1]<-NULL
  #if you want to create a dataframe,add a for
  #zcool_df<-data.frame(zcool_image_list,zcool_image_title)
  #names(zcool_df)<-c('image_list','image_title')
  #return(zcool_df$image_list)

m<-1
#创建文件夹
dir.create('zcool_floder',showWarnings = FALSE)
for(i in zcool_image_list){
  #使用正则提取文件名
  zcool_image_title[m]<-str_extract(zcool_image_title[m],'[[:alpha:]]+[\u4e00-\u9fa5]+')
  print(i)
  #下载图片，mode为写二进制，以文件名保存
  download.file(i,destfile = str_c('zcool_floder','/',zcool_image_title[m],'.jpg'),quiet=TRUE,mode='wb')
  m<-m+1
}





