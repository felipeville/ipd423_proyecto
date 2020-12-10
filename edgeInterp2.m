function Y = edgeInterp2(X, E, MB)
    new_MB = [];
    len = size(MB,1);
    for i = 1:len
        m = MB(i,1);    n = MB(i,2);
        if E(m,n)
            new_MB = [new_MB; m n];
        end
    end
    Y = direcInterp(X, new_MB, 1);
end