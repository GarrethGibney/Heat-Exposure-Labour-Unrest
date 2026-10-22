# Replication Code: Strike While the Weather is Hot

Replication code for:

> Gibney, G., Cullinan, J., and McDermott, T.K.J. *Strike While the Weather is Hot: Temperature Extremes and Labor Conflict in the United States.* School of Business & Economics, University of Galway.

The paper estimates the short-run effect of cumulative heat exposure (days with average temperature ≥ 90°F over the previous 60 days) on labor conflict in U.S. counties during the summer months (June to August) of 2021 to 2025, using Poisson pseudo-maximum likelihood (PPML) with high-dimensional fixed effects.

## Repository structure

```
.
├── Data Cleaning/
│   ├── Clean_Labour_Conflict.ipynb   # Labor Action Tracker: parse, classify, build county-day panel
│   ├── Clean_Weather.ipynb           # nClimGrid-Daily: download, grid, match to counties, build heat measures
│   └── Matching.ipynb                # Merge conflict, weather and CBP employment data
├── Analysis/
│   ├── Prepare.do                    # Load merged panel, create fixed effect groups and exposure bins
│   ├── Baseline.do                   # Main, heterogeneity and robustness regressions (ppmlhdfe)
│   ├── Influential Observations.do   # Leave-one-county-out estimates
│   ├── OneInOneOut.ipynb             # Plots the leave-one-out results
│   └── Archive/                      # Earlier exploratory scripts, not needed for replication
├── Summary_Tables_Figures.ipynb      # Descriptive tables and figures
├── Results_Tables_Figures.ipynb      # Regression figures and the attributable events table
└── Percentage and Absolute Expected Changes Table*.docx   # Draft versions of Table A.1
```

## Data

Raw data are not included in this repository. All sources are publicly available.

| Data | Source | Expected location |
|---|---|---|
| Labor conflict events | Labor Action Tracker (Kallas et al., 2024), Cornell ILR and Illinois LER. https://striketracker.ilr.cornell.edu | `Data/Raw/Labour Conflict/labor_actions_05012026.json` |
| Daily gridded temperature | NOAA nClimGrid-Daily v1 (Durre et al., 2022). Downloaded automatically by `Clean_Weather.ipynb` from https://www.ncei.noaa.gov/pub/data/daily-grids/v1-0-0/grids | `Data/Raw/Weather/` |
| County boundaries | NWS county shapefile (`c_05mr24`) | `Data/Raw/US Counties/US_County_SHP/c_05mr24.shp` |
| County employment | Census County Business Patterns 2021 (`cbp21co.txt`) | `Data/Raw/CBP/` |
| NAICS definitions | 2022 NAICS 2 to 6 digit code list (Census) | `Data/Raw/Sector/` |
| Union membership by industry | BLS union membership tables | `Data/Raw/Union/Union Membership by Sector/` |
| Occupational heat risk | O\*NET OnLine and BLS Occupational Employment and Wage Statistics (OEWS) | used in `Summary_Tables_Figures.ipynb` |

## Software

**Python 3** with: `pandas`, `numpy`, `geopandas`, `shapely`, `pyproj`, `xarray` (with a NetCDF backend such as `netCDF4`), `scikit-learn`, `scipy`, `matplotlib`, `requests`, `tqdm`, `openpyxl`.

**Stata** (version 16 or later recommended) with:

```stata
ssc install ftools
ssc install reghdfe
ssc install ppmlhdfe
ssc install estout
```

## Setting paths

Paths are hard-coded to the authors' machine. Before running, change the project directory at the top of each file to your own project folder (which should contain the `Data/` and `Results (Final)/` folders):

- Python notebooks: the `directory` variable in the first cell (also `Union_Membership_directory` in `Summary_Tables_Figures.ipynb`, and the results folder in `Results_Tables_Figures.ipynb` and `OneInOneOut.ipynb`)
- Stata: `global path` in `Analysis/Prepare.do`

## Replication steps

Run the scripts in the order below.

