function [L, U, p] = PA_LUFact(A)
    n = size(A, 1);
    L = eye(n);
    p = 1 : n;
    for k = 1 : n - 1       
        z = k;
        for j = k : n
            if abs(A(z, k)) < abs(A(j, k))
                z = j;
            end
        end
        
        if A(z, k) == 0
            printf("No admite fact LU")
            return
        end
        
        if z ~= k
            linP = A(z, :);
            A(z, :) = A(k, :);
            A(k, :) = linP;
            
            wP = p(z);
            p(z) = p(k);
            p(k) = wP;
            
            if k > 1
                subLinP = L(z, 1 : k - 1);
                L(z, 1 : k - 1) = L(k, 1 : k - 1);
                L(k, 1 : k - 1) = subLinP;
            end
        end
        
        for l = k + 1 : n
            L(l, k) = A(l, k) / A(k, k);
            A(l, :) = A(l, :) - L(l, k) * A(k, :);
        end
    end
    
    if A(n, n) == 0
            printf("No admite fact LU")
        return;
    end
    
    U = A;
end