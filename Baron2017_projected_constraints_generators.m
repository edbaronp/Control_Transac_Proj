%%%% Economic Dispatch with Projections
%%%% Baron-Prada2017

clc
clear all

%%%% Inputs %%%%
%Graph Declaration%
nodes=4;
Adj=[-2 1 0 1;
     1 -2 1 0;
     0 1 -2 1;
     1 0 1 -2];
x=[1; 1; 1; 1];
Fprom=zeros(1,nodes);
iter=90000;
alpha=0.8;
beta=1;
%Generator Charateristics
pnom1=2000; pnom2=3000;pnom3=4000;pnom4=5000;
c=[0.1;0.15;0.2;0.25] ;
%Generation Constraints
Pmin=[1;1;1;1];
Pmax=[pnom1*beta;pnom2*beta;pnom3*beta;pnom4*beta];
%Rate of change
TC=[1;1;1;1];
%Load
L=[4000;000;00;00]
Pd=4000;
U=L;
Cg=zeros(nodes,1);
M=zeros(nodes,1);
for k=1:iter
 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         U=[4000;3000;500;0]
         Pd=sum(U);
     end    
    if (k==60000)
       U=[2000;2000;1000;0]
       Pd=sum(U);
    end 
%%%%%%%%%%%% Spanning Tree %%%%%%%%%%
MST=[0 1 0 0;
     1 0 1 0;
     0 1 0 1;
     0 0 1 0];

%%%%%%%%%%% Finite- Time Distributed Averaging %%%%%%%%
    if (U(1)~=L(1) || U(2)~=L(2)||U(3)~=L(3)||U(4)~=L(4) || k==1)  
    M(:,k+1)=DistCons(U,MST);
    L=U;
    else
    M(:,k+1)=M(:,k);
    end
    
    if (mod(k,100)==0 || k==1)
    Cg(:,k+1)=DistCons(c(:).*x(:,k),MST)./M(:,k);
    else
    Cg(:,k+1)=Cg(:,k);
    end

    
    
%%%%%%%%%%%%%%%%Gradient variable algorithm%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Consensus%%%%
for j=1:nodes
t=0;
for i=1:nodes
    if(Adj(i,j)==1)
       Fprom(1,j)=Fprom(1,j)+x(i,k);
       t=t+1;
    end
end
Fprom(1,j)=Fprom(1,j)/t;
end

%%%%%%%%%Update variables%%%%%%%%%%%
der=[1/c(1)*(1-x(1,k)/pnom1);
     1/c(2)*(1-x(2,k)/pnom2); 
     1/c(3)*(1-x(3,k)/pnom3);
     1/c(4)*(1-x(4,k)/pnom4)];

x(:,k+1)=-x(:,k)+(Fprom(:)-alpha*der(:));

%%%%%Projected Constrains%%%%%
%%%%%Virtual Agent Global Constraint%%%%%%%%
x(:,k+1)= x(:,k+1)-(((transpose(ones(4,1))*x(:,k+1)-Pd)/nodes)*ones(4,1));

%%%%% Local Rate of change constraint%%%%
for e=1:nodes
  if(x(e,k+1)-x(e,k)>TC(e))
       x(e,k+1)=x(e,k)+TC(e);
  end
  if(x(e,k+1)-x(e,k)<-TC(e))
       x(e,k+1)=x(e,k)-TC(e);
  end
end
%%%%% Local Generation constraints%%%%
for q=1:nodes
  if(x(q,k+1)<Pmin(q))
       x(q,k+1)=Pmin(q);
  end
end

for w=1:nodes
  if(x(w,k+1)>Pmax(w))
       x(w,k+1)=Pmax(w);
  end
end

v(:,k)=((ones(1,nodes)*x(:,k+1))-Pd)/Pd*100;

end


% subplot(3,1,1)
% subplot(3,1,2)
 plot(transpose(x))
% grid on
% subplot(3,1,3)
% plot(transpose(v))
% grid on

sum(x(:,30000))
sum(x(:,60000))
sum(x(:,k+1))