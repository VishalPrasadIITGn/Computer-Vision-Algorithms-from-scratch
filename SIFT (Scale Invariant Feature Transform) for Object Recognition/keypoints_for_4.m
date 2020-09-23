function [keypoints_loc]=keypoints_for_4(I1,I2,I3)
keypoints=[];
keypoints_loc=[];
[r1 c1]=size(I1);
for i=2:r1-1
        for j=2:c1-1
            upper_plane=I1(i-1:i+1,j-1:j+1);    %creating neighborhood
            middle_plane=I2(i-1:i+1,j-1:j+1);
            lower_plane=I3(i-1:i+1,j-1:j+1);
            max_up=max(max(upper_plane));   %calculating maxima and minima in neighbd
            max_mid=max(max(middle_plane));
            max_low=max(max(lower_plane));
            min_up=min(min(upper_plane));
            min_mid=min(min(middle_plane));
            min_low=min(min(lower_plane));
        
     if (I2(i,j)>max_up && I2(i,j)>max_low && I2(i,j)==max_mid) || (I2(i,j)<min_up && I2(i,j)<min_low && I2(i,j)==min_mid) 
                keypoints=[keypoints I2(i,j)];
                keypoints_loc=[keypoints_loc i j];
            end
        end
end
end