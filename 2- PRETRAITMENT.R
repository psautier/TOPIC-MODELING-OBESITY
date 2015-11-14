
rm(list=ls(all=TRUE))


## CORPUS SELECTION

corpus="CORPUS O"


## WORKING DIRECTORY

setwd(paste0("~/TOPIC MODELING OBESITY/", corpus))


## LOAD DATA

load("abstracts")


## PRETRAITMENT

# remove punctuation
# on remplace les éléments de ponctuation par un blanc
# donc les "-" => "text-mining" devient 2 mots "text" et "mining"
abstracts$text=gsub("[[:punct:]]+", " ", abstracts$text)

# suppression des nombres isolés (ceux qui ne font pas partie d'un mot)
# donc on supprime les dates telles que "2010"
# mais on garde les acronymes tels que "H5N1"
#abstracts$text <- gsub('\\s*(?<!\\B|-)\\d+(?!\\B|-)\\s*', " ", abstracts$text, perl=TRUE)

# remove all alphanumeric characters
abstracts$text=gsub("\\d", " ", abstracts$text)

# suppression des mots de longueur <=2
abstracts$text <- gsub("\\b[a-zA-Z0-9]{1,2}\\b", " ", abstracts$text) # replace words shorter than 3



# TRAITEMENT SUPPLEMETAIRE AVEC LE PACKAGE "tm"

library(tm)

# build a corpus, which is a collection of text documents
# VectorSource specifies that the source is character vectors
abstracts$text <- Corpus(VectorSource(abstracts$text))

# removing numbers
#abstracts$text=tm_map(abstracts$text, removeNumbers)

# changing letters to lower case
abstracts$text <- tm_map(abstracts$text, content_transformer(tolower))

# remove stopwords
abstracts$text <- tm_map(abstracts$text, removeWords, c(stopwords("english")))

# strip extra whitespace from a text document
# multiple white space characters are collapsed to a single blank
abstracts$text <- tm_map(abstracts$text, stripWhitespace)  



## AJOUT DES TERMES PEU FREQUENTS AUX STOPWORDS

DTM <- DocumentTermMatrix(abstracts$text, control=list(
  weighting=weightTf, # term frequency weighting
  minWordLength=1,
  stemming=F,        
  stopwords=F,        # déjà effectué à l'étape précédente
  removeNumbers=F,    # déjà effectué à l'étape précédente
  removePunctuation=F # déjà effectué à l'étape précédente
))
DTM # documents: documents: 287428, terms: 193598
length(DTM$i) # 26016177 mots au total


library(slam)
stopwords.supp=names(which(col_sums(DTM>0)<=100))
write.table(stopwords.supp, file="stoplist.txt",quote=F, sep=" ", row.names=F, col.names=F) 


## GENERATION DES FICHIERS POUR MALLET

filename="files_mallet"
dir.create(filename, showWarnings = TRUE)

abstracts$text<-data.frame(text=unlist(sapply(abstracts$text, '[', "content")), stringsAsFactors=F)

for(i in 1:dim(abstracts)[1]){
  print(paste0("écriture du fichier n°", i, " sur ", dim(abstracts)[1]))
  write.table(abstracts$text[i,], file=paste0(filename, "/", abstracts$CLEUT[i],'.txt'), row.names=F, col.names=F, append=F)
}
