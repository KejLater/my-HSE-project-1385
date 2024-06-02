


function decoded = bcc_viterbi_decoder(y)

y = [y [0 0]];
generetive_polynom = [1 0 1 1 0 1 1; ...
                      1 1 1 1 0 0 1]; 

k = 1;
[rows, cols] = size(generetive_polynom); 
l = cols;    
n = rows;    

trellis = de2bi(0:2^(l-k)-1, (l-k), 'left-msb');

zero_out = zeros(2^n, n);
one_out = zeros(2^n, n);

for i = 1:size(trellis, 1) 
    output = sum(bsxfun(@times, generetive_polynom, [0 trellis(i, :)]), 2); 
    zero_out(i, :) = output'; 
    output = sum(bsxfun(@times, generetive_polynom, [1 trellis(i, :)]), 2); 
    one_out(i, :) = output'; 
end

zero_out = rem(zero_out, 2); 
one_out = rem(one_out, 2); 

rows = length(y)/n; 
cols = n; 
y = reshape(y, cols, rows);

path_metric = zeros(2^(l-k), size(y, 2)+1); 
path_metric(2:end) = Inf; 
decoded = [];

first = zeros(1, 2^n); 
second = zeros(1, 2^n); 
for i = 1:size(trellis, 1)
    first(i) = find(ismember(trellis, [trellis(i, 2:(l-k)) 0], 'rows'));
    second(i) = find(ismember(trellis, [trellis(i, 2:(l-k)) 1], 'rows'));
end


for i = 1:size(path_metric, 2)-1
    received = y(:, i)'; 
    branch_metric_0 = sum(abs(zero_out - received), 2); 
    branch_metric_1 = sum(abs(one_out - received), 2); 
    branch_metric = [branch_metric_0 branch_metric_1]; 
    out = []; 

    for j = 1:size(trellis, 1)
        out = [out trellis(j, 2)];
        first_metric = path_metric(first(j), i) + branch_metric(first(j), trellis(j, 1)+1); 
        second_metric = path_metric(second(j), i) + branch_metric(second(j), trellis(j, 1)+1);  
        path_metric(j, i+1) = min(first_metric, second_metric); 
    end

    [~, min_ind] = min(path_metric(:, i+1)); 
    decoded = [decoded out(min_ind)]; 
end
decoded(1) = []; 
% decoded((end-4):end) = [];
end