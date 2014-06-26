# Collection of functions for half-life determination:

# Calculation of how the ratio of the torrents decrease over time
# input table: 2D data frame with the Torrent ID and the upload date
# Window: number of torrents pooled together to get distance and time information
TorrentBin <- function(torrent_table, window=100){
    
    # Setting the first day of the dataset as the last torrent's upload time
    first_day <- torrent_table[1,2]
    
    # Initializing the return table
    test       <- as.integer(nrow(torrent_table)/window)
    TorrentAge <- rep(NA,test)
    Ratio      <- rep(NA,test)
    
    # Taking defined length parts of the torrent table
    for (i in 1:test){
        
        # Taking subsets of the input table (size=window)
        start_position <- i*window
        table_window   <- generate_window(torrent_table, window_length=window, start_position=start_position)
        
        ### Calculating the average age of the torrents in the subset
        TorrentAge[i]  <- get_mean_time(first_day, table_window[,2])
        
        ### Based on the ID difference and the number of torernts within the group the ratio is calculated
        Ratio[i]       <- nrow(table_window)/(table_window[1,1] - table_window[window,1])
        
    }
    
    # The returned data is the dataframe with the paired age and ratio values
    halflife <- data.frame(TorrentAge,Ratio)
    
    return(halflife)
}

# Input is a vector with Date class values
# Function calculates the average time distane of the vector from a given reference
get_mean_time <- function(first_day, vector){
    
    day_dist <- rep(NA, length(vector))
    
    for (i in 1:length(vector)){
        day_dist[i] <- as.numeric(difftime(first_day, vector[i], units="days"))
    }
    day_mean <- mean(day_dist)
    
    return(day_mean)
}


# Calculates the ratio of the living music torrents within the total number of torrents.
# The total number of torrents is estimated by the difference of the first and the last ID of the set
generate_window <- function(torrent_table, window_length=100, start_position=1){
    end_position <- start_position + window_length - 1
    window <- torrent_table[start_position:end_position,]
    return(window)
}


# In same case the outliers could be very difficult to remove and can be a big 
# problem to get-rid of.
remove_outliers <- function(x, na.rm = TRUE, ...) {
    qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)
    H <- 1.5 * IQR(x, na.rm = na.rm)
    y <- x
    y[x < (qnt[1] - H)] <- NA
    y[x > (qnt[2] + H)] <- NA
    y
}