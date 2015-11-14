
## EFFACE TOUS LES ELEMENTS EXISTANTS

rm(list=ls(all=TRUE))


corpus="CORPUS O"
ntopics=20


## WORKING DIRECTORY

dir=paste0("~/TOPIC MODELING OBESITY/", corpus)
setwd(dir)


library(XLConnect)


## CREATION DES FICHIERS EXCEL TOP TERMS ET RELEVANT TERMS A PARTIR DES FICHIERS TXT


for (critere in c("frequent", "discriminant")) {
  
  
  allLines = readLines(paste0(critere, "-terms-", ntopics, "topics.txt"))
  if (allLines[[1]] == "") {
    allLines = allLines[-1]
  }
  N = min(which(allLines == "")) - 1
  stopifnot(allLines[seq(N+1, length(allLines), by=N+1)] == "")
  outfile = paste0(critere, "-terms-", ntopics, "topics.xls")
  if (file.exists(outfile)) file.remove(outfile)
  wb = loadWorkbook(outfile, create = TRUE)
  createSheet(wb,paste0(critere,"-terms"))
  setColumnWidth(wb, 1, 1:10, 4000)
  styleTitre = createCellStyle(wb)
  setFillPattern(styleTitre, fill = XLC$FILL.SOLID_FOREGROUND)
  setFillForegroundColor(styleTitre, XLC$COLOR.LIGHT_ORANGE)
  a = 1
  k = 0
  while (a < length(allLines)) {
    b = a + N - 1
    parts = strsplit(allLines[a:b], split = "\\s+")
    terms = sapply(parts, function(x) x[[1]])
    terms = substring(terms, 2, nchar(terms)-1)
    df = data.frame(terms=terms)
    colnames(df) = paste0("Topic ", k+1)
    startRow = 1 + floor(k / 10)*(N+1)
    startCol = 1 + (k %% 10)
    writeWorksheet(wb, df, 1, startRow, startCol)
    setCellStyle(wb, sheet=1, row=startRow, col=startCol, cellstyle = styleTitre)
    a = b + 2
    k = k + 1
  }
  saveWorkbook(wb, outfile)
  file.remove(paste0(critere, "-terms-", ntopics, "topics.txt"))
}
