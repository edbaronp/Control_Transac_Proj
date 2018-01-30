function [Edges]=MST(E)

%Graph Declaration
G = graph(E(:,1),E(:,2));
%Minimum diameter Spanning Tree
[T] = minspantree(G);
Edges=table2array(T.Edges);

%  p = plot(graph(E(:,1),E(:,2)))
%  highlight(p,minspantree(graph(E(:,1),E(:,2))))