% function ATC = main(reorderPoint,orderQuantity)
function [ATC, AC1, AC2, AC3]= main(reorderPoint,orderQuantity)

    % Configuration
    len = 1000; % Simulation length
    num = 10; % Number of independent replicate simulation experiment
    c1 = 25; % Order cost per time
    c2 = 10; % Weekly holding cost per quantity
    c3 = 100; % Shortage cost per quantity
    xD = [0 1 2 3 4 5 6]; % Serie of demand's random variables
    pD = [.02 .08 .22 .34 .18 .09 .07]; % Serie of demand's probabilities
    xLT = [1 2 3 4 5]; % Serie of lead time's random variables
    pLT = [.23 .45 .17 .09 .06]; % Serie of lead time's probabilities
    C1 = zeros(num,1);
    C2 = zeros(num,1);
    C3 = zeros(num,1);
    TC = zeros(num,1);
    
    % Simulation
    for t = 1:num
        
        % Initialization
        stock = zeros(1,len+1);
        order = zeros(1,len);
        shortage = zeros(1,len);
        holding = zeros(1,len);
        stock(1) = 15; % Initial stock
        flag = 0; % Limit the order time
        D = discrnd(xD,pD,1,len); % Each period's demand
        LT = discrnd(xLT,pLT,1,len); % Each period's lead time
        
        for i = 1:len
            if order(i) ~= 0
                stock(i) = stock(i) + order(i); % Updata stock
                flag = 0;
            end
            if D(i) <= stock(i)
                stock(i+1) = stock(i) - D(i); % Fulfil demand
                holding(i) = stock(i+1);
            else
                shortage(i) = D(i); % Count shortage
                stock(i+1) = stock(i);
            end
            if stock(i+1) <= reorderPoint && flag == 0
                order(i+LT(i)) = orderQuantity; % Reorder
                flag = 1;
            end
        end
    
        %Statistics
        C1(t) = c1*sum(order(1:len))/orderQuantity; % Calculate order cost
        C2(t) = c2*sum(holding(1:len)); % Calculate holding cost
        C3(t) = c3*sum(shortage(1:len)); % Calculate shortage cost
        TC(t) = C1(t)+C2(t)+C3(t);
    end
    AC1 = mean(C1)/len;
    AC2 = mean(C2)/len;
    AC3 = mean(C3)/len;
    ATC = mean(TC)/len; % Calculate total cost and return it

%     Plotting
%     figure();
%     hold on;
%     plot(0:n,stock,'g');
%     plot(1:n,D);
%     plot(0:n,reorderPoint*ones(1,n+1),'r');
%     legend('Stock','Demand','Reorder Point');
%     xlabel('Period');
%     ylabel('Quantity');
end
