%%%% Economic Dispatch with Projections
%%%% Baron-Prada2017

clc
clear all

%%%% Inputs %%%%
%Graph Declaration%
nodes=15;
Edges=[5 15;5 3;5 4;2 3; 2 6; 3 1; 4 1; 4 15;
    1 6;1 9;1 8;6 7;6 13;7 13;8 11;14 11;
    8 12;9 11;10 3;10 2;11 12;12 13;2 7;
    14 15; 14 4; 9 4; 8 9;10 5;14 9;3 6; 13 8];
power=ones(nodes,1);
%%%%% System global values%%%%%%%
Function_prom=zeros(1,nodes);
Global_cost=zeros(nodes,1);
Power_demanded=zeros(nodes,1);
Power_generated=zeros(nodes,1);
%%%%% N鷐ero de nodos
Number_generators=zeros(nodes,1);%Numero de generadores
<<<<<<< HEAD
<<<<<<< HEAD
Choose_gen=[1;1;1;1;1;0;0;0;0;1;0;0;1;0;0];%1=gen o 0=consumidores
=======
Choose_gen=[1;1;1;1];%1=gen o 0=consumidores
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
=======
Choose_gen=[1;1;1;1];%1=gen o 0=consumidores
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
%%%%%Separaci髇 vectores
xg=zeros(nodes,1);
power_aux=zeros(nodes,1);
%%%% Parametros simulaci髇
iterations=90000;
<<<<<<< HEAD
<<<<<<< HEAD
alpha=0.99;
%Generator Charateristics
generation_cost=[0.2;0.3;0.4;0.5;0.6;0;0;0;0;0.7;0;0;0.8;0;0] ;
%Generation Constraints
Pmin=[1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
Pmax=[3000;4000;5000;5000;6000;1;1;1;1;5000;1;1;3000;1;5];
=======
=======
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
alpha=0.5;
%Generator Charateristics
generation_cost=[1;2;3;4] ;
%Generation Constraints
Pmin=[1;1;1;1];
Pmax=[2000;3000;4000;5000];
<<<<<<< HEAD
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
=======
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
%Rate of change
Rate_change=[.5;1;.5;1;.5;1;1;1;1;1;1;1;1;1;1];
%Load
<<<<<<< HEAD
<<<<<<< HEAD
Load_1=[0;0;0;0;0;0;0;0;0;0;0;0;0;0;8000];
=======
Load_1=[0;0;0;8000];
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
=======
Load_1=[0;0;0;8000];
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
Load=Load_1;

for k=1:iterations
<<<<<<< HEAD
<<<<<<< HEAD
%Function_prom=ones(1,nodes);

=======
    
 projection_generation=zeros(nodes,1);
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         Load=[0;0;0;0;0;0;0;0;0;0;0;0;0;0;16000];
     end    
    if (k==60000)
<<<<<<< HEAD
         Load=[0;0;0;0;0;0;0;0;0;0;0;0;0;0;25000];
=======
    
 projection_generation=zeros(nodes,1);
 %%%%%%%%%%%%Demanded Power%%%%%    
     if (k==30000)
         Load=[0;0;0;14000];
     end    
    if (k==60000)
       Load=[0;0;0;10000];
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
=======
       Load=[0;0;0;10000];
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
     end 
%%%%%%%%%%%% Spanning Tree %%%%%%%%%%
if(k==1)
Adjacency_Graph=Adjacency(Edges);
Adjacency_MST=Adjacency(MST(Edges));
asd=1;
end
%%%%%%%%%%% Finite- Time Distributed Averaging %%%%%%%%
    %%%%%%%%%%PD%%%%%%%%%%%
    Power_demanded(:,k)=DistCons(Load,Adjacency_MST);
    %%%%%%%%%%PG%%%%%%%%%%%
    Power_generated(:,k)=DistCons(power(:,k),Adjacency_MST);
    %%%%%%%%%%Cg%%%%%%%%
    if (mod(k,10)==0 || k==1)
    Global_cost(:,k)=DistCons(generation_cost(:).*power(:,k),Adjacency_MST)./Power_generated(:,k);
    else
    Global_cost(:,k)=Global_cost(:,k-1);
    end
    %%%%%%%%%%Nodes%%%%%%%%
    if (k==1)
        Number_generators(:,k)=DistCons(Choose_gen,Adjacency_MST);
    else
        Number_generators(:,k)=Number_generators(:,k-1);
    end
%%%%%%%%%%%%%%%%Gradient variable algorithm%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Consensus%%%%
for j=1:nodes
t=0;
for i=1:nodes
    if(Adjacency_Graph(i,j)==1)
       Function_prom(1,j)=Function_prom(1,j)+power(i,k);
       t=t+1;
    end
end
Function_prom(1,j)=Function_prom(1,j)/t;
end

%%%%%%%%%Update variables%%%%%%%%%%%
% Gradient=[(1/generation_cost(1))*(1-power(1,k)/Pmax(1));
%           1/generation_cost(2)*(1-power(2,k)/Pmax(2)); 
%           1/generation_cost(3)*(1-power(3,k)/Pmax(3));
%           1/generation_cost(4)*(1-power(4,k)/Pmax(4));
%           1/generation_cost(5)*(1-power(5,k)/Pmax(5));
%           1/Global_cost(6,k)*(.01-(power(6,k))/Pmax(6));
%           1/Global_cost(7,k)*(.01-(power(7,k))/Pmax(7));
%           1/Global_cost(8,k)*(.01-(power(8,k))/Pmax(8));
%           1/Global_cost(9,k)*(.01-(power(9,k))/Pmax(9));
%           1/generation_cost(10)*(1-(power(10,k))/Pmax(10));
%           1/Global_cost(11,k)*(.01-(power(11,k))/Pmax(11));
%           1/Global_cost(12,k)*(.01-(power(12,k))/Pmax(12));
%           1/generation_cost(13)*(1-(power(13,k))/Pmax(13));
%           1/Global_cost(14,k)*(.01-(power(14,k))/Pmax(14));
%           1/Global_cost(15,k)*(.01-(power(15,k))/Pmax(15))];

Gradient=[(1/generation_cost(1))*(1-power(1,k)/Pmax(1));
          1/generation_cost(2)*(1-power(2,k)/Pmax(2)); 
          1/generation_cost(3)*(1-power(3,k)/Pmax(3));
<<<<<<< HEAD
<<<<<<< HEAD
          1/generation_cost(4)*(1-power(4,k)/Pmax(4));
          1/generation_cost(5)*(1-power(5,k)/Pmax(5));
          0;
          0;
          0;
          0;
          1/generation_cost(10)*(1-(power(10,k))/Pmax(10));
          0;
          0;
          1/generation_cost(13)*(1-(power(13,k))/Pmax(13));
          0;
          0];

for i=1:nodes
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
=======
=======
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
          1/generation_cost(4)*(1-power(4,k)/Pmax(4))];


