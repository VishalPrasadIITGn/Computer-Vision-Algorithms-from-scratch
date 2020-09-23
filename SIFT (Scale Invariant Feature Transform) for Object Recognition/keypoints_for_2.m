function [keypoints_loc]=keypoints_for_2(I1,I2)
keypoints=[];
keypoints_loc=[];
[r1 c1]=size(I1);
for i=2:r1-1
        for j=2:c1-1
            upper_plane=I1(i-1:i+1,j-1:j+1);%creating neighborhood
            lower_plane=I2(i-1:i+1,j-1:j+1);
            max_up=max(max(upper_plane));%calculating maxima and minima
            max_low=max(max(lower_plane));
            min_up=min(min(upper_plane));
            min_low=min(min(lower_plane));
        
     if (I1(i,j)>max_low && I1(i,j)==max_up) || (I1(i,j)==min_up && I1(i,j)<min_low) 
                keypoints=[keypoints I1(i,j)];
                keypoints_loc=[keypoints_loc i j];  %alloting keypoint
                
         end
      end
end
end