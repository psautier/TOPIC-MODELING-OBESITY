
## EFFACE TOUS LES ELEMENTS EXISTANTS

rm(list=ls(all=TRUE))


corpus="CORPUS O"
ntopics=20


## WORKING DIRECTORY

dir=paste0("~/TOPIC MODELING OBESITY")
setwd(dir)


## READ DATA

outputstateresult <- read.table(paste0(corpus, "/outputs mallet/", ntopics, " topics/topic-state.gz"), header=F, stringsAsFactors=F)


## NOMBRE D'OCCURENCES DE CHAQUE TERME PAR TOPIC

library(plyr)
topic.terms=count(outputstateresult, c("V4", "V5", "V6"))
library(reshape)
topic.terms <- cast(topic.terms, V5~V6, sum)

filename="output data"
dir.create(filename, showWarnings = TRUE)
save(topic.terms, file=paste0(filename, "/", substr(corpus,8,nchar(corpus)), ".topic", ntopics, ".terms"))
