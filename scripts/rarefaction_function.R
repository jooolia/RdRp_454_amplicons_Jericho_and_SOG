rarefaction <- function (x, subsample = 5, plot = TRUE, color = TRUE, error = FALSE, 
    legend = TRUE, symbol = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
        11, 12, 13, 14, 15, 16, 17, 18)) 
{
    library(vegan)
    x <- as.matrix(x)
    y1 <- apply(x, 1, sum)
    rare.data <- x
    select <- unique(sort(c((apply(x, 1, sum)), (seq(0, (max(y1)), 
        by = subsample)), recursive = TRUE)))
    storesummary.e <- matrix(data = NA, ncol = length(rare.data[, 
        1]), nrow = length(select))
    rownames(storesummary.e) <- c(select)
    colnames(storesummary.e) <- rownames(x)
    storesummary.se <- matrix(data = NA, ncol = length(rare.data[, 
        1]), nrow = length(select))
    rownames(storesummary.se) <- c(select)
    colnames(storesummary.se) <- rownames(x)
    for (i in 1:length(select)) {
        select.c <- select[i]
        foo <- rarefy(x, select.c, se = T)
        storesummary.e[i, ] <- foo[1, ]
        storesummary.se[i, ] <- foo[2, ]
    }
    storesummary.e <- as.data.frame(storesummary.e)
    richness.error <<- storesummary.se
    for (i in 1:(length(storesummary.e))) {
        storesummary.e[, i] <- ifelse(select > sum(x[i, ]), NA, 
            storesummary.e[, i])
    }
    if (plot == TRUE) {
        if (color == TRUE) {
            plot(select, storesummary.e[, 1], xlab = "Individuals in Subsample", 
                xlim = c(0, max(select)), ylim = c(0, 5 + (max(storesummary.e[, 
                  1:(length(storesummary.e))], na.rm = TRUE))), 
                ylab = "Mean Species Richness", pch = 16, col = 2, 
                type = "n")
            for (j in 1:(length(storesummary.e))) {
                points(select, storesummary.e[, j], pch = 16, 
                  col = j + 1, type = "b", lty = 1)
            }
            if (error == TRUE) {
                for (m in 1:(length(storesummary.e))) {
                  segments(select, storesummary.e[, m] + storesummary.se[, 
                    m], select, storesummary.e[, m] - storesummary.se[, 
                    m])
                }
            }
            if (legend == TRUE) {
                legend("bottomright", colnames(storesummary.e), 
                  inset = 0.05, lty = 1, col = 1:length(storesummary.e) + 
                    1, lwd = 2)
            }
        }
        else {
            plot(select, storesummary.e[, 1], xlab = "Individuals in Subsample", 
                xlim = c(0, max(select)), ylim = c(0, 5 + (max(storesummary.e[, 
                  1:(length(storesummary.e))], na.rm = TRUE))), 
                ylab = "Mean Species Richness", pch = 16, col = 2, 
                type = "n")
            for (j in 1:(length(storesummary.e))) {
                points(select, storesummary.e[, j], type = "l", 
                  lty = 1)
            }
            for (k in 1:(length(storesummary.e))) {
                symbol <- ifelse(symbol < length(storesummary.e), 
                  rep(symbol, 2), symbol)
                points(as.numeric(rownames(subset(storesummary.e, 
                  storesummary.e[, k] == max(storesummary.e[, 
                    k], na.rm = TRUE)))), max(storesummary.e[, 
                  k], na.rm = TRUE), pch = symbol[k], cex = 1.5)
            }
            if (error == TRUE) {
                for (m in 1:(length(storesummary.e))) {
                  points(select, storesummary.e[, m] + storesummary.se[, 
                    m], type = "l", lty = 2)
                  points(select, storesummary.e[, m] - storesummary.se[, 
                    m], type = "l", lty = 2)
                }
            }
            k <- 1:(length(storesummary.e))
            if (legend == TRUE) {
                legend("bottomright", colnames(storesummary.e), 
                  pch = symbol[k], inset = 0.05, cex = 1.3)
            }
        }
    }
    print("rarefaction by J. Jacobs, last update April 17, 2009")
    if (error == TRUE) 
        (print("errors around lines are the se of the iterations, not true se of the means"))
    list(richness = storesummary.e, SE = richness.error, subsample = select)
}
