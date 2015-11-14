
## EFFACE TOUS LES ELEMENTS EXISTANTS

rm(list=ls(all=TRUE))


corpus="CORPUS O"
ntopics=20


## WORKING DIRECTORY

dir=paste0("~/TOPIC MODELING OBESITY/", corpus)
setwd(dir)


lambda=0.6
nb_terms=10


## CHARGEMENT DES DONNEES

load(paste0("~/TOPIC MODELING OBESITY/output data/", substr(corpus,8,nchar(corpus)), ".topic", ntopics, ".terms"))


## DISTRIBUTION DES MOTS DANS LES TOPICS (LOI DE PROBA)

terms.topic=topic.terms[,2:(ntopics+1)]
rownames(terms.topic)=topic.terms$V5
for (i in 1:ntopics){
  terms.topic[,i]=terms.topic[,i]/rep(sum(terms.topic[,i]), dim(terms.topic)[1])
}
colSums(terms.topic)


## TERMES CARACTERISTIQUES DES TOPICS

# Calcul fréquence & relevance
prob.marg=rowSums(topic.terms[,2:(ntopics+1)]) # probabilité marginale de chacun des termes
relevance=lambda*log(terms.topic)+(1-lambda)*log(terms.topic/prob.marg)
frequency=log(terms.topic)

# Création des fichier txt

for(i in 1:ntopics) {
  rel_terms=topic.terms$V5[apply(relevance, 2, order, decreasing=T)[1:nb_terms,i]]
  rel_val=sort(relevance[,i], decreasing=T)[1:nb_terms]
  relevant.terms<-cbind(rel_terms,rel_val)
  cat("\n", file=paste0("discriminant-terms-", ntopics, "topics.txt"), append=TRUE)
  write.table(relevant.terms,file=paste0("discriminant-terms-", ntopics, "topics.txt"),row.names=F,col.names=F,append=T,sep="\t")}

for(i in 1:ntopics) {
  top_terms=topic.terms$V5[apply(frequency, 2, order, decreasing=T)[1:nb_terms,i]]
  freq_val=sort(frequency[,i], decreasing=T)[1:nb_terms]
  top.terms<-cbind(top_terms,freq_val)
  cat("\n", file=paste0("frequent-terms-", ntopics, "topics.txt"), append=TRUE)
  write.table(top.terms,file=paste0("frequent-terms-", ntopics, "topics.txt"),row.names=F,col.names=F,append=T,sep="\t")}
