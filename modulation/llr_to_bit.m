


function bits = llr_to_bit(LLRs)  %  LLRs to bits


  bits = zeros(size(LLRs));
  
  bits(LLRs < 0) = 1;

end
