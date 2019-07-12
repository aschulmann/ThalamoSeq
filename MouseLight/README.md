# HantmanMouseLight
## Setup
### Collect Data.
	1. Run collectNeuronData.m to grab data from database.
	1. Run collectAllenData.m to download expression data from the Allen database.
	1. Run calculateGeneScores.m to calculate the gene scores for each neuron and the PCA.
	The output of the next functions are required to run sme scripts.
	1. Run collectAllenLaplacian to generate a laplacian distance file.
	1. Run groupAnatomyAreas for info on grouping anatomy areas.
## Dependencies
* matlabdbqueries and reconstructionviewer repositories at https://github.com/MouseLightPipeline.