for i=1:nodes
if(Choose_gen(i)~=1)
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
else
    power(i,k+1)=-power(i,k)+(Function_prom(i)-alpha*Gradient(i));
end
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
end

%%%%Separaci髇 vectores consumidores y productores%%%
for i=1:length(Choose_gen)
if(Choose_gen(i)~=1)
    power_aux(i,k+1)=power(i,k+1);%consumidores
    Power_demanded(:,k)=Power_demanded(:,k)+ones(nodes,1)*power_aux(i,k+1);
    Power_generated(:,k)=Power_generated(:,k)-ones(nodes,1)*power_aux(i,k+1);
end
end

%%%%%Projected Constrains%%%%%
%%%%%Virtual Agent Global Constraint%%%%%%%%
power(:,k+1)= power(:,k+1)-(Power_generated(:,k)-Power_demanded(:,k))./Number_generators(:,k);


%%%%% Local Rate of change constraint%%%%
for e=1:nodes
  if(power(e,k+1)-power(e,k)>Rate_change(e))
       power(e,k+1)=power(e,k)+Rate_change(e);
  end
  if(power(e,k+1)-power(e,k)<-Rate_change(e))
       power(e,k+1)=power(e,k)-Rate_change(e);
  end
end
%%%%% Local Generation constraints%%%%
for q=1:nodes
  if(power(q,k+1)<Pmin(q))
       power(q,k+1)=Pmin(q);
  end
end

for w=1:nodes
  if(power(w,k+1)>Pmax(w))
       power(w,k+1)=Pmax(w);
  end
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Power_demanded(:,k+1)=Power_demanded(:,k);

subplot(2,2,1)
plot(transpose(power))
grid on
subplot(2,2,2)
plot(transpose(Global_cost))
grid on
subplot(2,2,3)
p=plot(graph(Edges(:,1),Edges(:,2)));
highlight(p,minspantree(graph(Edges(:,1),Edges(:,2))))
grid on
subplot(2,2,4)
<<<<<<< HEAD
<<<<<<< HEAD
plot(transpose(power))
=======
=======
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
plot(transpose(Power_demanded))
>>>>>>> parent of e7c36ea... Separaci贸n de proyecciones globales, no encuentro el problema, desarrollar una t茅cnica para encontrarlo es primordial.
grid on

sum(power(:,30000))-8000
sum(power(:,60000))-16000
sum(power(:,k+1))-25000