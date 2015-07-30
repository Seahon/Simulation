function disc = discrnd(x, p, m, n)
%DISCRND Random arrays from discrete cumulative distribution.
%   R = DISCRND(X,P,M,N) returns an M-by-N array of random numbers chosen 
%   from the discrete cumulative distribution. 
%
%   X refers to a sequence of random variables, while P refers to a sequence 
%   of probabilities matchinhg each random variable from X.

%   Copyright Seahon
%   $Date: 2014/2/19 14:31:30 $

    if length(x) ~= length(p)
        error('随机变量与概率长度不一致！'); % 判断序列长度
    end
    
    len = length(x);
    cp = zeros(1,len+1);
    for i = 1:len
        cp(i+1) = sum(p(1:i)); % 计算累积概率
    end
    
    disc = zeros(m,n); % 初始化离散分布矩阵
    random = rand(m,n); % 生成随机矩阵
    for i = 1:m
        for j = 1:n
            for k = 1:len
                if random(i,j) > cp(k) % 判断
                    disc(i,j) = x(k); % 将随机变量值赋到分布矩阵上
                end
            end
        end
    end
end