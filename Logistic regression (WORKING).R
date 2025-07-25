read.csv(C:/Users/27768775/Downloads/Callitris rhomboidea stem diameter.csv)
library(dplyr)     # for data manipulation
library(ggplot2)   # for data visualization
library(ggplot2)
library(boot)
library(MASS)
library(stats)
install.packages("stats")
Data=GLM_tokai
Data1= BNR_data
# Assuming you have a dataset called 'plants_data' with the following structure:
# - 'height': the height at which plants start reproducing
# - 'reproductive_structures': presence (1) or absence (0) of reproductive structures

# Example data generation (you can replace this with your actual data)
set.seed(123)
plants_data <- data.frame(
  height = rnorm(100, mean = 50, sd = 10),
  reproductive_structures = sample(0:1, 100, replace = TRUE)
)

# Check the structure of the dataset
str(Data)

# Visualize the relationship between height and presence of reproductive structures
ggplot(Data, aes(x = Height, y = Cones)) +
  geom_boxplot() +
  labs(x = "Height", y = "Presence of cones")

# Fit a Generalized Linear Model (GLM)
glm_model <- glm(Height ~ Cones, data = Data, family = gaussian)

# Summarize the model
summary(glm_model)

# Predict using the model
new_data <- data.frame(Cones = c(0, 1)) # assuming you want to predict for absence and presence
predicted_height <- predict(glm_model, newdata = new_data, type = "response")

# Print predicted height
print(predicted_height)


glm_model <- glm(Cones ~ Height, data = Data, family = binomial(link = "logit"))

summary(glm_model)
predicted_values <- predict(glm_model, type = "response")

ggplot(Data, aes(x = Height, y = Cones)) +
  geom_point() +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE) +
  labs(title = "Size at reproduction of Callitris rhomboidea in Tokai",
       x = "Height (cm)",
       y = "Presence of cones")+scale_y_continuous(labels = function(x) ifelse(x == 1, "y", "n"))

conf_intervals <- confint(model, level = 0.95)
