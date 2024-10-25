function [ XX ]=initialization2(pop_size,N,F_obj,UB,LB,dec)
X=zeros(pop_size,N);%用于存储种群
for i=1:pop_size
    X(i,1)=rand;
    for j=2:N
        X(i,j)=sin(0.7*pi/X(i,j-1));
    end
end
for i=1:size(X,1)
    for j=1:size(X,2)
        if rand<=0.5
            X(i,j)=0;
        else
            X(i,j)=1;
        end
    end
end 
for i=1:size(X,1)
    current_vulture_F(i)=costfunction(X(i,:),dec,UB,LB,N,F_obj); 
end
[current_vulture_F,index]=sort(current_vulture_F,'descend');
for i=1:N
    elite_X(i,1)=X(index(1),i);
    for j=2:N
        elite_X(i,j)=sin(0.7*pi/elite_X(i,j-1));
    end
end
mix_X=[X;elite_X];
for i=1:size(mix_X,1)
    for j=1:size(mix_X,2)
        if rand<=0.5
            mix_X(i,j)=0;
        else
            mix_X(i,j)=1;
        end
    end
end
for i=1:size(mix_X,1)
    mixcurrent_vulture_F(i)=costfunction(mix_X(i,:),dec,UB,LB,N,F_obj); 
end
[mixcurrent_vulture_F,mix_index]=sort(mixcurrent_vulture_F,'descend');
for i=1:pop_size
    X(i,:)=mix_X(index(i),:);
end
a=randperm(pop_size);
for i=1:pop_size
    XX(i,:)=X(a(i),:);
end