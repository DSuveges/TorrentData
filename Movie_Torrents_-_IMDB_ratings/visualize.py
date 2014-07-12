# -*- coding: utf-8 -*-
"""
Created on Fri Jul  4 20:14:40 2014

@author: daniel
"""

# importing libraries:
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import mpld3
from mpld3 import plugins
from pandas import read_csv

# Open csv that has the imdb dataset and download numbers:
df = read_csv("/Users/daniel/Documents/Programming/Github/TorrentData/Movie_Torrents_-_IMDB_ratings/Torrent_with_IMDB_dataset.csv")

# Removing movies that has no IMDB rating or valid download number:
df2 = df[np.isfinite(df['Ratings'])]
df2 = df2[np.isfinite(df2['Downloads'])]
df2 = df2.reset_index()

# css defining table with movie details:
css = """
table
{
  border-collapse: collapse;
}
th
{
  color: #ffffff;
  background-color: #000000;
  box-shadow: 2px 2px 2px #999;
}
td
{
  background-color: #cccccc;
  box-shadow: 2px 2px 2px #999;
}
th:first-child {
    border-radius: 6px 0 0 0;
}

th:last-child {
    border-radius: 0 6px 0 0;
}

th:only-child{
    border-radius: 6px 6px 0 0;
}
.alternate {
    background: #f5f5f5; 
    box-shadow: 0 1px 0 rgba(255,255,255,.8) inset;        
}
"""
# Initializing plot:
# N = len(df2["Ratings"])
N = 10000
fig, ax = plt.subplots()

# Generating labels:
labels = []
for i in range(N):
    label = u'<table>\n  <tr>\n    <th colspan="2">{0}</th>\n  </tr>\n  <tr>\n    <td>Relesases:</td>\n    <td>{1}</td>\n  </tr>\n  <tr>\n    <td>Downloads:</td>\n    <td>{2}</td>\n  </tr>\n  <tr>\n    <td>IMDB rating:</td>\n    <td>{3}</td>\n  </tr>\n</table>'.format(
        df2["Titles"][i], df2["Counts"][i], df2["Downloads"][i], df2["Ratings"][i])
    labels.append(label)
    
# Plotting:
points = ax.plot(df2["Ratings"][0:N], df2["Downloads"][0:N], 'o', color='b',
                 mec='k', ms=5, mew=1, alpha=.6)

ax.set_xlabel('IMDB ratings')
ax.set_ylabel('Number of downloads')
ax.set_title('nCore movie downloads vs IMDB ratings', size=20)

tooltip = plugins.PointHTMLTooltip(points[0], labels,
                                   voffset=10, hoffset=10, css=css)
plugins.connect(fig, tooltip)

mpld3.show()


# gropuping df2 based on imdb ratings
grouped = df2.groupby("Ratings")