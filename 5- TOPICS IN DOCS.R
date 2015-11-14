
## EFFACE TOUS LES ELEMENTS EXISTANTS

rm(list=ls(all=TRUE))


corpus="CORPUS O"
ntopics=20


## WORKING DIRECTORY

dir="~/TOPIC MODELING OBESITY/"
setwd(dir)


## OUTPUT MALLET DE LA REPARTITION DES TOPICS DANS LES DOCS

outputdoctopicsresult <-read.table(paste0(dir, corpus, "/outputs mallet/", ntopics, " topics/tutorial_composition.txt"), header=F, sep="\t")


## CONSTRUCTION DE LA MATRICE TOPICS-DOCS

k=ntopics

topics.docs=NULL
for (l in 0:(k-1)) {
  print(paste0("Traitement du topic ",l+1," sur ",k))
  x=NULL
  for (j in 1:dim(outputdoctopicsresult)[1]) {
    for (i in seq(3, 2*k+1, by=2)){
      if (outputdoctopicsresult[j,i]==l) x[j]=outputdoctopicsresult[j,i+1]
    }}
  topics.docs=cbind(topics.docs,x)
}

nbcharV2=unique(nchar(as.character(outputdoctopicsresult$V2)))
stopifnot(length(nbcharV2)==1)
rownames(topics.docs)=substr(outputdoctopicsresult$V2,nbcharV2-18,nbcharV2-4)
colnames(topics.docs)=c(paste0(rep("Topic."), seq(1:dim(topics.docs)[2])))

save(topics.docs, file=paste0("output data/", substr(corpus,8,nchar(corpus)),".topics", ntopics, ".docs"))
