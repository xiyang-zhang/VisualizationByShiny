# preparation for the dataset.

tablecolnames <- c("Percentile.Rank", "60-64", "65-69", "70-74", 
                   "75-79", "80-84", "85-89", "90-94")      

CSF <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                  group1 = c(17, 15, 12, 15),
                  group2 = c(16, 14, 11, 15),
                  group3 = c(15, 13, 10, 14),
                  group4 = c(15, 12, 10, 13),
                  group5 = c(14, 11, 9, 12),
                  group6 = c(13, 10, 8, 11),
                  group7 = c(11, 8, 4, 9))
colnames(CSF) <- tablecolnames

CSM <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                  group1 = c(19, 16, 14, 17),
                  group2 = c(18, 15, 12, 16),
                  group3 = c(17, 14, 12, 15),
                  group4 = c(17, 14, 11, 14),
                  group5 = c(15, 12, 10, 13),
                  group6 = c(14, 11, 8, 11),
                  group7 = c(12, 10, 7, 9))
colnames(CSM) <- tablecolnames

ARMF <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                   group1 = c(19, 16, 13, 17),
                   group2 = c(18, 15, 12, 17),
                   group3 = c(17, 14, 12, 16),
                   group4 = c(17, 14, 11, 15),
                   group5 = c(16, 13, 10, 14),
                   group6 = c(15, 12, 10, 13),
                   group7 = c(13, 11, 8, 11))
colnames(ARMF) <- tablecolnames

ARMM <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                   group1 = c(22, 19, 16, 19),
                   group2 = c(21, 18, 15, 18),
                   group3 = c(21, 17, 14, 17),
                   group4 = c(19, 16, 13, 16),
                   group5 = c(19, 16, 13, 15),
                   group6 = c(17, 14, 11, 13),
                   group7 = c(14, 12, 10, 11))
colnames(ARMM) <- tablecolnames

WALKF <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                    group1 = c(659, 603, 547, 625),
                    group2 = c(636, 568, 500, 605),
                    group3 = c(614, 548, 482, 580),
                    group4 = c(585, 509, 433, 550),
                    group5 = c(540, 462, 384, 510),
                    group6 = c(512, 426, 340, 460),
                    group7 = c(441, 357, 273, 400))
colnames(WALKF) <- tablecolnames

WALKM <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                    group1 = c(736, 674, 612, 680),
                    group2 = c(700, 631, 562, 650),
                    group3 = c(680, 612, 544, 620),
                    group4 = c(639, 555, 471, 580),
                    group5 = c(604, 524, 444, 530),
                    group6 = c(572, 477, 382, 470),
                    group7 = c(502, 403, 304, 400))
colnames(WALKM) <- tablecolnames

STEPF <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                    group1 = c(107, 91, 75, 97),
                    group2 = c(107, 90, 73, 93),
                    group3 = c(101, 84, 67, 89),
                    group4 = c(100, 84, 68, 84),
                    group5 = c(90, 75, 60, 78),
                    group6 = c(85, 70, 55, 70),
                    group7 = c(72, 58, 44, 60))
colnames(STEPF) <- tablecolnames

STEPM <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                    group1 = c(115, 101, 87, 106),
                    group2 = c(116, 101, 86, 101),
                    group3 = c(110, 95, 80, 95),
                    group4 = c(109, 91, 73, 88),
                    group5 = c(103, 87, 71, 80),
                    group6 = c(91, 75, 59, 71),
                    group7 = c(86, 69, 52, 60))
colnames(STEPM) <- tablecolnames

CHAIRSARF <- data.frame(Percentile.Rank = c(75, 50, 25),
                        group1 = c(4.8, 2.1, -0.6),
                        group2 = c(4.4, 2.0, -0.4),
                        group3 = c(3.9, 1.4, -1.1),
                        group4 = c(3.7, 1.2, -1.3),
                        group5 = c(3.0, 0.5, -2.0),
                        group6 = c(2.4, -0.1, -2.6),
                        group7 = c(1.0, -1.7, -4.4))
colnames(CHAIRSARF) <- tablecolnames

CHAIRSARM <- data.frame(Percentile.Rank = c(75, 50, 25),
                        group1 = c(3.8, 0.6, -2.6),
                        group2 = c(3.1, 0.0, -3.1),
                        group3 = c(3.0, 0.0, -3.1),
                        group4 = c(2.0, -1.1, -4.2),
                        group5 = c(1.4, -2.0, -5.3),
                        group6 = c(0.4, -2.4, -5.2),
                        group7 = c(-0.7, -3.6, -6.5))
colnames(CHAIRSARM) <- tablecolnames

BACKF <- data.frame(Percentile.Rank = c(75, 50, 25),
                        group1 = c(1.6, -0.7, -3.0),
                        group2 = c(1.3, -1.2, -3.7),
                        group3 = c(0.8, -1.7, -4.2),
                        group4 = c(0.6, -2.1, -4.8),
                        group5 = c(0.2, -2.6, -5.4),
                        group6 = c(-0.9, -3.9, -6.9),
                        group7 = c(-1.0, -4.5, -8.0))
colnames(BACKF) <- tablecolnames

