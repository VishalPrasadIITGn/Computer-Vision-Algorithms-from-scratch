# Computer-Vision-Algorithms-from-scratch
This repo contains Implementation of Computer vision algorithms from scratch in MATLAB. The results obtained are also shown.
Following Algorithms are implemented from scratch in MATLAB and their results are also shown.
## 1. Image and video denoising by sparse 3D transform-domain collaborative filtering [Link to Paper](http://www.cs.tut.fi/~foi/GCF-BM3D/)
Image de-noising is performed using 3D transform-domain collaborative filtering.
### Algorithm
BM3D algorithm is shown below
![BM3D algorithm](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Image%20and%20video%20denoising%20by%20sparse%203D%20transform-domain%20collaborative%20filtering/block%20diagram.PNG)
### Results
Result for denoising are shown below. 
Image on the left is noisy input image. Image on the right is de-noised image obtained by code.

![Image denoising2](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Image%20and%20video%20denoising%20by%20sparse%203D%20transform-domain%20collaborative%20filtering/results3.PNG)
![Image de-noising](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Image%20and%20video%20denoising%20by%20sparse%203D%20transform-domain%20collaborative%20filtering/results2.PNG)

Here de-noising is performed for higher noise values in input image. In the second image, the amount of noise present is very high, still the code manages to produce decent output and recover patterns present in original images.
![Image denoising 3](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Image%20and%20video%20denoising%20by%20sparse%203D%20transform-domain%20collaborative%20filtering/results4.PNG)

This image shows input image, noisy image, output of first stage and final output of the code.
![Image denoising](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Image%20and%20video%20denoising%20by%20sparse%203D%20transform-domain%20collaborative%20filtering/results1.PNG)


## 2. Panorama creation and Image stitching [Link to paper](https://idp.springer.com/authorize/casa?redirect_uri=https://link.springer.com/content/pdf/10.1007/s11263-006-0002-3.pdf&casa_token=-HqEB0GCx84AAAAA:V9rNRgD7vQ9gh1ufw_-n1aJkc0iirA45qTE8MquuFj73oMKenCjIz2Y4qFeUEpHmr-BDFxWY_0H8S4pRDw)
Combining multiple images and creating a panaroma using extracted features and matching keypoints in both images.
## Input Images
![Input Image 1](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Panaroma%20creation%20and%20Image%20Stitching/im_0.jpg)
![Input Image 2](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Panaroma%20creation%20and%20Image%20Stitching/im_1.jpg)
![Input Image 3](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Panaroma%20creation%20and%20Image%20Stitching/im_2.jpg)
## Results: Output Panorama
![Output Image](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Panaroma%20creation%20and%20Image%20Stitching/resGithub.jpg)
This was created withouth using interpolation to fill in the missing pixel values.

## 3. Edge Detection and Convolution with Gaussian Filter
Convolution with Gaussian Filters and then using Difference of Gaussian filter to perform edge detection.
### Results
#### Results for convolution with Gaussian Filter with varying sigma
![Convolution with Gussian Filter](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Edge%20detection%20and%20Convolution%20with%20Gaussian%20filter/Convolution%20with%20Gaussian%20results.PNG)

#### Results for Edge Detection
![Edge Detection](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Edge%20detection%20and%20Convolution%20with%20Gaussian%20filter/Edge%20Detections%20using%20Difference%20of%20Gaissian%20results.PNG)

## 4. SIFT (Scale Invariant Feature Transform) for object Recognition.[Link to paper](https://ieeexplore.ieee.org/abstract/document/790410/)
SIFT is a highly cited paper for feature extraction and object recognition. It is implemented from scratch and SIFT features are extracted.
### Results for SIFT
![SIFT descriptors](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/SIFT%20(Scale%20Invariant%20Feature%20Transform)%20for%20Object%20Recognition/SIFT%20results.PNG)

## 5. Stereo image correspondences using Fundamental matrix
Pixel realignement was performed between a set of stereo images.
### Results
#### Input image 1
![Input image 1](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Stereo%20image%20correspondences%20using%20Fundamental%20matrix/3_1.jpg)
#### Input image 2
![Input image 2](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Stereo%20image%20correspondences%20using%20Fundamental%20matrix/3_2.jpg)
### Output image (original images were resized to reduce the computation)
Pixels of second image were realigned to resemble/recreate the first image.
![results](https://github.com/VishalPrasadIITGn/Computer-Vision-Algorithms-from-scratch/blob/master/Stereo%20image%20correspondences%20using%20Fundamental%20matrix/results1.PNG)
