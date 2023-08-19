## Image Encryption Tests Documentation
This description was generated using chatgpt
### Prerequisites
To conduct the image encryption tests, you'll need the following:

- **GCC/G++ Compiler:** The tests involve compiling C++ code, so ensure that you have a GCC/G++ compiler installed on your system.
- **Crypto++ Library:** The encryption algorithms may require the Crypto++ library for cryptographic operations. Make sure the library is installed and configured.
- **MATLAB (Tested on Version 2021):** The tests and analysis are performed using MATLAB. The documentation assumes you have access to MATLAB version 2021 or later.
- **MATLAB Image Processing Toolbox:** Some tests may utilize functions from the Image Processing Toolbox within MATLAB. Ensure that you have access to this toolbox to execute relevant image processing tasks.
- **Test Images:** Prepare test images that will be used to evaluate the encryption algorithms. The test images should be representative of real-world scenarios.

Make sure to have all the required software and resources in place before proceeding with the tests.

### Test Procedures

#### Histogram, Entropy, and Correlation Tests
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Perform histogram analysis on the original and encrypted images.
4. Calculate the entropy of the images.
5. Analyze the correlation coefficients in different directions.
6. Display the results using MATLAB's visualization tools.

#### Differential Analysis Test

##### Simulation 1
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Display the images before and after encryption.

##### Simulation 2
1. Run a loop for multiple simulations.
2. Perturb the original image by modifying a pixel.
3. Apply encryption operations to the perturbed image.
4. Calculate and record the NPCR (Number of Pixel Change Rate) and UACI (Unified Average Change Intensity) scores.
5. Save the results in a CSV file.

#### Differential Analysis Test

##### Simulation 1
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Display the images before and after encryption.

##### Simulation 2
1. Run a loop for multiple simulations.
2. Perturb the original image by modifying a pixel.
3. Apply encryption operations to the perturbed image.
4. Calculate and record the NPCR (Number of Pixel Change Rate) and UACI (Unified Average Change Intensity) scores.
5. Save the results in a CSV file.

#### Sensitivity Analysis Test
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Perform sensitivity analysis on two different versions of the cipher-image.
4. Display the results of the sensitivity analysis.

#### Noise Attack Test
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Add white Gaussian noise or "salt and pepper" noise to the cipher-image.
4. Perform decryption using the key and the noisy cipher-image.
5. Display the noisy cipher-image and the decrypted image.

#### NIST Statistical Test Suite
1. Load the test image.
2. Apply encryption operations using the selected algorithm.
3. Convert the encryption key to binary format.
4. Write the key binary to a text file for NIST testing.

