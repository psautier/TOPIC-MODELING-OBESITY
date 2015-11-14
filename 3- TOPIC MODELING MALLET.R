
## EFFACE TOUS LES ELEMENTS EXISTANTS

rm(list=ls(all=TRUE))


###############################################################
#                                                             #
#      LIRE NOTICE POUR UTILISER MALLET A PARTIR DE R         #
#                                                             #
###############################################################


## CORPUS SELECTION

corpus="CORPUS O"


## NOMBRE DE TOPICS

ntopics <- 20


## REPERTOIRE (à l'endroit où a été installé mallet-2.0.7)

setwd("~/mallet")
dir=getwd()


# configure variables and filenames for MALLET
## here using MALLET's built-in example data and
## variables from http://programminghistorian.org/lessons/topic-modeling-and-mallet

# folder containing txt files for MALLET to work on
importdir <- paste0(dir,"/files_mallet")
# name of file for MALLET to train model on
output <- "tutorial.mallet"
# name of stopwords file
stoplist="stoplist.txt"
# set optimisation interval for MALLET to use
optint <- 20
# set file names for output of model, extensions must be as shown
outputstate <- "topic-state.gz"
outputtopickeys <- "tutorial_keys.txt"
outputdoctopics <- "tutorial_composition.txt"
# combine variables into strings ready for windows command line
cd <- paste0("cd ", dir, "/mallet-2.0.8RC2") # location of the bin directory
import <- paste("bin\\mallet import-dir --input", importdir, "--output", output, "--keep-sequence --remove-stopwords --extra-stopwords", stoplist, sep = " ")
train <- paste("bin\\mallet train-topics --input", output, "--num-topics", ntopics, "--optimize-interval", optint, "--output-state", outputstate, "--output-topic-keys", outputtopickeys, "--output-doc-topics", outputdoctopics, sep = " ")


# setup system enviroment for R
MALLET_HOME <- paste0(dir,"/mallet-2.0.8RC2") # location of the bin directory
Sys.setenv("MALLET_HOME" = MALLET_HOME)
Sys.setenv(PATH = "C:/Program Files (x86)/Java/jre1.8.0_45/bin") # vérifier la version Java et modifier si besoin

# send commands to the Windows command prompt
# watch results scroll by in R console...
shell(shQuote(paste(cd, import, train, sep = " && ")),
      invisible = FALSE)


# inspect results
setwd(MALLET_HOME)
outputtopickeysresult <- read.table(outputtopickeys, header=F, sep="\t")
outputdoctopicsresult <-read.table(outputdoctopics, header=F, sep="\t")
outputstateresult <- read.table(outputstate, header=F, stringsAsFactors=F)


## TRANSFERT DES RESULTATS

dir=paste0("~/TOPIC MODELING OBESITY/", corpus, "/outputs mallet")
dir.create(dir, showWarnings = TRUE)
dir2=paste0(dir,"/", ntopics, " topics")
dir.create(dir2, showWarnings = TRUE)

save(outputtopickeysresult, file=paste0(dir2,"/outputtopickeysresult"))
save(outputdoctopicsresult, file=paste0(dir2,"/outputdoctopicsresult"))
save(outputstateresult, file=paste0(dir2,"/outputstateresult"))
