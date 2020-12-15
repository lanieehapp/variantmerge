
#multisample variant calling merger


args = commandArgs(trailingOnly=TRUE)

input.dir<-args[[1]]

filt.file.list<-list.files(path=input.dir, pattern="*filt*")
print(filt.file.list)
#wl.file.list<-args[[2]]


for( i in 1:length(filt.file.list)){
  print(i)
  curr.samp<-read.table(paste0("/data/",filt.file.list[i]), header=TRUE, sep="\t")
  
  #### FOR TESTING PURPOSES ONLY ####
  curr.samp<-cbind(curr.samp[,1:200], curr.samp[,207])
  colnames(curr.samp[201])<-"Sample_ID"
  ###################################
  
    
  #long form - just concatenate all rows, each row represents one sample-variant pair
  if(!(exists("long.form"))){
    long.form<-curr.samp
  }  
  if(exists("long.form")){
    long.form<-rbind(long.form, curr.samp)
  }
  
  #wide form - merge variants - each row represents one variants and each sample has their own columns (nCallers, AF, depth)
  if(!(exists("wide.form.fixed"))){
    
    wide.form.fixed<-curr.samp[,1:139]
    samp<-cbind(curr.samp$CHROM_POS_REF_ALT, curr.samp[,grepl("nCallers|afMax|dpMax", colnames(curr.samp))])
    id<-curr.samp$Sample_ID[1]
    
    colnames(samp)[1]<-"CHROM_POS_REF_ALT"
    colnames(samp)[2:4]<-paste(id, colnames(samp[,2:4]))
    
    wide.form.samp<-samp
  }  
  if(exists("wide.form.fixed")){
    
    fixed<-curr.samp[,1:139]
    samp<-cbind(curr.samp$CHROM_POS_REF_ALT, curr.samp[,grepl("nCallers|afMax|dpMax", colnames(curr.samp))])
    id<-curr.samp$Sample_ID[1]
    
    colnames(samp)[1]<-"CHROM_POS_REF_ALT"
    colnames(samp)[2:4]<-paste(id, colnames(samp[,2:4]))
    
    wide.form.fixed<-unique(rbind(wide.form.fixed, fixed))
   
    wide.form.samp<-merge(x=wide.form.samp, y=samp, by="CHROM_POS_REF_ALT", all.x=TRUE, all.y=TRUE)

  }
  
}

wide.form.fixed<-wide.form.fixed[order(wide.form.fixed$CHROM_POS_REF_ALT),]
wide.form.samp<-wide.form.samp[order(wide.form.samp$CHROM_POS_REF_ALT),]

wide.form<-merge(x=wide.form.fixed, y=wide.form.samp, by="CHROM_POS_REF_ALT")

write.table(long.form, file=args[2], row.names = FALSE, quote = FALSE, sep="\t")
write.table(wide.form, file=args[3], row.names = FALSE, quote = FALSE, sep="\t")


