function result = approxequals(A,B,tol)
if nargin < 3
    tol = 1e-6;
end

if abs(A-B) < tol
    result = true;
else
    result = false;
end