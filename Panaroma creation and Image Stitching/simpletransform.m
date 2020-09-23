%this function transform co-ordinates based on homography matrix
function [tx,ty] = simpletransform(xyz,A)   %A is homography matrix
    tx = floor(((A(1,1:2)*xyz'+A(1,3))./(A(3,1:2)*xyz'+A(3,3)))); %NOTE REMOVED +1
     ty= floor(((A(2,1:2)*xyz'+A(2,3))./(A(3,1:2)*xyz'+A(3,3))));
end
