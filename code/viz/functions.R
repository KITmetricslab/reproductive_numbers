# plotting function for reproductive numbers:
# Arguments:
# data_to_plot: the data.frame containing all required data
# data_version: data version / time at which estimates were generated
# interval: show uncertainty intervals as shaded areas (if available)
# add: add to existing plot?
# col: colour
plot_R <- function(data_to_plot, model, data_version, interval = TRUE, add = FALSE, col = "black", ...){
  # subset to relevant rows:
  subs <- data_to_plot[data_to_plot$model == model &
                         data_to_plot$data_version == data_version &
                         !is.na(data_to_plot$value), ]
  # initialize plot if desired:
  if(add == FALSE){
    plot(subs$date, subs$value, type = "l", col = NA,
         xlim = c(as.Date("2021-03-01"), as.Date("2021-07-01")), ylim = c(0, 2),
         xlab = "date (as in provided file, may actually refer to longer period)",
         ylab = expression(R[t]),...)
  }
  # add intervals if desired:
  if(interval){
    polygon(c(subs$date, rev(subs$date)),
            c(subs$value_0.975, rev(subs$value_0.025)),
            col = modify_alpha(col, 0.15), border = modify_alpha(col, 0.15))
  }
  # add line for point estimates:
  lines(subs$date, subs$value, type = "l", col = col)
}

# modify the alpha value of a given color (to generate transparent versions for prediction bands)
# Arguments:
# col: colour
# alpha: the new alpha value
modify_alpha <- function(col, alpha){
  x <- col2rgb(col)/255
  rgb(x[1], x[2], x[3], alpha = alpha)
}