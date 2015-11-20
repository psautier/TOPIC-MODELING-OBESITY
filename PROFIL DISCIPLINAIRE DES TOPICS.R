
rm(list=ls(all=TRUE))


## PARAMETERS

corpus="CORPUS O"
ntopics=20
nivdisc="LIB_GRDE_DISC"
#nivdisc="LIB_DISCIPLINE"


## REPERTOIRE

setwd("~/TOPIC MODELING OBESITY")

source("auxfunctions.R")


## MATRICE TOPICS-DISCIPLINES

# matrice docs.disciplines
categories=read.csv2("primary data/extraction_obes_20150316.csv", stringsAsFactors=F, colClasses=c(rep("character",9)))
length(unique(categories$CLEUT)) # WoS categories for 287,341 publications (over 306,918)
# on supprime les doublons liés aux autres niveaux de discipline
datadisc=unique(categories[,c("CLEUT", nivdisc)])
docs.disc=table(datadisc$CLEUT, datadisc[,nivdisc]) # en compte de présence
docs.disc.frac=docs.disc/rowSums(docs.disc) # en compte fractionnaire

# matrice topics.docs
load(paste0("output data/", substr(corpus, 8, nchar(corpus)), ".topics", ntopics, ".docs")) # chargement de topics.docs
# on ne garder que les docs pour lesquelles on connait la catégorie WoS
interdocs=intersect(rownames(docs.disc.frac), rownames(topics.docs))
topics.docs=topics.docs[interdocs,]
topics.docs=t(topics.docs)
docs.disc.frac=docs.disc.frac[interdocs,]

# vérification
stopifnot(!is.null(rownames(docs.disc.frac)))
stopifnot(!is.null(colnames(topics.docs)))
stopifnot(rownames(docs.disc.frac) == colnames(topics.docs))


# Graphiques

mycolors = sample(mapColors(1:ncol(docs.disc.frac)))

while(length(dev.list()) > 0) {
  dev.off()
}


topics.docs.sav = topics.docs
MAX = apply(topics.docs, 2, max) # proportion max pour chaque doc
avMax = mean(MAX)
WMAX = apply(topics.docs, 2, which.max) # topic max pour chaque doc

pdf(paste0("profil disciplinaire des ", ntopics, " topics par ", nivdisc,".pdf"), paper="a4r", width=11, height=9)


# pour ne pas surcharger le graphique, seuls les barplots des disciplines les plus importantes dans le corpus sont affichées
# on affiche les 11 grandes disciplines
if(nivdisc=="LIB_GRDE_DISC"){
  nb=ncol(docs.disc.frac)
}
# on affiche seulement les disciplines ayant un poids moyen d'au moins 1% dans le corpus
if(nivdisc=="LIB_DISCIPLINE"){
  nb=length(which(apply(docs.disc.frac, 2, mean)>0.01))
}

# barplot des disciplines
par(mar=c(10,5,5,3))
barplot(sort(apply(docs.disc.frac, 2, mean)*100, decreasing=T)[1:nb], 
        main=paste0(nivdisc, " selon l'importance dans le corpus (en %)"), 
        las=2, cex.names=0.8)


for (v in c(-1,2)) {
  cat(v, "\n")
  
  if (v == -1) {
    mytitle = paste0("version originale: p(t|doc)")
  } 
  #else {
  # mytitle = paste0("v", v)
  if (v == 0) {
    mytitle = paste0("v0: attribution intégrale du doc à son topic majoritaire")
  }
  
  if (v == 1) {
    mytitle = paste0("v1: attribution partielle du doc à son topic majoritaire")
  }
  if (v == 2) {
    mytitle = paste0("v2: attribution intégrale avec seuil 80%")
  }
  if (v == 3) {
    mytitle = paste0("v3: attribution partielle avec seuil 80%")
  }
  
  
  topics.docs = topics.docs.sav
  
  if (v >= 0) {
    for (i in 1:nrow(topics.docs)) {
      topics.docs[i,] = ifelse(i == WMAX, topics.docs[i,], 0)
    }
    if (v == 2 || v == 3) {
      topics.docs[ topics.docs < 0.8] = 0
    }
    if (v == 0 || v == 2) {
      topics.docs = 1 * (topics.docs > 0)
    }
  }
  
  # produit des deux matrices
  topics.disc = topics.docs %*% docs.disc.frac
  
  # On normalise par topic
  for (i in 1:nrow(topics.disc)) {
    topics.disc[i,] = topics.disc[i,] / sum(topics.disc[i,])
  }
  
  M = topics.disc
  rownames(M) = paste0("T", 1:nrow(M))
  M = M[, order(-apply(docs.disc.frac, 2, mean))]
  
  par(mar=c(10,5,5,3))
  barplot(t(M), col=mycolors, main=mytitle, las=2, cex.names=0.8)
  legend(x=usrFromRelativeX(-0.1), y=usrFromRelativeY(-0.1), xpd=TRUE, legend = colnames(M), fill=mycolors, ncol = 3, cex=0.9, box.lty = 0)
  
}

dev.off()