BACKM <- data.frame(Percentile.Rank = c(75, 50, 25),
                    group1 = c(-0.2, -3.4, -6.6),
                    group2 = c(-0.8, -4.1, -7.4),
                    group3 = c(-1.2, -4.5, -7.8),
                    group4 = c(-2.2, -5.6, -9.0),
                    group5 = c(-2.1, -5.7, -9.3),
                    group6 = c(-3.0, -6.2, -9.4),
                    group7 = c(-4.0, -7.2, -10.4))
colnames(BACKM) <- tablecolnames

BACKF <- data.frame(Percentile.Rank = c(75, 50, 25),
                    group1 = c(1.6, -0.7, -3.0),
                    group2 = c(1.3, -1.2, -3.7),
                    group3 = c(0.8, -1.7, -4.2),
                    group4 = c(0.6, -2.1, -4.8),
                    group5 = c(0.2, -2.6, -5.4),
                    group6 = c(-0.9, -3.9, -6.9),
                    group7 = c(-1.0, -4.5, -8.0))
colnames(BACKF) <- tablecolnames

BACKM <- data.frame(Percentile.Rank = c(75, 50, 25),
                    group1 = c(-0.2, -3.4, -6.6),
                    group2 = c(-0.8, -4.1, -7.4),
                    group3 = c(-1.2, -4.5, -7.8),
                    group4 = c(-2.2, -5.6, -9.0),
                    group5 = c(-2.1, -5.7, -9.3),
                    group6 = c(-3.0, -6.2, -9.4),
                    group7 = c(-4.0, -7.2, -10.4))
colnames(BACKM) <- tablecolnames

UAGF <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                   group1 = c(4.4, 5.2, 6.0, 5.0),
                   group2 = c(4.8, 5.6, 6.4, 5.3),
                   group3 = c(4.9, 6.0, 7.1, 5.6),
                   group4 = c(5.2, 6.3, 7.4, 6.0),
                   group5 = c(5.7, 7.2, 8.7, 6.5),
                   group6 = c(6.2, 7.9, 9.6, 7.1),
                   group7 = c(7.3, 9.4, 11.5, 8.0))
colnames(UAGF) <- tablecolnames

UAGM <- data.frame(Percentile.Rank = c(75, 50, 25, 999),
                   group1 = c(3.8, 4.7, 5.6, 4.8),
                   group2 = c(4.3, 5.1, 5.9, 5.1),
                   group3 = c(4.4, 5.3, 6.2, 5.5),
                   group4 = c(4.6, 5.9, 7.2, 5.9),
                   group5 = c(5.2, 6.4, 7.6, 6.4),
                   group6 = c(5.5, 7.2, 8.9, 7.1),
                   group7 = c(6.2, 8.1, 10.0, 8.0))
colnames(UAGM) <- tablecolnames

genderList <- list("M", "F")
names(genderList) <- c("Male", "Female")

testList <- list("CS", "ARM", "WALK", "STEP", "CHAIRSAR", "BACK", "UAG")
names(testList) <- c("Chair Stand", "Arm Curl", "6-Minute Walk", 
                     "2-Minute Step", "Chair Sit-and-Reach",
                     "Back Scratch", "8-Foot Up-and-Go")

rangeTable <- list(seq(4, 20, 2),
                   seq(6, 22, 2),
                   seq(200, 800, 100),
                   seq(40, 120, 10),
                   seq(-6, 8, 2),
                   seq(-10, 6, 2),
                   seq(12, 2, -2),
                   seq(4, 20, 2),
                   seq(6, 22, 2),
                   seq(200, 800, 100),
                   seq(40, 120, 10),
                   seq(-8, 6, 2),
                   seq(-12, 4, 2),
                   seq(12, 2, -2))
names(rangeTable) <- c(paste0(as.character(testList), "F"), 
                       paste0(as.character(testList), "M"))

titleList <- list("30-second chair stand-Women \n (lower body strength)",
                  "30-second arm curl-Women \n (upper body strength)",
                  "6-minute walk-Women \n (aerobic endurance)",
                  "2-minute step-Women \n (aerobic endurance)",
                  "Chair sit-and-reach-Women \n (lower body flexibility)",
                  "Back scratch-Women \n (upper body flexibility)",
                  "8-feet up-and-go-Women \n (agility/dynamic balance)",
                  "30-second chair stand-Men \n (lower body strength)",
                  "30-second arm curl-Men \n (upper body strength)",
                  "6-minute walk-Men \n (aerobic endurance)",
                  "2-minute step-Men \n (aerobic endurance)",
                  "Chair sit-and-reach-Men \n (lower body flexibility)",
                  "Back scratch-Men \n (upper body flexibility)",
                  "8-feet up-and-go-Men \n (agility/dynamic balance)")
names(titleList) <- c(paste0(as.character(testList), "F"), 
                      paste0(as.character(testList), "M"))

yaxisList <- list("Number of stands", "Number of curls", "Yards walked", 
                  "Number of steps", "Inches", "Inches", "Seconds")
names(yaxisList) <- c(as.character(testList))

lowerList <- list(8.4, 10.5, 363, 58, -1.9, -4.5, 8.8,
                  8.3, 10.7, 369, 59, -3.8, -8.0, 8.9)
names(lowerList) <- c(paste0(as.character(testList), "F"), 
                      paste0(as.character(testList), "M"))

