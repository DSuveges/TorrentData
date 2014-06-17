# (C) Daniel Suveges 2014

# In the project I was testing the distribution of downloads of music torrents.
# They appear to be strongly skewed. To make them easier to visualize and model.
# I took the natural logarithm of the download values. I tried if the distribution
# of the log(downloads) follows a normal distribution or not.

# the canvas is divided into three plots
    # 1 - Raw histogram of the downloads + inset
    # 2 - Histogram of the log(downloads)
    # 3 - normal zz plot of the log(downloads)

# Dependencies:
    # Shape
    # TeachingDemos

# Vesrion history:

# v. 2.1 Last modified: 2014.03.18
    # A new function was read to draw nicer arrows
    # So new prerequiset: shapes

# v. 2.0 Last modified: 2014.03.16
    # Log hist implemented
    # zz plot implemented
    # triple plot composition implemented

# V. 1.0 Last modified: 2014.03.15
    # Raw histogram implemented

# First function reads the data and creates the canvas
tripleplot <- function(rawdata, filename="temp.pdf"){
    pdf(filename, height=2.8, width=8.5)
    logdata <- log(rawdata[])
    logdata <- logdata[!is.infinite(logdata)]
    par(mfrow=c(1,3))
    RawHist(rawdata)
    LognormHist(logdata)
    probabplot(logdata)
    dev.off()
}
# PLot one: simple histogram
RawHist <- function(vector){

    # At first let's remove zeroes
    vector <- vector[vector != 0]

    # The raw histogram
    # Create a plot object, to get the data
    retek <- hist(vector, plot=F)
    plot(retek,
        col    = rgb(1,0,0,0.5),
        ylab   = "Number of torrents",
        xlab   = "Number of Downloads",
        main   = "Raw histogram",
        border = "red",
    )

    # Get the min and max values of the histogram:
    xmax = tail(retek$mids,1)
    ymax = retek$counts[1]

    # Drawing the frame
    left_x   = 500 + xmax*0.01
    right_x  = 0 - xmax*0.01
    bottom_y = 0 - ymax*0.02
    upper_y  = ymax * 1.02

    rect(
        left_x,
        bottom_y,
        right_x,
        upper_y,
        border   = "blue",
        lwd      = 2,
        density  = NULL
    )

    # PLotting the inset
    inset_x = xmax - xmax*0.3
    inset_y = ymax - ymax*0.3

    # Drawing the arrrow
    a_x0 = left_x
    a_y0 = inset_y
    a_x1 = xmax * 0.2
    a_y1 = inset_y
    Arrows(
        a_x0,
        a_y0,
        a_x1,
        a_y1,
        col = "blue",
        lwd = 2
    )

    subplot(
        hist(vector,
            xlim     = c(0,500),
            breaks   = 2000,
            xlab     = NULL,
            ylab     = NULL,
            main     = NULL,
            border   = "black",
            col      = rgb(0,0,1,0.5),
            cex.axis = 0.5
        ),
        inset_x,
        inset_y,
        size=c(1,1)
    )

}

# Plot two: lognormal distribution:
LognormHist <- function(vector){
    h <- hist (vector, plot=F)
    plot (
        h,
        main = "Histogram of log values",
        xlab = "log(Number of Dowloads)",
        ylab = "Number of torrents",
        col  = rgb(1,0,0,0.5),
        ylim = c(0,max(h$count)*1.1)
    )

    xfit <- seq(
        min(vector),
        max(vector),
        length=40
    )

    yfit <- dnorm(
        xfit,
        mean=mean(vector),
        sd=sd(vector)
    )

    yfit <- yfit*diff(h$mids[1:2])*length(vector)
    lines(
        xfit,
        yfit,
        col=rgb(0,0,1,0.8),
        lwd=2
    )
    text_x = h$mids[3]
    text_y = 0.9 * max(h$counts)
    mean   = round(mean(vector), digits = 2)
    spread = round(sd(vector), digits = 2)
    text (
        text_x,
        text_y,
        bquote(atop(mu==.(mean),sigma==.(spread))),
        cex = 1,
    )
}

# PLot three: qqplot:
probabplot <- function(vector){

    # To generate ZZ probability plot we need these:
    vectmean <- mean(vector)
    vectsd   <- sd(vector)
    vectz    <- (vector - vectmean)/vectsd

    # qqnorm plot
    qqnorm(vectz,
       ylab = "Sample Z values",
       xlab = "Theoretical Z values",
       main = "Normal QQ plot of log(Download)",
       col  = rgb(0,0,1,0.5),
       cex  = 0.5,
    )

    # Adding x=y to the plot
    curve(1*x,
        col = rgb(1,0,0,,0.5),
        add = T,
        lwd = 1
    )
}
