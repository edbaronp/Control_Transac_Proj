function [K]=DistCons(G,MST)
Pd=G;
P=zeros(1,length(G));
N=zeros(1,length(G));

for j=1:length(G)
    for i=1:length(G)
      if(MST(i,j)==1)
       P(j)=P(j)+Pd(i);
       N(j)=N(j)+1;
      end
    end
end
Pd(:,2)=Pd(:)+P(:);

for k=3:length(G)+1
P=zeros(1,length(G));
    for j=1:length(G)
        for i=1:length(G)
            if(MST(i,j)==1)
                P(j)=P(j)+Pd(i,k-1);
            end 
        end
    Pd(j,k)=P(j)+(1-N(j))*Pd(j,k-2);
    end
end
K=Pd(:,length(G)+1);