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
        error('�����������ʳ��Ȳ�һ�£�'); % �ж����г���
    end
    
    len = length(x);
    cp = zeros(1,len+1);
    for i = 1:len
        cp(i+1) = sum(p(1:i)); % �����ۻ�����
    end
    
    disc = zeros(m,n); % ��ʼ����ɢ�ֲ�����
    random = rand(m,n); % �����������
    for i = 1:m
        for j = 1:n
            for k = 1:len
                if random(i,j) > cp(k) % �ж�
                    disc(i,j) = x(k); % ���������ֵ�����ֲ�������
                end
            end
        end
    end
end