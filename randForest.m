function [vote]=randForest(x,data)
class_out=zeros(length(data),1);
classesunique=[0 1];

for bagi=1:length(data)
branches=data{bagi}.branches;
storeBranchLength=data{bagi}.storeBranchLength;
storeBranchTmpL=data{bagi}.storeBranchTmpL;
storeBranchTmpVal=data{bagi}.storeBranchTmpVal;
storeBranchTmpVecI=data{bagi}.storeBranchTmpVecI;
storeBranchTmpVecI=data{bagi}.storeBranchTmpVecI;
Class=data{bagi}.Class;

  cl=DecTree(x,branches,storeBranchLength,storeBranchTmpL,storeBranchTmpVal,storeBranchTmpVecI,Class);
 class_out(bagi)=classesunique(find(classesunique==str2num(cl{1})));
% % find(strcmp(mat2str(classesunique),(cl{1})));
end
%% 
clear count vote
vote=0;
for datai=1
for classi=1:length(classesunique)
    count(datai,classi)=sum(classesunique(classi)==class_out(:,datai));
end
[ null Imax]=max(count(datai,:));
[null Isorted]=sort(count(datai,:));

if sum(count(datai,Imax)==count(datai,Isorted))>1

    I=find(count(datai,Imax)==count(datai,:));
    classesunique(  I(ceil(rand()*length(I)))  );
    
    
     vote(datai)=min(classesunique(I));
%       vote(datai)=    classesunique(  I(ceil(rand()*length(I)))  );
else
    vote(datai)=classesunique(Imax);
end
    
end
