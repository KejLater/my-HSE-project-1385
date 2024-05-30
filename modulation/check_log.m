

function f = check_log(num)

  if isinf(num)
    num = realmax;
  
  elseif (num <= 0)
    num = eps;
  
  end
  
  f = log(num);

end

