function nFS2 = new_FS2(X)%NFS2 
 
[ro,co] = size(X); 
type = unique(X(:,end)); 
type_x = length(type); mu_x = zeros(type_x,co-1); var_x = zeros(type_x,co-1); 
sb1 = zeros(1,co-1); micxx = zeros(1,co-1); 
for j = 1:co-1 
%      if j<co-1 
%          for t = j+1:co-1 
%              temx =   mine(X(:,j)',X(:,t)'); 
%              micxx(j) = micxx(j)+temx.mic; 
%          end 
%      end 
     for i = 1:type_x 
         if i==1 
             fk = X(X(:,co)==type(i),j); 
             mu_x(i,j) = mean(fk); 
             var_x(i,j) = var(fk); 
         else 
             fk = gk; 
         end 
         if i<type_x 
             for k = i+1:type_x 
                 gk = X(X(:,co)==type(k),j); 
                 mu_x(k,j) = mean(gk); 
                 var_x(k,j) = var(gk); 
                 overlap = overlapping(fk,gk,ro);%overlapping 
 
                 sb1(j) = sb1(j)+(mu_x(i,j)-mu_x(k,j))^2*overlap; 
             end 
         end     
     end 
end 
e = 1e-4; 
micxx = 1;
nFS2 = (sb1+e)./(sum(var_x)+e).*micxx; 
end 