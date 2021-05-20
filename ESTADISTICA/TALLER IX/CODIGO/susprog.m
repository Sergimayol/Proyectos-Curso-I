#TRAINGULAR INFERIOR
function[x]=susprog(L,b)
n=length(b);
x=zeros(n,1);
for k=1:n
  x(k)=b(k)/L(k,k);
  for i=k+1:n
    b(i)=b(i)-x(k)*L(i,k);
    endfor
  endfor
endfunction