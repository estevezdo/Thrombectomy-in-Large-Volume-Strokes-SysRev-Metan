#*----------------------------------------------------------------*
#*Name: IAT in Large Stroke Meta-analysis of RCT
#*Author: Dagoberto Estevez-Ordonez, MD
#*Purpose: Meta-analysis of RCT
#*----------------------------------------------------------------*

library(readxl)
library(genodds)

# Define the file path
file_path <- "/iatGenOddsNNT.xlsx"
# Import the Excel file
iatData <- read_excel(file_path)

## Verifying that data is ok

# Tabulate the 'treat' variable in iatData
treat_table <- table(iatData$treat)
# Display the tabulated data
print(treat_table)

# Tabulate the 'study' variable in iatData
study_table <- table(iatData$study)
# Display the tabulated data
print(study_table)

# Tabulate the 'mRS' variable in iatData
mRS_table <- table(iatData$mRS)
# Display the tabulated data
print(mRS_table)


### Now analyzing using Agresti's generalized odds ratio
#Agresti, A. (1980). Generalized odds ratios for ordinal data. Biometrics, 59-67.
analysis <- genodds(iatData$mRS,iatData$treat,iatData$study,ties="drop")
analysis
print(analysis,nnt=TRUE)
