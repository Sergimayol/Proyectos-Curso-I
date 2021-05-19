function [L, U, w] = PA_LUFact(A)
    n = size(A, 1);
    L = eye(n);
    w = 1 : n;
    
    for k = 1 : n - 1
%         L
%         A
        
        p = k;
        for j = k : n
            if abs(A(p, k)) < abs(A(j, k))
                p = j;
            end
        end
        
        if A(p, k) == 0
            printf("A nu admite fact LU")
            return
        end
        
        if p ~= k
            linP = A(p, :);
            A(p, :) = A(k, :);
            A(k, :) = linP;
            
            wP = w(p);
            w(p) = w(k);
            w(k) = wP;
            
            if k > 1
                subLinP = L(p, 1 : k - 1);
                L(p, 1 : k - 1) = L(k, 1 : k - 1);
                L(k, 1 : k - 1) = subLinP;
            end
        end
        
        for l = k + 1 : n
            L(l, k) = A(l, k) / A(k, k);
            A(l, :) = A(l, :) - L(l, k) * A(k, :);
        end
    end
    
    if A(n, n) == 0
        printf("A nu admite fact LU");
        return;
    end
    
    U = A;
end
