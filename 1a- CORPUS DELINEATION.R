
## WORKING DIRECTORY

setwd("~/TOPIC MODELING OBESITY")


## IMPORT ORIGINAL DATA

# Ludo's clusters 
clusters=read.csv("primary data/clusters obesity.csv", header=T) 
clusters<-na.omit(clusters) # supprime la dernière ligne qui ne contient que des valeurs manquantes
nrow(clusters)# 8,076 clusters contiennent au moins 1 publication "obesity"

# initial corpus (queries + clusters 10% -- 306918 publications) tagged by source (WoS, MeSH, Ludo's clusters)
library(sas7bdat)
origine=read.sas7bdat("primary data/corpus_global.sas7bdat")
nrow(origine) # 306,918 publications
nrow(origine[origine$tag_wos==1,]) # 135,349 publications in WoS query
nrow(origine[origine$tag_mesh==1,]) # 71,052 publications in MeSH query
nrow(origine[origine$tag_ludo==1,]) # 244,401 publications in Ludo's clusters treshold 10%


## MERGE

data.cluster=merge(origine, clusters, by=c("macro_cluster", "meso_cluster", "micro_cluster"), all.x=T)
min(data.cluster[data.cluster$tag_ludo==1, "pct_obes_wos"]) # threshold is 10%


## DELINEATION

seuil1=0.1
seuil2=0.3
seuil3=0.5
# corpus O : publications from WoS & MeSH queries -- 147,322 pubs
corpus.O=data.cluster[data.cluster$tag_wos==1 | data.cluster$tag_mesh==1,]
# corpus C : corpus O + clusters 10% -- 306,918 pubs
corpus.C=data.cluster[data.cluster$tag_wos==1 | data.cluster$tag_mesh==1 | (data.cluster$tag_ludo==1 & data.cluster$pct_obes_wos>seuil1),]
# corpus S : clusters 30% -- 104,685 pubs
corpus.S=data.cluster[data.cluster$tag_ludo==1 & data.cluster$pct_obes_wos>seuil2,]
# corpus SS : S+O -- 191,715 pubs
corpus.SS=data.cluster[data.cluster$tag_wos==1 | data.cluster$tag_mesh==1 | (data.cluster$tag_ludo==1 & data.cluster$pct_obes_wos>seuil2),]
# corpus XS : clusters 50% -- 56,547 pubs
corpus.XS=data.cluster[data.cluster$tag_ludo==1 & data.cluster$pct_obes_wos>seuil3,]
# corpus XSS : XS+O -- 163,153 pubs
corpus.XSS=data.cluster[data.cluster$tag_wos==1 | data.cluster$tag_mesh==1 | (data.cluster$tag_ludo==1 & data.cluster$pct_obes_wos>seuil3),]
