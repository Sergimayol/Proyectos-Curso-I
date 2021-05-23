#Ejercicio 1:

A = [-1,-3,3,-1,-1;-3,-1,3,-1,-1;9,9,-9,3,3;-2,-2,2,2,-2;-2,-2,2,-2,2];
[L,U]=lu(A);
[L,U,P]=lu(A);
for i=10
  disp(x);
endfor
b=[0;0;0;1;0];
b1=P*b;
y=susprog(L,b1);
x=susreg(U,y);
