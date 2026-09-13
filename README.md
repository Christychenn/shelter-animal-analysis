# shelter-animal-analysis
Analyzing animal in shelters
# Taiwan Shelter Animal Listings — Building a Structured Dataset

New Taipei City's shelters publish their adoptable-animal listings as JSON, but
each record stores its attributes as one free-text description string rather than
as fields. This project parses 1,192 listings into a proper table and profiles
what is actually sitting in the shelters.

## The problem
Each record arrives as a single block of text:

品種：混種 毛色：黑色 體型：中型 年齡：幼犬3個月 拾獲地點：中和區...

No schema, inconsistent spacing, and no guarantee that every record carries the
same attributes.

## What I built
An R script that:
1. Flattens the page-by-page JSON into one record per animal
2. Splits each description into field names and values using lookahead and
   lookbehind on the full-width colon, then uses the extracted field names as
   column names — so records with different attribute sets still line up
3. Transposes the record-oriented list into a column-oriented data frame
4. Standardizes inconsistent values: ages such as "幼犬3個月" and "幼犬8個月"
   collapse into one life stage, addresses are truncated to district level, and
   body size is ordered smallest-to-largest rather than alphabetically
5. Produces frequency charts for each attribute

Result: 1,192 listings

## What the data shows
The population is far more uniform than I expected. Across all 1,192 listings:

- 98.6% are mixed-breed (1,175 of 1,192); only 17 animals are purebred
- 83.7% are medium-sized, with large and small animals making up 5.4% and 10.8%
- 87.6% are adults; only 148 animals are young
- Over half are black (51.7%), with tabby a distant second at 11.9%

The five most common districts — Zhonghe, Tamsui, Linkou, Tucheng and Banqiao —
account for 46.4% of all listings.

## Running it
```r
install.packages(c("jsonlite", "purrr", "stringr", "ggplot2"))
source("analysis.R")
```

## Files
- `analysis.R` — parsing, standardization and charts
- `data/animal_shelter.json` — raw listings snapshot
- `plots/` — output charts

---
Coursework project, National Taipei University, 2022.
