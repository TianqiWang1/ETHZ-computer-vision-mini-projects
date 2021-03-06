% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences
%
% Output
% 	Fh 			Fundamental matrix with the det F = 0 constraint
% 	F 			Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)

%normlization as suggested in paper "defense of 8 pts algorithm"
[x1sn, T1] = normalizePoints2d( x1s )   ; 
[x2sn, T2] = normalizePoints2d( x2s )   ; 

% Construct matrix A
x1 = x1sn(1,:)' ; y1 = x1sn(2,:)' ;
x2 = x2sn(1,:)' ; y2 = x2sn(2,:)' ;

A = [ x1.*x2, y1.*x2, x2, x1.*y2, y1.*y2, y2, x1, y1, ones(size(x1,1),1) ];

% Do SVD and take last column of V as solution (reshape as a matrix)
[U,S,V] = svd(A) ;
F = V(:,end) ;

F = [   F(1) F(2) F(3) 
        F(4) F(5) F(6) 
        F(7) F(8) F(9) ] ;
    
%unscale 
F = T2'*F*T1;
 
%enforce singularity condition (as explained in paper "defense of 8 pts
%algorithm")
[U,S,V] = svd(F) ;
S(:,3) = zeros(3,1) ;
Fh = U*S*V';

end