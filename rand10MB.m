% random 10% noise gen
function W = rand10MB()
    N = 64;
    k = floor(62*62*0.1);
    q = randperm(62*62, k);
    w = zeros(62*62,1);
    w(q) = 1;
    w = reshape(w, 62, 62);
    W = zeros(N,N);
    W(2:N-1,2:N-1) = w;
    W = 1 - W;
    W = imresize(W, 8, 'nearest');
end
