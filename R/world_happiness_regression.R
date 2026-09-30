library(readxl)
library(car)
library(ggplot2)

whr <- read.csv("data/world_happiness_2024.csv")

# Cek tipe data
data <- whr
str(data)

colSums(is.na(data))
df_numeric <- data[, sapply(data, is.numeric)]
df_clean <- na.omit(df_numeric)

model <- lm(Ladder.score ~ Log.GDP.per.capita + Social.support +
              Healthy.life.expectancy + Freedom.to.make.life.choices +
              Generosity + Perceptions.of.corruption, data = df_clean)
summary(model)

# Interpretasi:
# - Coefficients: pengaruh tiap variabel X terhadap LadderScore
# - Pr(>|t|): nilai p untuk uji signifikansi
# - Multiple R-squared: seberapa besar variasi LadderScore dijelaskan oleh

# Correlation Matrix
library(dplyr)
library(corrplot)

# Select World Happiness variables
eda_data <- data %>%
  select(
    Ladder.score,
    Log.GDP.per.capita,
    Social.support,
    Healthy.life.expectancy,
    Freedom.to.make.life.choices,
    Generosity,
    Perceptions.of.corruption
  )

# Compute correlation matrix
cor_matrix <- cor(eda_data, use = "complete.obs")

# Plot correlation matrix
corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  number.cex = 0.7
)


# Pairplot
library(GGally)
library(dplyr)

# Pilih variabel World Happiness
eda_data <- data %>%
  select(
    Ladder.score,
    Log.GDP.per.capita,
    Social.support,
    Healthy.life.expectancy,
    Freedom.to.make.life.choices,
    Generosity,
    Perceptions.of.corruption
  )

# Pairplot
ggpairs(
  eda_data,
  lower = list(continuous = wrap("points", alpha = 0.6)),
  upper = list(continuous = wrap("cor", size = 3)),
  diag  = list(continuous = "densityDiag")
)

# ScatterPlot
library(ggplot2)
library(tidyr)

scatter_data <- eda_data %>%
  pivot_longer(
    cols = -Ladder.score,
    names_to = "Predictor",
    values_to = "Value"
  )

ggplot(scatter_data, aes(x = Value, y = Ladder.score)) +
  geom_point(alpha = 0.6) +
  geom_smooth(method = "lm", se = FALSE) +
  facet_wrap(~ Predictor, scales = "free_x") +
  theme_minimal() +
  labs(
    title = "Scatterplots of World Happiness Score vs Predictors",
    x = "Predictor Value",
    y = "Happiness Score"
  )


# Box Plot
library(ggplot2)
library(tidyr)

eda_long <- eda_data %>%
  pivot_longer(
    cols = everything(),
    names_to = "Variable",
    values_to = "Value"
  )

ggplot(eda_long, aes(x = Variable, y = Value)) +
  geom_boxplot(outlier.color = "red") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1)
  ) +
  labs(
    title = "Distribution and Outlier Detection of World Happiness Variables",
    x = "",
    y = "Value"
  )


# ====== cek normality ======
e <- resid(model)
library(nortest)
lillie.test(e)

#h0: error berdistribusi normal
#h1 : error tidak berdistribusi normal
# Karena 0,04 < 0.05 maka tolak h0. Artinya error tidak berdistribusi normal

# kalo tolak h0, harus coba pake model regresi lain

# 1. Regresi Robust
library(MASS)
model_robust <- rlm(Ladder.score ~ Log.GDP.per.capita + Social.support +
                      Healthy.life.expectancy + Freedom.to.make.life.choices +
                      Generosity + Perceptions.of.corruption, data = df_clean)
summary(model_robust)
lillie.test(resid(model_robust))

library(sandwich)
library(lmtest)

robust_results <- coeftest(
  model_robust,
  vcov = vcovHC(model_robust, type = "HC1")
)

robust_results

# Pseudo R2
rss <- sum(residuals(model_robust)^2)
tss <- sum((data$Ladder.score - mean(data$Ladder.score))^2)

pseudo_r2 <- 1 - rss / tss
pseudo_r2

# AIC
AIC(model_robust)

# MSE, RMSE, and MAE
pred_robust <- predict(model_robust, df_clean)

library(Metrics)

mse_robust  <- mse(df_clean$Ladder.score, pred_robust)
rmse_robust <- rmse(df_clean$Ladder.score, pred_robust)
mae_robust  <- mae(df_clean$Ladder.score, pred_robust)

c(MSE = mse_robust,
  RMSE = rmse_robust,
  MAE = mae_robust)

# Residuals Plot
plot(fitted(model_robust), residuals(model_robust),
     xlab = "Fitted values",
     ylab = "Robust residuals")
abline(h = 0, col = "red")

qqnorm(residuals(model_robust))
qqline(residuals(model_robust), col = "red")

# Simple Summary
library(broom)

tidy(model_robust)
glance(model_robust)


# AIC BIC Comparison
aic_bic_comparison <- data.frame(
  Model = c("OLS", "Robust"),
  AIC = c(
    AIC(model),
    AIC(model_robust)
  ),
  BIC = c(
    BIC(model),
    BIC(model_robust)
  )
)

aic_bic_comparison

aic_bic_long <- pivot_longer(
  aic_bic_comparison,
  cols = c(AIC, BIC),
  names_to = "Criterion",
  values_to = "Value"
)

ggplot(aic_bic_long, aes(x = Model, y = Value, fill = Criterion)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(
    title = "Comparison of AIC and BIC Between OLS and Robust Models",
    y = "Information Criterion Value",
    x = "Model"
  )

# ====== cek homoskedastisitas ======
library(lmtest)
bptest(model)
# H₀: Tidak ada heteroskedastisitas (varian error konstan → homoskedastis).
# H₁: Ada heteroskedastisitas (varian error tidak konstan).
# Karena p-value = 0.01559 < 0.05, maka tolak H, artinya ada heteroskedastisitas pada model.


# ======= Cek multikolinearitas =======
vif(model)
# (Jika nilai VIF > 10, ada indikasi multikolinearitas tinggi)
# VIF kita < 5 berarti tidak ada multikolinearitas

# ======= Cek Autokorelasi ======
dwtest(model)
# H₀ : Tidak ada autokorelasi (ρ = 0)
# H₁ : Ada autokorelasi positif (ρ > 0)
# p-value = 2.184e-06 < 0.05
# Jadi tolak H₀, artinya ada autokorelasi positif di residual model kita.