**1. Clean labor conflict data**: `Data Cleaning/Clean_Labour_Conflict.ipynb`
Flattens the Labor Action Tracker JSON, drops events with no employer, codes strikes and protests, assigns each event a 2-digit NAICS code and one of six broad sectors, geolocates events to counties and builds the county-day panel.
Outputs: `lconflict_event.csv`, `labour_unrest_county_day_panel.csv`, `labour_unrest_event_day_panel.csv`

**2. Clean weather data**: `Data Cleaning/Clean_Weather.ipynb`
Downloads monthly nClimGrid-Daily files, aggregates to a 50 km grid, matches each county centroid to its nearest grid centroid and constructs daily temperature bin counts over lagged (14, 30, 60, 90 day) and leading (60 day) windows (for example `nn_tavg_above_90_lag_60d`). The download and gridding steps are slow; later cells read the processed CSVs.
Output: `weather.csv` (plus climate normal files not used in the final paper)

**3. Merge datasets**: `Data Cleaning/Matching.ipynb`
Merges the conflict panel, weather panel and 2021 CBP county employment.
Output: `Weather_Labour_Unrest_Event.csv`

**4. Prepare the estimation sample**: `Analysis/Prepare.do`
Loads `Weather_Labour_Unrest_Event.csv`, sets the panel, creates time and fixed effect identifiers, the employment offset (`log_emp`) and the binned exposure variables, including alternative thresholds (80°F, 85°F), window lengths, cold exposure and lead bins.

**5. Estimate models**: `Analysis/Baseline.do` (run in the same Stata session, after `Prepare.do`)
Runs all PPML models with county, month and year fixed effects, an employment offset and county clustered standard errors. Raw coefficient files are written to `Results (Final)/Raw/` and LaTeX tables to `Results (Final)/`.

**6. Leave-one-out analysis**: `Analysis/Influential Observations.do`, then `Analysis/OneInOneOut.ipynb`

**7. Tables and figures**: `Summary_Tables_Figures.ipynb` and `Results_Tables_Figures.ipynb`

## Mapping to the paper

| Paper output | Produced by |
|---|---|
| Figure 1: Temporal distribution of hot days | `Summary_Tables_Figures.ipynb` |
| Figure 2: Geographic distribution of conflict | `Summary_Tables_Figures.ipynb` |
| Table 1: Summary statistics | `Summary_Tables_Figures.ipynb` |
| Figure 3: Main results | `Baseline.do` (section 1), plotted in `Results_Tables_Figures.ipynb` |
| Figure 4: Strikes vs protests | `Baseline.do` (action type), `Results_Tables_Figures.ipynb` |
| Figure 5: Results by sector | `Baseline.do` (sector), `Results_Tables_Figures.ipynb` |
| Figures A.1 to A.4: Action type, heat risk, unionization, sector breakdown | `Summary_Tables_Figures.ipynb` |
| Table A.1: Percentage changes and attributable events | `Baseline.do` (baseline rates and exposure counts), `Results_Tables_Figures.ipynb` |
| Table A.2: Alternative fixed effects | `Baseline.do` (sensitivity analysis) |
| Table A.3: Alternative heat thresholds | `Baseline.do` (alt heat threshold) |
| Table A.4: Alternative window lengths | `Baseline.do` (alt heat window length) |
| Tables A.5 and A.6: Cold exposure | `Baseline.do` (cold exposure) |
| Figure A.5: Lags, contemporaneous and leads | `Baseline.do` (lead effects), `Results_Tables_Figures.ipynb` |
| Figure A.6: Extended study period | `Baseline.do` (extending the study window), `Results_Tables_Figures.ipynb` |
| Figure A.7: Influential observations | `Influential Observations.do`, `OneInOneOut.ipynb` |

## Notes

- The section of `Baseline.do` headed "Other Tests not included in Paper" is not required to reproduce the paper.
- Files in `Analysis/Archive/` and the `~*.stswp` Stata swap files are not part of the replication.
- Results file names include a date stamp (for example `_18052026`). If you change these in `Baseline.do`, update the matching file names in `Results_Tables_Figures.ipynb`.

## Contact

Garreth Gibney, University of Galway: garrethgibney.work@gmail.com
