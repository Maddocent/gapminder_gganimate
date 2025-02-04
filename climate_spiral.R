# Install necessary packages if not installed
if (!require(ggplot2)) install.packages("ggplot2", dependencies = TRUE)
if (!require(gganimate)) install.packages("gganimate", dependencies = TRUE)
if (!require(gifski)) install.packages("gifski", dependencies = TRUE)
if (!require(transformr)) install.packages("transformr", dependencies = TRUE)

# Load libraries
library(ggplot2)
library(gganimate)
library(gifski)
library(transformr)
library(dplyr)

# Simulated climate data (replace with actual data)
set.seed(123)
years <- rep(1880:2023, each = 12)  # Repeat years for each month
months <- rep(1:12, times = length(unique(years)))  # Repeat months
temperature_anomaly <- cumsum(runif(length(years), -0.02, 0.03))  # Example anomalies

# Create dataframe
climate_data <- data.frame(
  Year = years,
  Month = months,
  Anomaly = temperature_anomaly
)

# Convert months to radians for the spiral
climate_data <- climate_data %>%
  mutate(Radians = (Month - 1) * (2 * pi / 12))

# Create the climate spiral plot
p <- ggplot(climate_data, aes(x = Radians, y = Anomaly, group = Year, color = Anomaly)) +
  geom_line(size = 1) +
  scale_x_continuous(
    limits = c(0, 2 * pi),
    breaks = seq(0, 2 * pi, length.out = 12),  # Ensure 12 breaks
    labels = month.abb  # Matches exactly with 12 months
  ) +
  scale_color_gradientn(colors = c("blue", "white", "red")) +
  coord_polar(start = 0) +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.title = element_blank(),
        legend.position = "bottom") +
  labs(title = "Climate Spiral - Global Temperature Anomalies",
       subtitle = "Year: {frame_along}",
       color = "Temperature Anomaly (°C)") +
  transition_reveal(along = Year) +  # Keeps all previous lines visible
  ease_aes('linear')

# Animate with slower pace
animated_spiral <- animate(p, 
                           nframes = 300,  # More frames for a slower animation
                           fps = 20,       # Lower FPS makes it smoother and slower
                           duration = 15)  # Total duration in seconds

# Save animation as GIF
anim_save("climate_spiral_slow.gif", animated_spiral, renderer = gifski_renderer(), width = 800, height = 800)

# Display animation
animated_spiral
