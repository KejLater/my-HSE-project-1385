function decoded = SC_decoder(bits,  K)
    
    
    N = length(bits);
    n = log2(N);
    
    %  последовательность каналов из стандарта 3GPP 38.212 
    rel_seq= load('data.mat').NR_sequence;
    rel_seq = rel_seq  +  1;

    rel_seq = rel_seq(rel_seq<=N); 
    frozen_bits = rel_seq(1:N-K);  % замороженные биты

    r = bits;

    L = zeros(n + 1, N); 
    decoded = zeros(n + 1, N); 
    node_state = zeros(1, 2 * N-1); 
    
    f = @(a, b) (1-2 * (a<0)) .* (1-2 * (b<0)) .* min(abs(a), abs(b)); 
    g = @(a, b, c) b  +  (1-2 * c)  .*  a; 
    
    L(1, :) = r; 
    
    node = 0; 
    depth = 0; 
    done = 0; 

    while (done == 0) 
        
        if depth == n
            if any(frozen_bits==(node + 1)) 
                decoded(n + 1, node + 1) = 0;
            else
                if L(n + 1, node + 1) >= 0
                    decoded(n + 1, node + 1) = 0;
                else
                    decoded(n + 1, node + 1) = 1;
                end
            end
            if node == (N-1)
                done = 1;
            else
                node = floor(node/2); 
                depth = depth - 1;
            end
        else
            
            node_position = (2^depth-1)  +  node  +  1; 

            if node_state(node_position) == 0 
               
                temp = 2^(n-depth);
                Ln = L(depth + 1, temp * node + 1:temp * (node + 1)); 
                a = Ln(1:temp/2); 
                b = Ln(temp/2 + 1:end); 
                node = node  * 2; 
                depth = depth  +  1; 
                temp = temp / 2; 
                L(depth + 1, temp * node + 1:temp * (node + 1)) = f(a, b); 
                node_state(node_position) = 1;

            else
                if node_state(node_position) == 1 
                    temp = 2^(n-depth);
                    Ln = L(depth + 1, temp * node + 1:temp * (node + 1)); 
                    a = Ln(1:temp/2); 
                    b = Ln(temp/2 + 1:end); 
                    left_node = 2 * node; 
                    left_depth = depth  +  1; 
                    left_temp = temp/2;
                    decodedn = decoded(left_depth + 1, left_temp * left_node + 1:left_temp * (left_node + 1)); 
                    node = node  * 2  +  1; 
                    depth = depth  +  1; 
                    temp = temp / 2; 
                    L(depth + 1, temp * node + 1:temp * (node + 1)) = g(a, b, decodedn);
                    node_state(node_position) = 2;

                else 
                    temp = 2^(n-depth);
                    left_node = 2 * node; rnode = 2 * node  +  1; cdepth = depth  +  1; 
                    ctemp = temp/2;
                    decoded_left  = decoded(cdepth + 1, ctemp * left_node + 1:ctemp * (left_node + 1)); 
                    decoded_right = decoded(cdepth + 1, ctemp * rnode + 1:ctemp * (rnode + 1)); 
                    decoded(depth + 1, temp * node + 1:temp * (node + 1)) = [mod(decoded_left  + decoded_right, 2) decoded_right]; 
                    node = floor(node/2); 
                    depth = depth - 1;

                end
            end
        end
    end
    
    decoded = decoded(n + 1, rel_seq(N-K + 1:end));

end