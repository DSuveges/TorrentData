Ncore music genre analysis
========================================================

## Motivation

Earlier this year I saw an excellent google [visualization](http://research.google.com/bigpicture/music/) showing which music genres are still popular from a given date. That graph shows that the poularity of modern rock is shrinking. In a way this is not surprising, as today there are so many different genres for a very diverse audience, so unlike many blogs and sites commenting on that graph, I am not pessimistic about the future of rock. Time will tell which of today's music deserves to have future...

But on the other hand, I started to wonder what users on the biggest Hungarian torrent site are listening. What genres do they prefer? In this project, I analized the distribution of genres and the number of downloads of different genres. The task was difficult, as the genre field of the torrent data sheet is not strictly defined, it is up to the user to fill that field upon uploading, or even they can omit at all. This yield an extremely diverse set of variable with over 2200 separate values.

**The analysis can be divided into the following steps:**

1. **Parse genre data:** during the torrent data sheet processing, the genre information is stored in one field of a csv file, where each genre is separated by an underscore. In this step, the torrent data file is read by a Perl script, that separates the genre fields (as more genres can be associated to one music torrent), and saves it paired with the torrent ID in a new csv file.
2. **Clean genre list:**  the originally assigned genres form a very heterogenous list with arbitrary definitions and typos. In this step, I define a smaller genre set that covers as many music files as possible.
3. **Summarizing genre data:** the number of torrent files and downloads are summarized over the associated genres. In the resulted table each row represents one genre.
4. **Visualization and discussion:** I was interested in how the number of torrents and downloads distributed among genres and genre categories. For the visualization I chose _treemap_ that is especially good to get a qualitative idea about the distribution of hierachical categories, and _barchart_ that allows a more quantitative insight with a much better resolution. With these methods we can point out genres that are more frequently uploaded and those that are more frequently downloaded.

### Step 1. Reading and separating genre information:

Upon downloading the torrent datasheet, every piece of information is saved into a csv file, where each line corresponds to one torrent ID. As potentially multiple genres can be associated to one torrent ID, genres are fused together with underscores to keep all genres in a single field of the csv sheet.

In the first step, the genre field of the csv file had to be separated into individual genres. As this process was really slow with R, I decided to use Perl. The suitable script saved each genre with the corresponding torrent ID into a new csv file, that could be read by R directly as a dataframe. The following example shows how this script worked:

**input:**<br \>
>1488270,5,1,2014-02-10,21:53:02,12,MP3,EN,house_dance_electronic<br \>

**output:**<br \>
>1488270,house <br \>
>1488270,dance <br \>
>1488270,electronic <br \>

```R
# call Perl script, save csv
system("perl Genre_reader.pl torrent_data_NoTitle.csv")

# Reading csv file:
raw_genres <- read.csv("genres_raw.csv", header=T)

AssignedGenres        <- nrow(raw_genres)
raw_genre_difinitions <- length(table(raw_genres$Genre))
TorrentNumber         <- length(table(raw_genres$TorrentID))
UnAssignedTorrents    <- nrow(raw_genres[ raw_genres$Genre == "Na",])
UnAssignedRatio       <- round(100* UnAssignedTorrents / length(table(raw_genres$TorrentID)),2)

cat("Number of torrent files:", TorrentNumber,
    "\nNumber of assigned genres:", AssignedGenres,
    "\nNumber of different genre definitions:", raw_genre_difinitions,
    "\nNumber of torrents without genre definition:", UnAssignedTorrents, "(", UnAssignedRatio, "% of the total torrent population)\n")
```
**Output:**
> Number of torrent files: 70282
> Number of assigned genres: 142248
> Number of different genre definitions: 2279
> Number of torrents without genre definition: 2684 ( 3.82 % of the total torrent population)

Based on the generated report, users assigned over 140 thousand genres to 70 thousand uploaded music, and only 4% of the music had no genre assigned. The variability of the genre definitions is unimaginable: more than 2200 definitions were used!

### Step 2. Cleaning genre list

To make the genre definition list more concise, with the combination of Perl scripts and R commands, I constructed a genre mask set to fix the most frequently made typo-s and inconsistent defintions. In this process, I selected the first 100 most commonly used genres and manually processed them to get rid of non-meaningful words and typos. I also pooled closely related genres like "nordic metal" and "viking metal". Then I repeated this process where newer and newer definitions come up to the top 100.

#### Step 2/a: the most frequently used 100 genres

The most frequently used 100 genres cover 86% of the total torrent population while 

To characterize the homogeneity and representativeness of the initial definition set, I calculated the ratio of torrents represented by the most frequently used 100 genres.
