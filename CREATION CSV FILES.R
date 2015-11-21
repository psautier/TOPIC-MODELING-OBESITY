
rm(list=ls(all=TRUE))


## PARAMETERS

corpus="CORPUS XSS"
ntopics=20


## REPERTOIRE

setwd("~/TOPIC MODELING OBESITY")

filename="output data csv/"
dir.create(filename, showWarnings = TRUE)


##  CREATION CSV

load(paste0("output data/", substr(corpus, 8, nchar(corpus)), ".topics", ntopics, ".docs")) # chargement de topics.docs
write.csv(topics.docs, file=paste0(filename, substr(corpus, 8, nchar(corpus)), ".topics", ntopics, ".docs.csv"))
dim(topics.docs)

load(paste0("output data/", substr(corpus, 8, nchar(corpus)), ".topic", ntopics, ".terms")) # chargement de topic.terms
write.csv(topic.terms, file=paste0(filename, substr(corpus, 8, nchar(corpus)), ".topic", ntopics, ".terms.csv"), row.names=F)
dim(topic.terms)


## LECTURE CSV

options(stringsAsFactors = FALSE)

topics.docs=read.csv(paste0(filename, substr(corpus, 8, nchar(corpus)), ".topics", ntopics, ".docs.csv"), header=T, row.names=1, colClasses=c("character",rep("numeric",ntopics)))
dim(topics.docs)

topic.terms=read.csv(paste0(filename, substr(corpus, 8, nchar(corpus)), ".topic", ntopics, ".terms.csv"), header=T, colClasses=c("character",rep("numeric",ntopics)))
dim(topic.terms)
