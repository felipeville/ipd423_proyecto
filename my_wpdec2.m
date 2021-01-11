function Xrec = my_wpdec2(X,Xmb,psi,type)

    [cA,cH,cV,cD] = dwt2(X,psi);
    if size(cA,1) > 64
        cA = my_wpdec2(cA,Xmb,psi,'a');
        cH = my_wpdec2(cH,Xmb,psi,'d');
        cV = my_wpdec2(cV,Xmb,psi,'d');
        cD = my_wpdec2(cD,Xmb,psi,'d');
    end
    k = log2(size(cA,1)/32);
    
    [MB, mask] = detectMB2(Xmb, 4-k);
    if type == 'a'
        Ad = direcInterp(cA, MB);
        if k > 1
            Ad = blending(Ad, mask);
        end
        E = edge(Ad,'canny', [0.05 0.4], sqrt(2));
        cA = edgeInterp(Ad, E, MB);
        
        cH = direcInterp(cH, MB,1);
        cV = direcInterp(cV, MB,1);
        cD = direcInterp(cD, MB,1);
    else 
        cA = direcInterp(cA, MB);
        cH = direcInterp(cH, MB);
        cV = direcInterp(cV, MB);
        cD = direcInterp(cD, MB);
    end
    Xrec = idwt2(cA, cH, cV, cD, psi);
end