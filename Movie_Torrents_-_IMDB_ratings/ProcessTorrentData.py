# -*- coding: utf-8 -*-
"""
Created on Tue Jul  1 00:27:35 2014

@author: daniel
"""

from   datetime import datetime
import pandas   as pd
import csv
import numpy    as np
import getIMDB
import re
import sys
    

# Opening csv file with the torrent datasheet
filename = "movies_0626.csv"
f        = open(filename, "rb")
reader   = csv.reader(f)

# Values that I am interested in
Torrent_ID   = [] # torrent IDs
Downloads    = [] # Download number
IMDB_ID      = [] # IMDB ID

# Compiling regular expression to capture IMDB codes:
p = re.compile('tt\d+')

# Selecting only the date and rating fields. If they are in the proper format
for row in reader:

    Torrent_ID.append(row[0])      # Torrent identifier as string
    Downloads.append(int(row[5]))  # Number of downloads as integers
    
    if row[4] == "NA":
        IMDB_ID.append("NA")
    else:
        IMDB_code = p.findall(row[4])
        try:
            IMDB_ID.append(IMDB_code[0]) # processing 
        except:
            print("Problem with IMDB identifier:",row[4])
            IMDB_ID.append("NA")


f.close()

# Combining data into a dictionary
data = {
    "Torrent_ID"  : Torrent_ID,
    "Downloads"   : Downloads,
    "IMDB_ID"     : IMDB_ID
}


# Build dataframe from the dict.
df = pd.DataFrame(data) # Number of entries: 67593 

# Removing duplicates:
df = df.drop_duplicates(take_last=True) # Number of entries: 66864

# How many torrent has no IMDB IDs?
df_noNA = df[df['IMDB_ID'].isin("")]

# OK, I have to loop through the array to remove NA-s from the series: (# of torrents with IMDB IDs: 62327)
IMDB_noNAs = []
for i in IMDB_ID:
    if i != "NA":
        IMDB_noNAs.append(i)
    
# Get a list of unique imdb IDs: (# of unique IMDB IDs: 24881)
IMDB_ID_set = set(IMDB_noNAs)
IMDB_ID_set = list(IMDB_ID_set)

# OK, looping through the IMDB set, collecting download and torrent data:
Downloads = map(lambda x: sum(df[df["IMDB_ID"] == str(x)]["Downloads"]), IMDB_ID_set)  # Pooling download numbers
Torrents  = map(lambda x: len(df[df["IMDB_ID"] == str(x)]["Downloads"]), IMDB_ID_set)  # Pooling torrent numbers belonging to one IMDB code
Titles    = []
Ratings   = []
Budget    = []
Countries = []
index     = 0

# Getting the IMDB inforamtions:
for i in IMDB_ID_set[11134:]:
    print "processing: "+str(index)+" movie"
    values = IMDB_parse(i)
    Titles.append(values[0])
    Ratings.append(values[1])
    Budget.append(values[2])    
    Countries.append(values[3])
    index += 1
    
    
# Testing downloaded data:
print(len(IMDB_ID_set),
len(Titles),
len(Ratings),
len(Budget),
len(Countries))
    
# Combinding downloaded data into single dataframe
data = {
    "IMDB_ID"     : IMDB_ID_set,
    "Downloads"   : Downloads,
    "Counts"      : Torrents,
    "Titles"      : Titles,
    "Ratings"     : Ratings,
    "Budget"      : Budget,
    "Countries"   : Countries
}

IMDB_df = pd.DataFrame(data) # Number of entries:

# Saving datafile into csv file:  
IMDB_df.to_csv("Torrent_with_IMDB_dataset.csv", encoding='utf-8')

