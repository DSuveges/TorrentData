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
SubsetTable             <- SubsetTable[SubsetTable$Nationality == 'EN' | SubsetTable$Nationality == 'HU',]
SubsetTable$Nationality <- factor(SubsetTable$Nationality)

```

`> SumTable(SubsetTable, "Nationality", "Downloaded") # Function is in the smallfunctions.R source file`

| Factor | Number of torrents | Number of Downloads | Average Download | Median Download |
|--:|:--:|:--:|:--:|:--:|
|  EN  |  47521  |  14926189  |  314.0967  |  89  |
|  HU  |  9636  |  13256411  |  1375.717  |  689  |


### Distribution of downloads

As the table shows, the distribution of the downloads are extremely right-skewed, with a few very popular music and a lot of others with only a few downloads. This is exactly what we see on the boxplot:

![Boxplot](http://www.kephost.com/images/2014/05/26/NatBoxplot.png)

To test if the distribution of the number of downloads follows a lognormal distribution I have checked if the distribution of the logarithm of the downloads follows normal distribution using a normal QQ probability plot.

For international music torrents:

For Hungarian music torrents:

As clearly visible, Hungarian torrents are far more popular than international. 


### Nationality based separation of the torrents



###
