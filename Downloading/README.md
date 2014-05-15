# Torrent download data analysis


The data analysis porject starts with the data collection. For this a series of Perl scripts were written. Besided the main script the frequently repeated tasks were separated into Perl packages. The output data is organized into a csv file, where each value is a separate variable, and each lines are separate torrent file. 

### List of files:
* **WgetNcore.pm** - manages authentication and downloads files from the torrent tracker. Downloads list pages and pages of individual torrents. 
* **ListNavigator.pm** - methods that parse downloaded html files with torrent list.
* **ParseTorrentData.pm** - methods to extract data from the individual torrent data sheets
* **TorrentInfoDownload.pl** - Main program.


