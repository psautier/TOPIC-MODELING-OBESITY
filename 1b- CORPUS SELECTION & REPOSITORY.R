
## CORPUS SELECTION

select.corpus="corpus.O"
corpus=get(select.corpus)


## ABSTRACTS & TITLES EXTRACTION

extraction=read.csv2("primary data/extraction_obes_20150220.csv", stringsAsFactors=F, colClasses=c(rep("character",5)))
data=merge(corpus, extraction, by="CLEUT", all.x=T)


## CONCATENATION TITLE+ABSTRACT

abstracts=data[which(data$RESUME!=""),]
nrow(abstracts) # 55,668 publications with abstract

for (i in 1:dim(abstracts)[1]){
  print(paste0("processing doc n°",i," over ",dim(abstracts)[1]))
  abstracts$text[i]=paste0(c(abstracts$TITRE[i], abstracts$RESUME[i]), collapse=" ")}


## SAVE FILE

filename=paste("CORPUS", substr(select.corpus, 8, nchar(select.corpus)))
dir.create(filename, showWarnings = TRUE)
save(abstracts, file=paste0(filename,"/abstracts"))
