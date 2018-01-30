function [adj]=Adjacency(Edges)

% Construction of Adjacency matrix 
Q1=sparse(Edges(:,1),Edges(:,2),1);
Q1=full(Q1);
Q2=sparse(Edges(:,2),Edges(:,1),1);
Q2=full(Q2);
[m, n]=size(Q1);
if(m-n>0)
K=abs(m-n);
adj_1=padarray(Q2,K,'post');
adj_2=transpose(padarray(transpose(Q1),K,'post'));
else
K=abs(n-m);
adj_1=padarray(Q1,K,'post');
adj_2=transpose(padarray(transpose(Q2),K,'post'));
end
adj=adj_1+adj_2;