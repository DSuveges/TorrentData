# (C) Daniel Suveges
# Coursera course: Data Analysis and Statistical Inference

# In the project I was testing the distribution of downloads of music torrents. 

# Both the Hungarian and the English log(download) values show a nice normal
# distribution, but to make it easier to compare, I normalized the high of the peaks

# Dependencies:
    # Shapes

# Vesrion history:
# v. 1.0 Last modified: 2014.03.18
    # read two vectors, normalize them, polt them.
    # the fitted areaplot is also plotted 
    # The main measures of the distributions are also there
    # An arrow is presented there 


PlotDualHist <- function (vector1, vector2, filename="temp.png"){
    
    # removing NA-s
    vector1 <- vector1[!is.infinite(vector1)]
    vector2 <- vector2[!is.infinite(vector2)]
    
    
    # Let's draw the first distribution:
    list  <- NiceHist(vector1)
    y1    <- list$y_values
    x1    <- list$x_values
    yfit1 <- list$yfit
    xfit1 <- list$xfit

    # Let's draw the second distribution:
    list  <- NiceHist(vector2)
    y2    <- list$y_values
    x2    <- list$x_values
    yfit2 <- list$yfit
    xfit2 <- list$xfit
    
    # A little trick to make the plotted area nicer:
    xfit2[1] <- 0
    yfit2[1] <- 0
    xfit1[1] <- 0
    yfit1[1] <- 0    
    
    # Open output
    pdf(filename, height=5, width=6)
    
    # plot first distribution:
    plot(x1, y1, 
        ylim=c(0,1.2), 
        xlim=c(0,10),
        col = "red",
        ylab= "Normalized frequency",
        xlab= "log(Number of downloads)",
        main= NULL
    )
    polygon(xfit1, yfit1, col=rgb(1,0,0,0.3), border=rgb(1,0,0,0.3))
    
    # plot second distribution:
    par(new = TRUE)
    plot(x2, y2,  ylim=c(0,1.2), xlim=c(0,10),xlab='',ylab='',col="blue", axes=F)
    polygon(xfit2, yfit2, col=rgb(0,0,1,0.3), border=rgb(0,0,1,0.3))
    
    # Drawing the arrow
    fromx <- xfit1[which.max(yfit1)]
    fromy <- max(yfit1) + 0.1
    tox   <- xfit2[which.max(yfit2)]
    Arrows(fromx, fromy, tox-0.25, fromy,lwd=2)
    lines(c(fromx,fromx),c(0,fromy), lty=3, lwd=2)
    lines(c(tox,tox),c(0,fromy), lty=3, lwd=2)
    
    # Adding some text:
    mean   <- round(mean(vector1),2)
    spread <- round(sd(vector1),2)
    text (
        fromx - 2,
        fromy - 0.1,
        bquote(atop("All music",atop(mu==.(mean),sigma==.(spread)))),
        cex = 1,
        col ="red"
    )
    mean   <- round(mean(vector2),2)
    spread <- round(sd(vector2),2)
    text (
        tox + 2,
        fromy-0.1,
        bquote(atop("Hungarian", atop(mu==.(mean),sigma==.(spread)))),
        cex = 1,
        col ="blue"
    )
    
    # closing output
    dev.off()
}

NiceHist <- function(vector){
    
    # Steps:
    # 1) calculate distributions
    # 2) calculate covering curve
    # 3) Scale down covering curve and the distribution itself
    
    # STEP1 - Calculation of the distribution
    h        <- hist(vector, plot = F, breaks = 25)
    y_values <- h$counts
    x_values <- h$breaks[1:length(h$counts)]+0.25
    
    # STEP2 - Calculation of the covering curve:
    xfit     <- seq(min(vector),max(vector),length=40) 
    yfit     <- dnorm(xfit,mean=mean(vector),sd=sd(vector)) 
    yfit     <- yfit*diff(h$mids[1:2])*length(vector)
    maxy     <- max(yfit)
    
    # Scaling down the covering curve and the distribution itself
    yfit     <- yfit / maxy
    y_values <- y_values / maxy
    
    # returning variables:
    returnvalues <- list(
        "y_values" = y_values, 
        "x_values" = x_values, 
        "yfit"     = yfit, 
        "xfit"     = xfit)
    return(returnvalues)
    
}