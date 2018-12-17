function Y=rescale(X)
%rescale the matrix X to [0,255]
maxX=max(max(X));minX=min(min(X));
Y=(X-minX)./(maxX-minX)*255;