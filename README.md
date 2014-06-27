TorrentData
===========

As the broadband internet penetration is almost complete in most developed countries; the access to digital media reshaped both the music and the movie industry. In rich countries like in the US, there is a developed culture to buy or rent these contents, but other countries like the Eastern European, post communist countries both the financial state and the infrastructure of the digital media markets don't allow such a behavior.

In these countries the main source of digital media is through illegal sources like bittorrent. As the bittorrent protocol applies a central tracker that logs various statistics of all torrent files, it provides an exceptional opportunity to study the media consumption habits of the users. Luckily, besides the biggest, international, open access torrent sites like pirate bay, there are smaller trackers whose user population is narrower, more defined. In my study I was using the data of the biggest Hungarian torrent site [ncore](ncore.cc). This is an 'invitation-only' site so the users are exclusively Hungarians, analysing the data of this site, we could learn interesting trends of the media consumption of a wide population of Hungarians, that potentially can be generalize to similar countries.

## The data

The administrators of the site refused to provide the data directly, but allowed to parse the html files and collect all information I need for the analysis. For this purpose, I have written a series of Perl scripts that managed authentication, downloaded and parsed the html files of the torrents, and saved the data.

On the following image a randomly selected torrent page can be seen, with all the collected information marked.
![A datasheet of a random music torrent](http://kepfeltoltes.hu/140526/torrentdata_www.kepfeltoltes.hu_.jpg)
The following information was saved in a csv file: torrent ID, the name of the torrent, the upload date and time, the number of how many times the torrent was downloaded, how many user is currently seeding and leeching the torrent, the genre and the nationality and the type (for movies, the IMDB identifier also saved if it was available). I'm freely providing a modified dataset that does not have the titles to avoid copyright issues.


## Folders:

* **Torrent_download:** the series of perls scripts and packages that I used to scrape torrent datasheets. See link for more information about the methods.

* **Music_torrent_analysis:** The data analysis of the music torrents. In the case of these torrents I was focusing on the differences in the download preferences between Hungarian and international music. And the user preferences for different genres.

* **Movies:** The anaysis of movie torrents are still under development. I'm planning to


