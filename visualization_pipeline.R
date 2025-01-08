library(tidyverse)
library(ggrepel)

# Visualization pipeline
# Author, Xiyang Zhang
# Date, Apr-May, 2019

source("sourceData.R")

add_tilted_line <- function(gg_graph, upperbound, angle = pi/4, n = 10, inversed = FALSE){
  coord_xlimits <- range(ggplot_build(gg_graph)$data[[2]]$x)
  coord_ylimits <- gg_graph[["coordinates"]][["limits"]][["y"]]
  lowerbound <- coord_ylimits[1] - 0.05*diff(coord_ylimits)
  scale_ratio <- diff(coord_ylimits)/diff(coord_xlimits) * tan(angle)
  xends <- seq(coord_xlimits[1], coord_xlimits[2], length.out = n)
  # for the first few lines
  for (i in 1:n){
    xend <- xends[i]
    yend <- upperbound
    xstart <- coord_xlimits[1]
    ystart <- upperbound - (xends[i]-xstart) * scale_ratio
    if (ystart < lowerbound){
      ystart <- lowerbound
      xstart <- xend - (yend - ystart)/scale_ratio
    }
    lineData = data.frame(xstart, ystart, xend, yend, lty = "longdash")
    gg_graph <- gg_graph + geom_segment(data = lineData, color = "blue",
                                        mapping = aes(x = xstart, y = ystart, xend = xend, yend = yend, linetype = lty))
  }
  # after the sequence, goes from the lower line to start, with the same pace.
  # fill the right lower space
  if (inversed == FALSE){
    step_len <- xends[2]-xends[1]
    yend <- upperbound
    ystart <- lowerbound
    xstart <- xstart + step_len
    while (xstart <= coord_xlimits[2]){
      xend <- xstart + (yend - ystart)/scale_ratio
      if (xend > coord_xlimits[2]){
        xend <- coord_xlimits[2]
        yend <- ystart + scale_ratio * (xend - xstart)
      }
      lineData = data.frame(xstart, ystart, xend, yend, lty = "longdash")
      gg_graph <- gg_graph + geom_segment(data = lineData, color = "blue", 
                                          mapping = aes(x = xstart, y = ystart, xend = xend, yend = yend, linetype = lty))
      xstart <- xstart + step_len
      yend <- upperbound
    }
  } else {
    step_len <- xends[2]-xends[1]
    xend <- xends[length(xends)]
    xstart <- xstart + step_len
    yend <- ystart + (xend - xstart) * scale_ratio
    while (yend <= coord_ylimits[1]){
      lineData = data.frame(xstart, ystart, xend, yend, lty = "longdash")
      gg_graph <- gg_graph + geom_segment(data = lineData, color = "blue", 
                                          mapping = aes(x = xstart, y = ystart, xend = xend, yend = yend, linetype = lty))
      xstart <- xstart + step_len
      yend <- ystart + (xend - xstart) * scale_ratio
    }
  }
  return(gg_graph)
}

