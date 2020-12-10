function Y = direcInterp2(X, MB)
    M = size(X,1);  N = size(X,2);
    Y = zeros(M+4, N+4);
    Y(3:M+2,3:N+2) = X;
    len = length(MB);
    
    for j = 1:len
       m = MB(j,1) + 2; n = MB(j,2) + 2;
       E = zeros(3,3);
       ROI = Y(m-1:m+1, n-2:n+2);
       
       % Horizontal
       E_1 = ROI(1,2) - ROI(2,2);   E_2 = ROI(1,4) - ROI(2,4);
       E(1,2) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       E_1 = ROI(3,2) - ROI(2,2);   E_2 = ROI(3,4) - ROI(2,4);
       E(3,2) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       % Vertical
       E_1 = ROI(1,2) - ROI(1,3);   E_2 = ROI(3,2) - ROI(3,3);
       E(2,1) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       E_1 = ROI(1,4) - ROI(1,3);   E_2 = ROI(3,4) - ROI(3,3);
       E(2,3) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       % Cross
       E_1 = ROI(1,1) - ROI(2,2);   E_2 = ROI(1,3) - ROI(2,4);
       E(1,1) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       E_1 = ROI(1,5) - ROI(2,4);   E_2 = ROI(1,3) - ROI(2,2);
       E(1,3) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       E_1 = ROI(3,1) - ROI(2,2);   E_2 = ROI(3,3) - ROI(2,4);
       E(3,1) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       E_1 = ROI(3,5) - ROI(2,4);   E_2 = ROI(3,3) - ROI(2,2);
       E(3,3) = 0.5*(E_1 + E_2)*(E_1*E_2 >= 0);
       
       W = E/sum(E,'all');
       
       Y(m,n) = sum(W.*(Y(m-1:m+1,n-1:n+1) + E),'all');
       
    end
    
    Y = Y(3:M+2, 3:N+2);
    
end