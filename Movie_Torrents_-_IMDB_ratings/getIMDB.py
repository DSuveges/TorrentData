# -*- coding: utf-8 -*-
"""

A script to extract data from IMDB database based IMDB identifier

Steps:
    1) Take imdb id, and download html page
    2) Parse datasheet based with lxml 
    4) Extract information
    5) Format result, return


@author: daniel
"""

from lxml import html   # html files are processed as xml
import requests         # manages remote file access
import datetime         # to format date
import re

# This function downloads pages from IMDB and extracts information based on imdb id submitted to the routine.
def IMDB_parse(ID): 

    # Processing link and download page. Creating xlm tree object
    link           = "http://www.imdb.com/title/" + str(ID)
    response       = requests.get(link)
    brFreePage     = response.text.replace("<br />", "") # all <br /> tags have to be removed!! 
    tree           = html.fromstring(brFreePage)
    
    # Extracting valuable fields from the webpage:
    MovieTitle  = tree.xpath('//title/text()')
    if MovieTitle[0] == '404 Error':
        return(["NaN","NaN","NaN","NaN"])
        
    rating      = tree.xpath('//span[@itemprop="ratingValue"]/text()')
    budget      = tree.xpath('//div[h4="Budget:"]/text()')
    country     = tree.xpath('//div[@class="txt-block"][h4="Country:"]/a/text()')
    
    
    # clearing date:
    
    #releaseDate = releaseDate[0].strip()
    #releaseDate = datetime.datetime.strptime(releaseDate, "%d %B %Y").strftime("%Y-%m-%d")
    
    # Clearing name:
    MovieTitle  = MovieTitle[0][0:-7]
    
    # Clearing rating:
    try:
        rating      = rating[0]
    except:
        rating = "NaN"
    
    # budget data is stored only if it is given in USD:
    try:    
        p = re.compile("\$")
        m = p.search(budget[1])
        if m:
            budget = budget[1].strip()
        
        else:
            budget = "NaN"
    except:
        budget = "NaN"
    # Returning all downloaded stuffs:
    #return([MovieTitle,rating,releaseDate,budget,country])
    return([MovieTitle,float(rating),budget,country])