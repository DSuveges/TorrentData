# This script visualizes the genre distribution of music genres

# Version: 1.5. Last modified: 2014.06.16
    # creates 1x3 horizontal barplot.
    # no error handling
    # Saves pdf or prints to the default printer... maybe not good.
    # filename can be specified

# Input:
    # dataframe, assuming that the colors are assigned to the rows
    # assuming that the rows are sorted according to the first variable and the value


triple_barplot <- function(
    genre_df,
    filename="Allgenres_barplot.pdf") # Filename of the output pdf
    {
    
    # saving pdf:
    # pdf(filename, height=9, width=9)
    
    # initializing the plot arae:
    par(mfrow=c(1,3), oma=c(0,9,2,2), mar=c(4,0,1,0), mgp=c(2, 0.7, 0))
        
    ###########
    # PLOT 1 - the number of torrents:
    max1 = max(genre_df$Count, na.rm=T)*1.1
    barplot(
        genre_df$Count, 
        names.arg=genre_df$genres,    
        col=genre_df$colors,
        las = 1,
        horiz = T,
        space = 0,
        cex.names = 1,
        xlim = c(0, max1),
        xlab = "Number of torrents",
    )
    
    # Adding boxes to all categories at the same time:
    rect(
        c(rep(-10,5)),
        c(0,7,11,26,33),
        c(rep(max1,5)),
        c(7,11,26,33,42), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25), # Rock - Brown
            rgb(0.7450980,0.6117647,0.9176471,0.25),   # Hip-hop - Magentha
            rgb(0.3607843,0.7450980,0.4901961,0.25),   # Other - Green
            rgb(0.9333333,0.5607843,0.6705882,0.25),   # Pop - Pink
            rgb(0.0000000,0.7372549,0.8235294,0.25))   # Electronic - cyan
    )
    
    # Adding the text to the plot
    TextPos = max1*0.6
    text( TextPos,4,  paste(floor(sum(genre_df[ genre_df$categories == "Electronic","Count"])), " torrents"), cex=1.5)
    text( TextPos,9,  paste(floor(sum(genre_df[ genre_df$categories == "Hip-hop","Count"])), " torrents"), cex=1.5)
    text( TextPos,24, paste(floor(sum(genre_df[ genre_df$categories == "Other","Count"])), " torrents"), cex=1.5)
    text( TextPos,29, paste(floor(sum(genre_df[ genre_df$categories == "Pop","Count"])), " torrents"),cex=1.5)
    text( TextPos,38, paste(floor(sum(genre_df[ genre_df$categories == "rock","Count"])), " torrents"),cex = 1.5)
    
    ###########
    # PLOT 2 - the number of downloads:
    par( mar=c(4,1,1,0), xpd=NA)
    par(xpd=NA)
    cat(par()$xpd)
    max2 = max(genre_df$Downloads, na.rm=T)*1.1
    barplot(genre_df$Downloads,    
            col=genre_df$colors,
            las = 1,
            horiz = T,
            space = 0,
            xlab = "Number of downloads",
            xlim = c(0,max2)
    )
    
    text(43, "Distribution of torrents and downloads as a function of genre:", adj=0.5 ,cex=2)
    
    
    # Adding boxes to all categories at the same time:
    rect(
        c(rep(-10,5)),
        c(0,7,11,26,33),
        c(rep(max2,5)),
        c(7,11,26,33,42), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25),   # Rock - Brown
              rgb(0.7450980,0.6117647,0.9176471,0.25),   # Hip-hop - Magentha
              rgb(0.3607843,0.7450980,0.4901961,0.25),   # Other - Green
              rgb(0.9333333,0.5607843,0.6705882,0.25),   # Pop - Pink
              rgb(0.0000000,0.7372549,0.8235294,0.25))   # Electronic - cyan
    )
    
    # Adding the text to the plot
    TextPos = max2 *0.6
    text( TextPos,4,  paste(floor(sum(genre_df[ genre_df$categories == "Electronic","Downloads"])), " downloads"), cex=1.5)
    text( TextPos,9,  paste(floor(sum(genre_df[ genre_df$categories == "Hip-hop","Downloads"])), " downloads"), cex=1.5)
    text( TextPos,24, paste(floor(sum(genre_df[ genre_df$categories == "Other","Downloads"])), " downloads"), cex=1.5)
    text( TextPos,29, paste(floor(sum(genre_df[ genre_df$categories == "Pop","Downloads"])), " downloads"),cex=1.5)
    text( TextPos,38, paste(floor(sum(genre_df[ genre_df$categories == "rock","Downloads"])), " downloads"),cex = 1.5)
    
    
    ###########
    # PLOT 3 - the popularity of different genres:
    par( mar=c(4,1,1,0))
    max3 <- max(genre_df$averageDownloads, na.rm=T)*1.1
    barplot(genre_df$averageDownloads,    
            col=genre_df$colors,
            las = 1,
            horiz = T,
            space = 0,
            xlab = "Average download number",
            xlim= c(1,max3),
    )
    
    # Adding boxes to all categories at the same time:
    rect(
        c(rep(-10,5)),
        c(0,7,11,26,33),
        c(rep(max3,5)),
        c(7,11,26,33,42), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25),    # Rock - Brown
              rgb(0.7450980,0.6117647,0.9176471,0.25),    # Hip-hop - Magentha
              rgb(0.3607843,0.7450980,0.4901961,0.25),    # Other - Green
              rgb(0.9333333,0.5607843,0.6705882,0.25),    # Pop - Pink
              rgb(0.0000000,0.7372549,0.8235294,0.25))    # Electronic - cyan
    )
    
    # Adding the text to the plot
    TextPos <- max3 *0.6
    text( TextPos,4,  paste("Electronic"), cex=2)
    text( TextPos,9,  paste("Hip-hop"),    cex=2)
    text( TextPos,24, paste("Other"),      cex=2)
    text( TextPos,29, paste("Pop"),        cex=2)
    text( TextPos,38, paste("Rock"),       cex=2)
    
    # Closing printer:
    # dev.off()
}