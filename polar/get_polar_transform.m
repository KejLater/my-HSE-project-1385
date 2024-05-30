function Gn = get_polar_transform(n)

G2 = [1 0; 1 1];
Gn = G2;


    for i= 1:(n-1)
        Gn = kron(G2, Gn);
    end

end

