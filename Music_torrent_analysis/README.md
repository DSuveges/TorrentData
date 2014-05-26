Analysis of music torrents
===========

## Motivation

In this analysis I was originally interested in the characterization of the user preferences of a Hungarian torrent community. In this section I want to show if users are significantly biased based on the nationality of the music they download. It is often considered to be a big problem that the presence of international (mostly American) music is so overwhelming, that Hungarians are no longer interested in the national musicians' art.

However I used Perl to download torrent data, I decided to do the analysis in R/RStudio as it made the analyis much more easier and gave a excellent opportunity to familiarize myself with this language.

## The data:

To download music torrent data form the the torrent tracker we used the download Perl script listed in the Download folder with the following query parameters: ``. The saved csv file contain the following variables for each torrents:

* **ID** - Identifier of the torrent
* **Name** - Name of the music
* **U_time** - upload time
* **U_date** - upload date
* **Downloads** - Number of downloads
* **Leechers** - Number of leechers
* **Seeders** - Number of seeders
* **Nationality** - Nationality of the music, has two values: *HU*: Hungarian and *EN*: international (mainly english/american) music
* **genre** - The genre of the music

## The analysis

### Loading the data

Once we have the data saved in the csv file, we can read it with the following R code, and keep it in the memory for all downstream analysis.

```R
setwd("Documents/Programming/ncore_analysis/music/")
TorrentData <- read.csv("torrent_data.csv")

# cleaning data from non-defined values:
TorrentData$TorrentID <- as.numeric(TorrentData$TorrentID)
TorrentData           <- TorrentData[!is.na(TorrentData$Downloaded),]
TorrentData           <- TorrentData[!is.na(TorrentData$Nationality),]

```

### Exploratory analysis

To take a look at the dataset I was working with:
```R
> nrow(TorrentData)
[1] 57160
```
As the focus of this analysis will be on the number of downlads, nationality and the upload date, a new restricted dataset was created:

```R
SubsetTable             <- TorrentData[, c("U_Date", "Downloaded", "Nationality")]
SubsetTable$U_Date      <- as.Date(SubsetTable$U_Date)
SubsetTable$Downloaded  <- as.numeric(as.character(SubsetTable$Downloaded))
SubsetTable$Nationality <- factor(SubsetTable$Nationality)

# A small script, to generate a summary table ready to paste into github markdown:
SumTable <- function(df, fact, value){

    # Check if the given names are exists:
    if ((fact  %in% names(df)) == F){stop("Error:" ,fact, " named column does not exist in the provided dataframe!\nAvailable colum names: ", colnames(df))}
    if ((value %in% names(df)) == F){stop("Error:" ,value, " named column does not exist in the provided dataframe!\nAvailable colum names: ", colnames(df))}
    if (class(fact) != "factor"){stop("Error: The provided column is not a real factor!")}

    # If everything lok ok, we can start to print out the table
    cat("| Factor | Number of torrents | Number of Downloads | Average Download | Median Download |\n|:--:|:--:|:--:|:--:|:--:|\n")

    factorlist <- names(table(df[,fact]))

    for (i in factorlist){
        Newlist <- df[df[,fact]==i,value] # Get the number of downloads corresponding to the given factor
        NoTorrents <- length(Newlist)     # Get number of torrent in the selection
        Downloads  <- sum(Newlist)        # Get total number of download of the selection
        AverageDl  <- Downloads / NoTorrents  # Calculate the average download number
        MedDl      <- median(Newlist)     # Median download number
        cat("| ",i, " | ", NoTorrents, " | ", Downloads, " | ", AverageDl, " | ", MedDl, " | \n")
    }
}

```

`> SumTable(SubsetTable, "Nationality", "Downloaded")`

| Factor | Number of torrents | Number of Downloads | Average Download | Median Download |
|--:|:--:|:--:|:--:|:--:|
|  EN  |  47521  |  14926189  |  314.0967  |  89  |
|  HU  |  9636  |  13256411  |  1375.717  |  689  |


### Distribution of downloads



### Nationality based separation of the torrents



###
