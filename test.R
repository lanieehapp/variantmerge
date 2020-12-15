library("optparse")

option_list = list(
  make_option(c("-f", "--filt"), type="character", default=NULL)
)


opt_parser=OptionParser(option_list=option_list)
opt=parse_args(opt_parser)


print(opt)