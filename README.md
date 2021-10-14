# Exploiting Deep Neural Networks and Head Movements for Robust Binaural Localization of Multiple Sources in Reverberant Environments code
The code presented in the current repository attempts to replicate the proposed method of N. Ma, T. May and G. J. Brown, "Exploiting Deep Neural Networks and Head Movements for Robust Binaural Localization of Multiple Sources in Reverberant Environments," in IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 25, no. 12, pp. 2444-2453, Dec. 2017, doi: 10.1109/TASLP.2017.2750760. URL: https://ieeexplore.ieee.org/document/8086216

### DISCLAIMER: This is not official code by the authors of the above mentioned work. Every piece of this software is provided "AS IS", without warranty of any kind.

Please note that currently, the head rotation mechanism has not yet been implemented. 

MATLAB handles the binaural file generation as well as the binaural feature extraction. Specifically the functions `generate_data_Surrey` and `generate_data_Training` generate the test and training data respectively while `extract_features` as the name implies, is responsible for extracting the CCF and ILD parameters from each of the audio files. The other *.m files are helper functions. The data required by the functions are available online at the following links:

Surrey BRIRs: https://github.com/IoSR-Surrey/RealRoomBRIRs

TIMIT Database: https://catalog.ldc.upenn.edu/LDC93s1

SADIE II: https://www.york.ac.uk/sadie-project/database.html


Python is responsible for training the Neural Networks and performing the final method evaluation. All operations are performed in the included notebook. The trained models are included in the trained_models folder.
