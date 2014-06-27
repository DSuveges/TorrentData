# The collection of half-life calculations:

# Loading data:
TorrentData       <- read.csv("../Music_Torrent - Genres/torrent_data_NoTitle.csv", header=T)

# Preparing international torrents:
ID_time_EN           <- TorrentData[!is.na(TorrentData$Downloaded) & TorrentData$Nationality == "EN", c("TorrentID","U_Date")]
ID_time_EN$U_Date    <- as.Date(ID_time_EN$U_Date)
ID_time_EN$TorrentID <- as.numeric(as.character(ID_time_EN$TorrentID))

# Preparing Hungarian torrents:
ID_time_HU           <- TorrentData[!is.na(TorrentData$Downloaded) & TorrentData$Nationality == "HU", c("TorrentID","U_Date")]
ID_time_HU$U_Date    <- as.Date(ID_time_HU$U_Date)
ID_time_HU$TorrentID <- as.numeric(as.character(ID_time_HU$TorrentID))

# Reading fuction collection designed for this particular task:
source("half-life.R")

# Starting with the international musics:
# binning and calculation of living torrent ratio:
halflife_EN       <- TorrentBin(ID_time_EN, window=500)
halflife_EN       <- halflife_EN[!is.na(halflife_EN$TorrentAge),]
halflife_EN$Ratio <- remove_outliers(halflife_EN$Ratio)
halflife_EN       <- halflife_EN[!is.na(halflife_EN$Ratio),]

# fitting single exponential to the datapoints and calculation of the half-life:
fit_EN            <- nls(halflife_EN$Ratio ~ a * exp(-b * halflife_EN$TorrentAge), data=halflife_EN, start=list(a=0.5, b=-0.001))
res_EN            <- data.frame(halflife_EN$TorrentAge, pred=predict(fit))
decayconst_EN     <- as.numeric(coef(fit_EN)[2])
halflife_value_EN <- round(log(2)/decayconst_EN,0)

# Continuing with Hungarian musics:

# binning and calculation of living torrent ratio:
halflife_HU       <- TorrentBin(ID_time_HU, window=200)
halflife_HU       <- halflife_HU[!is.na(halflife_HU$TorrentAge),]
halflife_HU$Ratio <- remove_outliers(halflife_HU$Ratio)
halflife_HU       <- halflife_HU[!is.na(halflife_HU$Ratio),]


# fitting single exponential to the datapoints and calculation of the half-life:
fit_HU            <- nls(halflife_HU$Ratio ~ a * exp(-b * halflife_HU$TorrentAge), data=halflife_HU, start=list(a=0.01, b=-0.001))
res_HU            <- data.frame(halflife_HU$TorrentAge, pred=predict(fit_HU))
decayconst_HU     <- as.numeric(coef(fit_HU)[2])
halflife_value_HU <- round(log(2)/decayconst_HU,0)





## Ploting:

# Initializing plotting area:
pdf("halflife.pdf", height=5, width=9)
par(mfrow=c(1,2))

# Plotting interantional data
plot(halflife_EN$TorrentAge, halflife_EN$Ratio, 
     main="International music torrents", 
     xlab="Age of torrent [days]", 
     ylab="Ratio of living torrents",
     col=rgb(0,0,1,0.5)
)

# plotting fitted model
points(res_EN[order(halflife_EN$TorrentAge),],
       type='l', 
       lwd=3,
       col=rgb(0,0,1)
)

# Adding hl value to the graph:
text (
    1000,
    0.2,
    #substitute(t[1/2]==t0, list(t0 = halflife_value_EN)),
    (bquote("t"[1/2]~.(paste0('=',halflife_value_EN))~"days")),
    cex = 1.5,
    col ="blue"
)


# Plotting Hungarian data
plot(halflife_HU$TorrentAge, halflife_HU$Ratio, 
     main="Hungarian music torrents", 
     xlab="Age of torrent [days]", 
     ylab="Ratio of living torrents",
     col=rgb(1,0,0,0.5)
)

# plotting fitted model
points(res_HU[order(halflife_HU$TorrentAge),],
       type='l', 
       lwd=3,
       col=rgb(1,0,0)
)

# Adding hl value to the graph:
text (
    1000,
    0.013,
    #substitute(t[1/2]==t0, list(t0 = halflife_value_EN)),
    (bquote("t"[1/2]~.(paste0('=',halflife_value_HU))~"days")),
    cex = 1.5,
    col ="red"
)

dev.off()