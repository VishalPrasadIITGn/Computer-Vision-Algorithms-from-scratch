
function [x2 y2] = calcnorm(x,y,I1p,ori)
[r c] = size(x);
for m=1:r
             %if(x(m)>0 && x(m)<=r && y(m)>0 && y(m)<=c)
                 temp=I1p(x(m)+3:x(m)+7,y(m)+3:y(m)+7); %creating temp norms
                 diff=double(temp)-double(ori); %getting difference
                 nrm(m)=norm(diff);
             %end
             [v ind] = min(nrm);    %getting index
            
             x2 = x(ind);   %returning coordinates
             y2 = y(ind);
end
