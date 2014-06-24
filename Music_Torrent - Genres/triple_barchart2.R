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
    counts,
    downloads,
    average,
    colors,
    genres,
    categories,
    labels = c("Number of torrents", "Number of downloads", "Average downloads"), # Labels on plot
    filename="Allgenres_barplot.pdf") # Filename of the output pdf
    {
    
    # saving pdf:
    # pdf(filename, height=9, width=9)
    
    # initializing the plot arae:
    par(mfrow=c(1,3), oma=c(0,9,2,2), mar=c(4,0,1,0), mgp=c(2, 0.7, 0))
        
    ###########
    # PLOT 1 - the number of torrents:
    barplot(
        counts, 
        names.arg=genres,    
        col=colors,
        las = 1,
        horiz = T,
        space = 0,
        cex.names = 1,
        xlim = c(0,max(counts) * 1.1),
        xlab = labels[1],
    )
}   
    # Adding boxes to all categories at the same time:
    rect(
        c(-10,-10,-10,-10,-10),
        c(0,7,11,25,31),
        c(15500,15500,15500,15500,15500),
        c(7,11,25,31,41), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25), # Rock - Brown
            rgb(0.7450980,0.6117647,0.9176471,0.25),   # Hip-hop - Magentha
            rgb(0.3607843,0.7450980,0.4901961,0.25),   # Other - Green
            rgb(0.9333333,0.5607843,0.6705882,0.25),   # Pop - Pink
            rgb(0.0000000,0.7372549,0.8235294,0.25))   # Electronic - cyan
    )
    
    # Adding the text to the plot
    text( 8000,4,  paste(floor(sum(genre_df[ genre_df$Categories == "electronic","count"])), " torrents"), cex=1.5)
    text( 8000,9,  paste(floor(sum(genre_df[ genre_df$Categories == "hip-hop","count"])), " torrents"), cex=1.5)
    text( 8000,24, paste(floor(sum(genre_df[ genre_df$Categories == "other","count"])), " torrents"), cex=1.5)
    text( 8000,29, paste(floor(sum(genre_df[ genre_df$Categories == "pop","count"])), " torrents"),cex=1.5)
    text( 8000,38, paste(floor(sum(genre_df[ genre_df$Categories == "rock","count"])), " torrents"),cex = 1.5)
    
    ###########
    # PLOT 2 - the number of downloads:
    par( mar=c(4,1,1,0), xpd=NA)
    par(xpd=NA)
    cat(par()$xpd)
    barplot(genre_df$Downloads,    
            col=genre_df$countCol,
            las = 1,
            horiz = T,
            space = 0,
            xlab = labels[2],
            xlim = c(0,4.5e+6)
    )
    
    text(43, "Distribution of torrents and downloads as a function of genre:", adj=0.5 ,cex=2)
    
    
    # Adding boxes to all categories at the same time:
    rect(
        c(-10,-10,-10,-10,-10),
        c(0,7,11,25,31),
        c(4.5e+6,4.5e+6,4.5e+6,4.5e+6,4.5e+6),
        c(7,11,25,31,41), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25),   # Rock - Brown
              rgb(0.7450980,0.6117647,0.9176471,0.25),   # Hip-hop - Magentha
              rgb(0.3607843,0.7450980,0.4901961,0.25),   # Other - Green
              rgb(0.9333333,0.5607843,0.6705882,0.25),   # Pop - Pink
              rgb(0.0000000,0.7372549,0.8235294,0.25))   # Electronic - cyan
    )
    
    # Adding the text to the plot
    text( 3e+6,4,  paste(floor(sum(genre_df[ genre_df$Categories == "electronic","Downloads"])), " downloads"), cex=1.5)
    text( 3e+6,9,  paste(floor(sum(genre_df[ genre_df$Categories == "hip-hop","Downloads"])), " downloads"), cex=1.5)
    text( 3e+6,24, paste(floor(sum(genre_df[ genre_df$Categories == "other","Downloads"])), " downloads"), cex=1.5)
    text( 3e+6,29, paste(floor(sum(genre_df[ genre_df$Categories == "pop","Downloads"])), " downloads"),cex=1.5)
    text( 3e+6,38, paste(floor(sum(genre_df[ genre_df$Categories == "rock","Downloads"])), " downloads"),cex = 1.5)
    
    
    ###########
    # PLOT 3 - the popularity of different genres:
    par( mar=c(4,1,1,0))
    barplot(genre_df[,],    
            col=genre_df$countCol,
            las = 1,
            horiz = T,
            space = 0,
            xlab = labels[3],
            xlim= c(1,2200),
    )
    
    # Adding boxes to all categories at the same time:
    rect(
        c(-10,-10,-10,-10,-10),
        c(0,7,11,25,31),
        c(2200,2200,2200,2200,2200),
        c(7,11,25,31,41), 
        border=F, 
        lwd=2, 
        col=c(rgb(0.7764706,0.6588235,0.3372549,0.25),    # Rock - Brown
              rgb(0.7450980,0.6117647,0.9176471,0.25),    # Hip-hop - Magentha
              rgb(0.3607843,0.7450980,0.4901961,0.25),    # Other - Green
              rgb(0.9333333,0.5607843,0.6705882,0.25),    # Pop - Pink
              rgb(0.0000000,0.7372549,0.8235294,0.25))    # Electronic - cyan
    )
    
    # Adding the text to the plot
    text( 1500,4,  paste("Electronic"), cex=2)
    text( 1500,9,  paste("Hip-hop"),    cex=2)
    text( 1500,24, paste("Other"),      cex=2)
    text( 1500,29, paste("Pop"),        cex=2)
    text( 1500,38, paste("Rock"),       cex=2)
    
    # Closing printer:
    # dev.off()
}