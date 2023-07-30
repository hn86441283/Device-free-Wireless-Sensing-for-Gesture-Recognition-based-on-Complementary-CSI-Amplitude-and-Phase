%%%%%%%%%%data is a 1x30 row vector%%%%%%%%%%%%%%%%%
function phase = phase_calibration(data) 
[row,col] = size(data);

%%%%%Drawing the original phase diagram%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1 : row
%     figure(1)
%     plot(1:30,data(i,1:30),'-o','linewidth',2,'markersize',10);
%     hold on;
%     xlabel('subcarrier index','FontSize',18);
%    ylabel('Phase of the original measurement','FontSize',18);
% end
% for i = 1 : row
%     figure(1)
%     plot(1:30,data(i,1:30));
%     hold on;
%     xlabel('Subcarrier index number','FontSize',18);
%    ylabel('Phase of the original measuremen','FontSize',18);
% end
%%%%%unwrapped%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : row
    data(i,1:30) = unwrap(data(i,1:30));
end


% %%%%%Draw the phase after unwrapping%%%%%%%%%%%%%%%%
% figure(4)
% plot(1:30,data(1,1:30));
% hold on;
% xlabel('subcarrier index','FontSize',18);
% ylabel('unwrapped phase (radian)','FontSize',18);

% plot(1:30,data(2,1:30),'-go','linewidth',2,'markeredgecolor','b','markerfacecolor','y','markersize',10);
% hold on;
% plot(1:30,data(3,1:30),'-bo','linewidth',2,'markeredgecolor','b','markerfacecolor','k','markersize',10);


%%%%%%%%Subcarrier indexing at 20M bandwidth%%%%%%%%%
k = zeros(30,1);
k(1:14,1) = -28: 2 : -2;
k(15,1) = -1;
k(16:29,1) = 1 : 2 : 27;
k(30,1) = 28;
%%%%%%%%Subcarrier indexing at 40M bandwidth%%%%%%%%%
% k = zeros(30,1);
% k(1:30,1) = -58: 4 : 58;

phase = zeros(row,col);    %Guaranteed column is 30
%phase = zeros(3,30);
for i = 1 : row   
    a = (data(i,30)-data(i,1))/(k(30,1)-k(1,1));
    b = sum(data(i,1:30),2)/30;
    for j = 1 : 30   
        phase(i,j) = data(i,j)-(a*k(j,1)+b);
    end
end
%%%%
% for i = 1 : row
%     figure(5)
%     plot(1:30,phase(i,1:30),'b');
%     hold on;
%     xlabel('Subcarrier index number','FontSize',18);
% ylabel('Linear transformation and phase after unwrapping','FontSize',18);
% end
end

% plot(1:30,phase(1,1:30),'-ro','linewidth',2,'markeredgecolor','b','markerfacecolor','m','markersize',10);
% hold on;
% plot(1:30,phase(2,1:30),'-go','linewidth',2,'markeredgecolor','b','markerfacecolor','y','markersize',10);
% hold on;
% plot(1:30,phase(3,1:30),'-bo','linewidth',2,'markeredgecolor','b','markerfacecolor','k','markersize',10);
% 
