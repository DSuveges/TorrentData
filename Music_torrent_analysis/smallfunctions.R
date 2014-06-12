# A small script, to generate a summary table ready to paste into github markdown:
# input:
    # df    - dataframe
    # fact  - one column of the dataframe used as a factor to divide the other column
    # value - name of an other column of the dataframe. With numerical data.

SumTable <- function(df, fact, value){

    # Check if the given names are exists:
    if ((fact  %in% names(df)) == F){stop("Error:" ,fact, " named column does not exist in the provided dataframe!\nAvailable colum names: ", colnames(df))}
    if ((value %in% names(df)) == F){stop("Error:" ,value, " named column does not exist in the provided dataframe!\nAvailable colum names: ", colnames(df))}
    if (class(df[,fact]) != "factor"){stop("Error: The provided column is not a real factor!")}

    # If everything lok ok, we can start to print out the table
    cat("| Factor | Number of torrents | Number of Downloads | Average Download | Median Download |\n|:--:|:--:|:--:|:--:|:--:|\n")

    factorlist <- names(table(df[,fact]))

    for (i in factorlist){
        Newlist <- df[df[,fact]==i,value] # Get the number of downloads corresponding to the given factor
        NoTorrents <- length(Newlist)     # Get number of torrent in the selection
        Downloads  <- sum(Newlist)        # Get total number of download of the selection
        AverageDl  <- Downloads / NoTorrents  # Calculate the average download number
        MedDl      <- median(Newlist)     # Median download number
        cat("| ",i, " | ", NoTorrents, " | ", Downloads, " | ", AverageDl, " | ", MedDl, " | \n")
    }
}


