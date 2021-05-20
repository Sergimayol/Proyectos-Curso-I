function P = generarMatrizPermutacion(permutation, by_row)
  n=length(permutation);
  P = eye(n);
  temp = eye(n);
  if by_row
    for i=1:n
      P(i,:) = temp(permutation(i),:);  
    endfor
  else
    for i=1:n
      P(:,i)=temp(:,permutation(i));    
    endfor
  endif
endfunction