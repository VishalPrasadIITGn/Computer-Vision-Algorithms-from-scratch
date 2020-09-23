README FILE 
ASSIGNMENT 2(3DCV)
VISHAL PRASAD (18210095)
1. Open sift_last_try
	it uses four functions- keypoints for 2,keypoints for 4,sobel_op,magtheta33,sift des2.
		
	  keypoints for 2- it finds ketpoint by comparing two planes only as the third plane is not available.(it is used for bottom and top layer)
		
	keypoints for 4 -it finds ketpoint by comparing three planes.
	
	sobel_op- it finds validity of keypoint by appling corner-harris detector.

	magtheta33- it finds dominant orientation for the key point and its magnititude and stores it in Mxy,Txy.
			(here x stands for octave and y stands for scale).
	
	sift_des2- it finds sift descriptor for the keypoint. It returns two values. 

		   Dxy for 16x8 format of descriptor. And dxy for all 128 dimension conctenated descriptor for that scale.