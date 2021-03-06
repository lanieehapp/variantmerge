# Base Image
FROM r-base:4.0.2

# Maintainer
MAINTAINER DaveLab <lab.dave@gmail.com>

# update the OS related packages
RUN apt-get update -y && apt-get install -y \
    build-essential \
    vim \
    less \
    gawk \
    git \
    libcurl4-gnutls-dev \
    libxml2-dev \
    libssl-dev \
    wget \
    bedtools \
    parallel \
    unzip \
    cmake \
    libxml2-dev  	
# install Python libraries
WORKDIR /usr/local/bin

#install R packages
RUN R --vanilla -e 'install.packages(c("optparse"), repos="http://cran.us.r-project.org")'


# clone variantmerge repo
ADD https://api.github.com/repos/lanieehapp/variantmerge/git/refs/heads/ version.json
RUN git clone https://github.com/lanieehapp/variantmerge.git

# add variantmerge repo to SYSPATH
ENV PATH variantmerge:$PATH

# change the permission of the repo
RUN chmod 777 -R variantmerge
WORKDIR /usr/local/bin/variantmerge
