# World Happiness Regression Analysis

## Description
A multiple linear regression analysis of the 2024 World Happiness Report dataset. The project examines how economic, social, health, freedom, generosity, and perceived-corruption indicators are associated with national happiness scores, with additional exploratory analysis and regression diagnostics in R.

## Objectives
- Explore the distribution and relationships among World Happiness indicators.
- Model `Ladder score` using six explanatory variables.
- Evaluate key regression diagnostics, including normality, heteroskedasticity, multicollinearity, and residual autocorrelation.
- Compare the ordinary least squares (OLS) model with a robust regression approach.

## Methods
- Multiple Linear Regression (OLS)
- Robust Regression
- Correlation Analysis
- Pair Plot
- Scatter Plot
- Box Plot
- Lilliefors Normality Test
- Breusch–Pagan Test
- Variance Inflation Factor (VIF)
- Durbin–Watson Test
- AIC / BIC comparison
- MSE, RMSE, and MAE 

## Variables
**Response variable**
- `Ladder score`

**Predictors**
- `Log GDP per capita`
- `Social support`
- `Healthy life expectancy`
- `Freedom to make life choices`
- `Generosity`
- `Perceptions of corruption`

## Repository Structure
```text
World-Happiness-Regression-Analysis/
├── R/
│   └── world_happiness_regression.R
├── data/
│   ├── world_happiness_2024.csv
│   └── DATA_SOURCE.txt
├── outputs/
│   └── plots/
│       ├── Fig 1.png
│       ├── Fig 2.png
│       ├── Fig 3.png
│       ├── Fig 4.png
│       └── Fig 5.png
├── .gitignore
└── README.md
```

## Requirements
R with the following packages:

```r
install.packages(c(
  "readxl", "car", "ggplot2", "dplyr", "corrplot", "GGally",
  "tidyr", "nortest", "MASS", "sandwich", "lmtest", "Metrics", "broom"
))
```

## How to Run
From the repository root:

```r
source("R/world_happiness_regression.R")
```

The script expects the dataset at `data/world_happiness_2024.csv`.

## Dataset Source
The dataset is the 2024 World Happiness Report dataset as obtained from the public Kaggle dataset referenced in `data/DATA_SOURCE.txt`. The repository includes the CSV used by the analysis for reproducibility.

## Notes
- Academic submission files such as presentations, reports, DOCX/PDF files, and Turnitin results are intentionally excluded from this repository.
- The repository contains no personal identifiers, credentials, or private project files.
