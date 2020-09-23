function [x y]=bresenham(x1,y1,x2,y2)

x1=round(x1);
x2=round(x2);

y1=round(y1);
y2=round(y2);

dx=abs(x2-x1);
dy=abs(y2-y1);
sp=abs(dy)>abs(dx);
if sp t=dx;dx=dy;dy=t; end

if dy==0 
    temp=zeros(dx+1,1);
else
    temp=[0;diff(mod([floor(dx/2):-dy:-dy*dx+floor(dx/2)]',dx))>=0];
end

if sp
    if y1<=y2 y=[y1:y2]'; else y=[y1:-1:y2]'; end
    if x1<=x2 x=x1+cumsum(temp);else x=x1-cumsum(temp); end
else
    if x1<=x2 x=[x1:x2]'; else x=[x1:-1:x2]'; end
    if y1<=y2 y=y1+cumsum(temp);else y=y1-cumsum(temp); end
end