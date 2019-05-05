library(tidyverse)
library(openxlsx)
library(ggrepel)

# Visualization for Amir
# Author, Xiyang Zhang
# Date, Apr, 2019

# read data
data = read.xlsx("data.xlsx", sheet = 1, startRow = 1, colNames = TRUE)

# clean format
summary_data <- data %>%
  rbind(c(100, rep(800, ncol(data)-1)), data) %>% #max
  rbind(c(999, 600, 590, 580, 550, 500, 450, 400)) %>% #Functional fitness standards
  filter(Percentile.Rank %in% c(25, 50, 75, 100, 999)) %>% 
  rename("Variable" = "Percentile.Rank") %>% 
  gather(var, value, -Variable) %>% 
  mutate_at(vars(Variable, var), funs(as.factor)) %>% 
  mutate(Variable = fct_recode(Variable, 
                               "Max" = "100",
                               "75% Quantile" = "75", 
                               "Average" = "50",
                               "25% Quantile" = "25",
                               "Functional fitness standards" = "999"))


# plot
p <- ggplot(summary_data) + 
  scale_y_continuous(breaks = seq(200, 800, 100), 
                     limits = c(0, 800),
                     minor_breaks = seq(200, 800, 100)) + # y grids
  coord_cartesian(ylim = c(200, 780), xlim = c(1.5, 6.5)) + # available coordinates range
  theme(panel.ontop = TRUE,
        panel.background = element_rect(fill = NA),
        panel.grid = element_line(color = "black", size = 0.4),
        plot.subtitle = element_text(hjust = 1),
        text = element_text(family = "Arial", size = 14),
        axis.title.y = element_text(angle = 0, vjust = 0.5)) + # theme
  labs(title="6-minute walk-Women (aerobic endurance)", 
       subtitle= paste0("ID: ", " \n", "Last Name: ", " \n", "First Name: ", " \n", "Assessment Date: "),
       y="Yards \n Walked", 
       x="Age Group") + #title and label
  geom_area(data = summary_data %>% 
              filter(Variable %in% c("Max", "75% Quantile", "25% Quantile")) %>% 
              mutate(Variable = fct_drop(Variable)), 
            aes(x=var, y=value,
                group = fct_reorder(Variable, value, .desc = TRUE), 
                fill = fct_reorder(Variable, value, .desc = TRUE)), 
            position = "identity",
            alpha  = 1,
            inherit.aes = FALSE) + #fill the area
  geom_point(data = summary_data %>% 
               filter(Variable %in% c("75% Quantile", "25% Quantile", "Functional fitness standards")) %>% 
               mutate(Variable = fct_drop(Variable)),
             aes(x = var, y = value, shape = Variable),
             inherit.aes = FALSE,
             size = 2, alpha = 1) + #add points
  scale_fill_manual(name = "", values = c("magenta2", "ghostwhite", "palegreen"),
                    label = c("Above Average", "Normal Range", "Below Average"))+ #modify legend
  scale_shape_manual(name = "", values = c(15, 17, 12),
                     breaks = c("75% Quantile", "25% Quantile", "Functional fitness standards")) + #modify legend
  guides(fill = guide_legend(order=1),
         shape = guide_legend(order=2)) + #reorder the guides
  geom_line(data = summary_data %>% 
              filter(Variable %in% c("75% Quantile", "25% Quantile")) %>% 
              mutate(Variable = fct_drop(Variable)),
            aes(x = var, y = value, group = Variable), color = 'black',
            inherit.aes = FALSE) #add boundary line

# function: add area with texture of tilted line
add_tilted_line <- function(gg_graph, upperbound, angle = pi/4, n = 10){
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
    gg_graph <- gg_graph + geom_segment(data = lineData, 
                                        mapping = aes(x = xstart, y = ystart, xend = xend, yend = yend, linetype = lty))
      
  }
  # after the sequence, goes from the lower line to start, with the same pace.
  # fill the right lower space
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
    gg_graph <- gg_graph + geom_segment(data = lineData,
                                        mapping = aes(x = xstart, y = ystart, xend = xend, yend = yend, linetype = lty))
    xstart <- xstart + step_len
    yend <- upperbound
  }
  return(gg_graph +
           scale_linetype(labels = "Low Functioning") +
           guides(fill = guide_legend(order=1),
                  linetype = guide_legend(title = NULL, order = 2),
                  shape = guide_legend(order=3)))
}

p <- add_tilted_line(p, upperbound = 363, angle = pi/3, n = 15)

add_new_point <- function(gg_graph, age, val, name, ID, size = 6, dist_y = 50){
  if (age < 60 | age >= 95){
    stop(paste("Unavailable range of age:", age))
  } else {
    x <- levels(summary_data$var)[findInterval(age, v = seq(60, 95, 5), left.open = FALSE)]
    new_point <- data.frame(Variable = paste0("Your Score: ", val), var = x, value = val)
    if (val < 175){
      warning(paste("Too low yards walked to show:", val))
    } else if (val > 800){
      warning(paste("Too high yards walked to show:", val))
    }
    if (val > 500){
      dist_y = -50
    }
    names <- str_match(name, "(\\w+)\\s(\\w+)")
    return(gg_graph + geom_point(data = new_point, mapping = aes(x = var, y = value), 
                                 shape = 21, colour = "black", fill = "black", size = size, inherit.aes = FALSE) + 
             geom_label_repel(data = new_point, mapping = aes(x = var, y = value, label = Variable), 
                              arrow = arrow(ends = "last", type = "closed", length = unit(0.03, "npc")),
                              nudge_y = dist_y, segment.size = 1,
                              inherit.aes = FALSE, size = 5, family = "Arial", direction = "both") + 
             labs(subtitle=paste0("ID: ", ID, "\n", 
                                  "Last Name: ", names[3], 
                                  "\n", "First Name: ", names[2], 
                                  "\n", "Evaluation Date: ",Sys.Date())))
  }
}


add_new_point(p, age = 62, val = 400, name = "XY Z", ID = "123", dist_y = 50)

