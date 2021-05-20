#TRIANGULAR SUPERIOR
function[x]=susreg(U,b)
n=length(b);
x=zeros(n,1);
for k=n:-1:1
  x(k)=b(k)/U(k,k);
  for i=1:k-1
    b(i)=b(i)-x(k)*U(i,k);
    endfor
  endfor
endfunction