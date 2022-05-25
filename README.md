# Creating a Dashboard to Analyze FAIR Scores within the Arctic Data Center (ADC) repository

- **Contributors**: Christopher W. Beltz
- **Contact**: cwbeltz@nceas.ucsb.edu
- **License**: [MIT License](https://opensource.org/licenses/MIT)
- **Source Code**: [Github](https://github.com/cwbeltz/FAIR_Shiny-Dashboard)
- **Dashboard**: [shinyapps.io](https://cwbeltz.shinyapps.io/nceas-df_fair_shiny-dashboard/)

This project analyzes the application of the FAIR Guiding Principles through four aggregate scores of the metadata within the ADC. This project is a component my Data Science Fellowship with @NCEAS.

### Repository Structure

```
FAIR-Shiny-Dashboard
  |_ code
  |_ data
    |_ raw
  |_ rsconnect
    |_ shinyapps.io
      |_ cwbeltz
```

### Getting started

Navigate to [shinyapps.io](https://cwbeltz.shinyapps.io/nceas-df_fair_shiny-dashboard/) to bring up the current cloud-hosted version of the dashboard. This dashboard is meant to be used to visualize metrics about the completeness of data packages with the ADC repository. This allows a retroactive assessment of data quality and improvement through curation, but is also meant as an aid for tracking data packages in the process of being curated. Typically there are 30-60 packages being currated at any one time, often by 5-10 separate individuals. The goal was to develop a dashboard that allows for an assessment of all recent packages by a single individual managing the data package curation.

The application opens with four sections of panels: data range & package-specfic information such as Date Uploaded (top left), all recent data packages with the Overall Score associated with the initial and recent versions, along with any intermediate versions (top right), aggregate metrics for all packages in the selected timeframe across for specific FAIR categories (bottom left), and aggregate FAIR metrics for all months since the inception of the ADC repository, with selected timeframe highlighted in gray (bottom right).
  
If you click on any of the data points for a specific package in the upper right pane, you are then able to examine each of the 54 checks that are made across the four FAIR categories using the tab for "Individual Checks - Data Package" in between the upper and lower panels.

Please note three things: 1) the data is current as of 2021-01-21 22:42:13 PT, so all time selections should include a range prior to that period, and 2) a data point must be selected in the upper right-hand pane prior to examining package-specific check information or an error will show.



### Software

These analyses were performed in R (4.0.2) on the Aurora server operated by NCEAS at the University of California Santa Barbara.



## Acknowledgments

Work on these analyses and dashboard was supported by the National Center for Ecological Analysis and Synthesis (NCEAS) and the Arctic Data Center (ADC), as part of my Data Science Fellowship. NCEAS is a Center funded by the University of California, Santa Barbara, and the State of California. The ADC is the primary data and software repository for the Arctic section of National Science Foundation’s Office of Polar Programs.

