# -*- coding: utf-8 -*-
"""
Created on Fri Jul  4 20:14:40 2014

@author: daniel
"""

# For handling dataframes
import matplotlib.pyplot as plt
import pandas as pd
from pandas import read_csv

# For linear regression
import numpy as np
from scipy import stats


# Open csv that has the imdb dataset and download numbers:
df = read_csv("/Users/daniel/Documents/Programming/Github/TorrentData/Movie_Torrents_-_IMDB_ratings/Torrent_with_IMDB_dataset.csv")

# Removing movies that has no IMDB rating or valid download number:
df2 = df[np.isfinite(df['Ratings'])]
df2 = df2[np.isfinite(df2['Downloads'])]
df2 = df2.reset_index()

# gropuping df2 based on imdb ratings
grouped = df2.groupby("Ratings")


#
# Producing scatter plot:
#
fig, ax = plt.subplots()
ax.plot(df2.Ratings, df2.Downloads, 'o', color='b',
                 mec='k', ms=2, mew=1, alpha=.6)

ax.set_xlabel('IMDB ratings', size=15)
ax.set_ylabel('Number of downloads', size=15)
ax.set_title('nCore movie downloads vs IMDB ratings', size=15)
fig.savefig("Static_scatter.png")


#
# Creating historgram 
#
counts  = grouped.sum().Counts
fig, ax = plt.subplots()
ax.plot(counts.index, counts, 'o', color='b',
                 mec='k', ms=5, mew=1, alpha=.6)

ax.set_xlabel('IMDB ratings', size=15)
ax.set_ylabel('Number of Torrents', size=15)
ax.set_title('nCore movie torrents vs IMDB ratings', size=15)
fig.savefig("Torrent_his.png")

#
# Distribution of downloads
#
df_seven = df[df.Ratings >= 7.0 ][df.Ratings <= 7.9]
median_download = df_seven.Downloads.median()
mean_downloads = df_seven.Downloads.mean()
bins     = np.linspace(df_seven.Downloads.min(), df_seven.Downloads.max(), 100)
groups   = df_seven.groupby(np.digitize(df_seven.Downloads, bins))
hist     = groups.sum()

fig, ax = plt.subplots()
ax.plot(groups.mean().Downloads, hist.Counts, '-', color='b',
                 mec='k', ms=5, mew=5, alpha=.6, linewidth=3.0)

ax.set_xlabel('Number of downloads', size=15)
ax.set_ylabel('Number of Torrents', size=15)
ax.set_title('Distribution of downloads', size=15)
fig.savefig("Download_hist.png")


#
# plot median download number:
#
medians = grouped.median()
medians = medians[1.5:8.4] # Getting rid of outliers

# Fitting linear:
slope, intercept, r_value, p_value, std_err = stats.linregress(medians.index, medians["Downloads"])
line = slope*medians.index+intercept

# Fitting medians and the fitted linears
fig, ax = plt.subplots()
ax.plot(medians.index, medians["Downloads"], 'o', color='b',
                 mec='k', ms=5, mew=1, alpha=.6)
ax.plot(medians.index, line, lw = 2, color='r')

ax.set_xlabel('IMDB ratings', size=15)
ax.set_ylabel('Median of number of downloads', size=15)
ax.set_title('nCore movie downloads vs IMDB ratings', size=15)
fig.savefig("median_fitted.png")

#
# Plotting residuals:
#
residuals = medians["Downloads"] - line

fig, ax = plt.subplots()
ax.plot(medians.index, residuals, 'o', color='b',
                 mec='k', ms=5, mew=1, alpha=.6)
ax.plot([1,9],[0,0],'r-',lw=2)

ax.set_xlabel('IMDB ratings', size=15)
ax.set_ylabel('Residuals', size=15)
fig.savefig("Residuals.png")

import sys
egg_path = '/Library/Python/2.7/site-packages/scikits.bootstrap-0.3.1-py2.7.egg'
sys.path.append(egg_path)
import scikits.bootstrap as boot

temp = df2[df2.Ratings == 6.2].Downloads
result = boot.ci(temp.Downloads, np.median)

# Calcaultion of the error of the median:
# Actually these are the confidence intervals.
grouped_Dl = grouped["Downloads"]
errors = {}
for name, group in grouped_Dl:
    print str(name)+" "+str(len(group))    
    if len(group) > 1 and name > 6.1:
            group = group[np.isreal(group)]
            error = boot.ci(group, np.median)
            errors[str(name)] = error
            print str(name)+" "+str(error)