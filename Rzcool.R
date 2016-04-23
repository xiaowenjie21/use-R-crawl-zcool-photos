library(RCurl)
library(XML)
library(stringr)
#获取站酷摄影图片
setwd('D:\\Rscript\\RZcool\\zcool_floder2')

#定义函数获取连接，返回urls

getPages<-function(){
  #baseurl<-htmlParse(url)
  max_url<-30
  
  add_url<-str_c('http://www.zcool.com.cn/works/33!0!!0!0!200!1!',seq(1,max_url,1),'!!!')
  urls_list<-as.list(add_url)
  return(urls_list)
}
#定义全局变量，获取数据
zcool_image_list<-c
zcool_image_title<-c
zcool_item_list<-c

#解析每个列表页  
for(i in getPages()){
  get_zcool<-getURL(i)
  html_zcool<-htmlParse(get_zcool)  
  image_xpath<-"//ul[@class='layout camWholeBoxUl']/li/a/img/@src"
  item_xpath<-"//ul[@class='layout camWholeBoxUl']/li/a/@href"
  zcool_image<-getHTMLLinks(i,xpQuery = image_xpath)
  zcool_title<-xpathSApply(html_zcool,"//ul[@class='layout camWholeBoxUl']/li/div/div/p/a",xmlValue)
  zcool_item<-xpathSApply(html_zcool,"//ul[@class='layout camWholeBoxUl']/li/a",xmlGetAttr,"href")
  zcool_image_list<-append(zcool_image_list,zcool_image)
  zcool_image_title<-append(zcool_image_title,zcool_title)
  zcool_item_list<-append(zcool_item_list,zcool_item)
}
  zcool_image_list[1]<-NULL
  zcool_image_title[1]<-NULL
  zcool_item_list[1]<-NULL
  


  
  #处理详情页面
parse_item<-function(x){
  get_item<-getURL(x)
  get_html_item<-htmlParse(get_item)
  
  #最麻烦的就是文件名的处理,zcool图片文件名包含有很多windows系统不支持的格式
  item_title<-str_trim(xpathSApply(get_html_item,"//h1[@class='workTitle']/text()",xmlValue)[2])
  item_title2<-str_trim(str_replace_all(item_title,'[+*/?"<>|•]',''))
  
  item_image_xpath<-"//div[@class='workShow']/ul/li/div[1]//img/@src"
  item_image<-getHTMLLinks(x,xpQuery = item_image_xpath)
  
  #创建并下载
  if(dir.exists(item_title2)){
    xuhao<-1
    for(item in item_image){
      print(item)
      download.file(item,destfile =str_c(item_title2,'/',xuhao,'.jpg'),quiet = FALSE,mode='wb')
      xuhao<-xuhao+1
    }
    
  }else{
    xuhao<-1
    dir.create(path = item_title2,showWarnings = FALSE)
    for(item in item_image){
      print(item)
      download.file(item,destfile =str_c(item_title2,'/',xuhao,'.jpg'),quiet = FALSE,mode='wb')
      xuhao<-xuhao+1
      print(item_title2)
    }
  }
  
}
  

#下载图片
lapply(zcool_item_list, parse_item)




