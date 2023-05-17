# Description
This repository is a fully functional pipeline for meniscus shape modeling. The description and application of this methodology can be found in the paper cited below. In general, tissue segmentation masks are preprocessed to extract the meniscus. Each meniscus (lateral and medial) is then transformed into surface mesh representations. At this point, all data is characterized by the x, y, and z coordinates of the meniscus surface geometries. A single atlas is selected and all other menisci are registered to the coordinate system of the atlas. PCA is then performed to condense the dimensionality of the data to a manageable and interpretable PC space, with each PC dimension being representative of a variation in geometric shape.

# Version
This code was originally developed in Matlab version R2015b (MathWorks Inc., Natick, Massachusetts) and has been adapted and tested in Matlab version R2021a.

# Data
A dataset is included in this repository for demo purposes. The full tissue segmentation data used in the cited work can be found here: https://www.kaggle.com/datasets/kgaooo/oai-tissue-segmentations

Prior to using the full dataset with this repository, tissue masks must be converted from the compressed numpy format to the Matlab-compatible `.mat` filetype. Each file should be a 3D matrix, where the meniscus mask has a value of `7`.

# Usage
The pipeline consists of three main methods. An atlas should be identified. See cited work for one way to select an atlas. Additionally, a text file is to be generated listing the path to all tissue masks.

## `mesh_match.mat` <br />
**Function**: transforms tissue segmentation masks of knee MRI to 3D surfaces of the menisci <br />
**Inputs**: <br />
atlas_path        : path of atlas mask in .mat format <br />
df_path           : path of text file with paths of all other masks <br />
dst               : directory to which surfaces will be saved <br />

A preliminary quality control check can be performed here to ensure proper alignment of the matching algorithm. Another text file is to be generated listing the path to all tissue meshes from `mesh_match.mat`.

## `run_pca.mat` <br />
**Function**: loads vertex data from surface meshes and performs probabilistic PCA to determine shape modes <br />
**Inputs**: <br />
df_path        : path of text file with paths of all meshes <br />
n_pc           : desired number of principal components <br />
dst            : path to which PCA variables will be saved

## `generate_shapes.mat`  <br />
**Function**: interactive script to generate and visualize shape variations after PCA

# Citation
Gao KT, Xie E, Chen V, Calivà F, Iriondo C, Souza RB, Majumdar S, Pedoia V. Large-scale Analysis of Meniscus Morphology as Risk Factor to Incidence of Osteoarthritis. Under review at Arthritis and Rheumatology.
