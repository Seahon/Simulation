function ATC= sim_Q_r(r, Q)
	
    % 设置
    len = 1000; 						% 仿真长度
    num = 10; 							% 独立仿真实验的次数
    c1 = 25; 							% 单位订货成本
    c2 = 10; 							% 单位持有成本
    c3 = 100; 							% 单位缺货成本
    xD = [0 1 2 3 4 5 6]; 					% 随机变量的取值
    pD = [.02 .08 .22 .34 .18 .09 .07]; 			% 随机需求的概率
    xLT = [1 2 3 4 5]; 						% 随机提前期的取值
    pLT = [.23 .45 .17 .09 .06]; 				% 随机提前期的概率
    C1 = zeros(num,1);
    C2 = zeros(num,1);
    C3 = zeros(num,1);
    TC = zeros(num,1);

    % 仿真
    for t = 1:num
        
        % 初始化
        stock = zeros(1,len+1);
        order = zeros(1,len);
        shortage = zeros(1,len);
        holding = zeros(1,len);
        stock(1) = 15; 						% 初始库存
        flag = 0; 						% 限制单次只能订货一次
        D = discrnd(xD,pD,1,len); 				% 生产随机需求
        LT = discrnd(xLT,pLT,1,len); 				% 生成随机提前期
        
        for i = 1:len
            if order(i) ~= 0
                stock(i) = stock(i) + order(i); 		% 库存更新
                flag = 0;
            end
            if D(i) <= stock(i)
                stock(i+1) = stock(i) - D(i); 			% 满足订单需求
                holding(i) = stock(i+1);
            else
                shortage(i) = D(i); 				% 缺货计数
                stock(i+1) = stock(i);
            end
            if stock(i+1) <= r && flag == 0
                order(i+LT(i)) = Q; 				% 再订货
                flag = 1;
            end
        end
    
        % 统计
        C1(t) = c1*sum(order(1:len))/Q; 			% 计算订货成本
        C2(t) = c2*sum(holding(1:len)); 			% 计算持有成本
        C3(t) = c3*sum(shortage(1:len)); 			% 计算缺货成本
        TC(t) = C1(t)+C2(t)+C3(t);
    end

    ATC = mean(TC)/len; 					% 计算总成本
end