getBasicPlot <- function(genderType, testType){
  dataName <- paste0(testType, genderType)
  datas <- get(dataName)
  ranges <- rangeTable[[dataName]]
  
  summary_data <- datas %>%
    rbind(., c(100, rep(max(ranges), times = ncol(datas)-1))) %>% #max
    rbind(., c(0, rep(min(ranges), times = ncol(datas)-1))) %>% 
    rename("Variable" = "Percentile.Rank") %>% 
    gather(var, value, -Variable) %>% 
    mutate_at(., vars(Variable, var), as.factor)
  
  if (testType %in% c("CHAIRSAR", "BACK")){
    summary_data <- summary_data %>%
      mutate(Variable = fct_recode(Variable, 
                                   "Min" = "0",
                                   "Max" = "100",
                                   "75% Quantile" = "75", 
                                   "Average" = "50",
                                   "25% Quantile" = "25"))
  } else {
    summary_data <- summary_data %>%
      mutate(Variable = fct_recode(Variable, 
                                   "Min" = "0",
                                   "Max" = "100",
                                   "75% Quantile" = "75", 
                                   "Average" = "50",
                                   "25% Quantile" = "25",
                                   "Functional fitness standards" = "999"))
  }
  
  if (testType == "UAG"){
    p <- ggplot(summary_data %>% 
                  spread(Variable, value)) + 
      scale_y_reverse(breaks = ranges, 
                      minor_breaks =ranges) + # y grids
      coord_cartesian(ylim = c(max(ranges), min(ranges)), xlim = c(1, 7)) + #title and label
      geom_ribbon(aes(x=as.numeric(var), ymin= Max, ymax=`25% Quantile`, fill = "a"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) +
      geom_ribbon(aes(x=as.numeric(var), ymin=`25% Quantile`, ymax=`75% Quantile`, fill = "b"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) +
      geom_ribbon(aes(x=as.numeric(var), ymin=`75% Quantile`, ymax=Min, fill = "c"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) + 
      scale_fill_manual(name = "", values = c("magenta4", "ghostwhite", "grey80"), 
                        label = c("Above Average \n (75% Quantile)", "Normal Range", "Below Average \n (25% Quantile)"))
  } else {
    p <- ggplot(summary_data %>% 
                  spread(Variable, value)) + 
      scale_y_continuous(breaks = ranges, 
                         minor_breaks =ranges) + # y grids
      coord_cartesian(ylim = c(min(ranges), max(ranges)), xlim = c(1, 7)) + #title and label
      geom_ribbon(aes(x=as.numeric(var), ymin=`75% Quantile`, ymax=Max, fill = "a"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) +
      geom_ribbon(aes(x=as.numeric(var), ymin=`25% Quantile`, ymax=`75% Quantile`, fill = "b"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) +
      geom_ribbon(aes(x=as.numeric(var), ymin=Min, ymax=`25% Quantile`, fill = "c"), 
                  position = "identity", alpha  = 1, show.legend = T, inherit.aes = F) + 
      scale_fill_manual(name = "", values = c("magenta4", "ghostwhite", "grey80"),
                          # c("steelblue2", "ghostwhite", "palegreen"), 
                        label = c("Above Average \n (75% Quantile)", "Normal Range", "Below Average \n (25% Quantile)"))
  }
  
  if (!(testType %in% c("CHAIRSAR", "BACK"))){
    p <- p + geom_point(data = summary_data %>% 
                          filter(Variable == "Functional fitness standards"), 
                        aes(x = as.numeric(var), y = value, shape = Variable),
                        inherit.aes = FALSE, color = "blue", size = 4, alpha = 1) + 
      scale_shape_manual(name = "", labels = "Functional fitness standards", values = 12) +
      guides(fill = guide_legend(order=1),
             shape = guide_legend(order=2))
  }
  
  p <- p + 
    geom_line(data = summary_data %>% 
                filter(Variable %in% c("75% Quantile", "25% Quantile")) %>% 
                mutate(Variable = fct_drop(Variable)),
              aes(x = as.numeric(var), y = value, group = Variable), color = 'black',
              inherit.aes = FALSE) +
    geom_hline(yintercept = lowerList[[dataName]], color = "blue") + 
    theme(panel.ontop = TRUE,
          panel.background = element_rect(fill = "transparent"),
          panel.grid = element_line(color = "black", size = 0.4),
          plot.subtitle = element_text(hjust = 1),
          text = element_text(size = 14), #family = "Arial", 
          axis.title.y = element_text(angle = 0, vjust = 0.5),
          legend.key = element_rect(fill = "transparent", colour = "transparent"),
          legend.background = element_rect(fill = 'transparent', colour = "transparent"),
          legend.box.background = element_rect(fill = 'transparent', colour = "transparent"),
          legend.key.height = unit(1, "cm")) + # theme
    scale_linetype(guide = 'none') + 
    labs(title=titleList[[dataName]], 
         subtitle= paste0("ID: ", " \n", "Last Name: ", " \n", "First Name: ", " \n", "Assessment Date: "),
         y=yaxisList[[testType]], 
         x="Age Group") +
    scale_x_continuous(breaks = 1:7, labels = levels(summary_data$var))
  
  if (testType == "UAG"){
    p <- add_tilted_line(p, upperbound = lowerList[[dataName]], angle = pi/3, n = 15, inversed = TRUE)
  } else {
    p <- add_tilted_line(p, upperbound = lowerList[[dataName]], angle = pi/3, n = 15)
  }
  
  return(p + annotate("label", x = 4, y = lowerList[[dataName]] , label = "Low Functioning",
                      color = "white", fill = "blue", size = 4))
}

# getBasicPlot("F", "CS")
# getBasicPlot("M", "CS")
# getBasicPlot("F", "ARM")
# getBasicPlot("M", "ARM")
# getBasicPlot("F", "WALK")
# getBasicPlot("M", "WALK")
# getBasicPlot("F", "STEP")
# getBasicPlot("M", "STEP")
# getBasicPlot("F", "CHAIRSAR")
# getBasicPlot("M", "CHAIRSAR")
# getBasicPlot("F", "BACK")
# getBasicPlot("M", "BACK")
# getBasicPlot("F", "UAG")
# getBasicPlot("M", "UAG")

add_new_point <- function(gg_graph, age, val, name, ID, genderType, testType, size = 6){
  if (age < 60 | age >= 95){
    stop(paste("Unavailable range of age:", age))
  } else {
    dataName <- paste0(testType, genderType)
    datas <- get(dataName)
    ranges <- rangeTable[[dataName]]
    
    summary_data <- datas %>%
      rbind(., c(100, rep(max(ranges), times = ncol(datas)-1))) %>% #max
      rbind(., c(0, rep(min(ranges), times = ncol(datas)-1))) %>% 
      rename("Variable" = "Percentile.Rank") %>% 
      gather(var, value, -Variable) %>% 
      mutate_at(., vars(Variable, var), as.factor)
    
    x <- findInterval(age, v = seq(60, 95, 5), left.open = FALSE)
    new_point <- data.frame(Variable = paste0("Your Score: ", val), var = x, value = val)
    
    dist_y = abs(ranges[2] - ranges[1])
    if (val > min(ranges) + 0.5 * (max(ranges) - min(ranges))){
      dist_y = -dist_y
    }
    names <- str_match(name, "(\\w+)\\s(\\w+)")
    return(gg_graph + geom_point(data = new_point, mapping = aes(x = var, y = value), 
                                 shape = 21, colour = "black", fill = "black", size = size, inherit.aes = FALSE) + 
             geom_label_repel(data = new_point, mapping = aes(x = var, y = value, label = Variable), 
                              arrow = arrow(ends = "last", type = "closed", length = unit(0.03, "npc")),
                              nudge_y = dist_y, segment.size = 1,
                              inherit.aes = FALSE, size = 5, direction = "both") + # family = "Arial", 
             labs(subtitle=paste0("ID: ", ID, "\n", 
                                  "Last Name: ", names[3], 
                                  "\n", "First Name: ", names[2], 
                                  "\n", "Evaluation Date: ",Sys.Date())))
  }
}

# add_new_point(getBasicPlot("F", "CS"), age = 60, val = 10, name = "xkj lkj", ID = "123", genderType = "F", testType = "CS")
