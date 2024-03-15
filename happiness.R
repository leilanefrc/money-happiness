library(readxl)
library(dplyr)
library(ggplot2)

happiness <- read_excel("C:/Users/leica/Desktop/happiness.xlsx")
HDI <- read_excel("C:/Users/leica/Desktop/happiness.xlsx", sheet = "HDI")
GDP <- read_excel("C:/Users/leica/Desktop/happiness.xlsx", sheet = "GDP")
regions <- read_excel("C:/Users/leica/Desktop/happiness.xlsx", sheet = "Regions")

df = merge(happiness, HDI, by="Country")
df = merge(df, GDP, by="Country")
df = merge(df, regions, by="Country")

df %>%
  summarise(across(c(Happiness_score,HDI,GDP_per_capita), list(mean = mean, min = min, max = max, sd = sd)))

df %>%
  group_by(World_Region) %>%
  summarise(across(c(Happiness_score,HDI,GDP_per_capita), list(mean = mean, min = min, max = max, sd = sd)))

scatterPlot <- ggplot(df, aes(GDP_per_capita, Happiness_score, colour=World_Region)) +
  geom_point() +
  labs(x = "GDP per capita", x = "Happiness Score", colour = "World Region") +
  theme_minimal()
scatterPlot

logModel <- lm(unlist(df["Happiness_score"]) ~ log(unlist(df["GDP_per_capita"])))
summary(logModel)

predictedHappiness <- c(predict(logModel))
GDP_pc <- unlist(df["GDP_per_capita"])
log.df <- data.frame(GDP_pc, predictedHappiness)

scatterPlot <- ggplot() +
  geom_point(data = df, aes(GDP_per_capita, Happiness_score, colour=World_Region)) +
  geom_line(data = log.df, aes(x = GDP_pc, y = predictedHappiness)) +
  labs(x = "GDP per capita", y = "Happiness Score", colour = "World Region") +
  theme_minimal()
scatterPlot
