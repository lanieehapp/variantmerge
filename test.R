args = commandArgs(trailingOnly=TRUE)

input.dir<-args[[1]]
filt.file.list<-list.files(path=input.dir, pattern="*filt*")

print(filt.file.list)