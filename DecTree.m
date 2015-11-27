function [class]=DecTree(x1,branches,storeBranchLength,storeBranchLogic,storeBranchVal,storeBranchVecI,Class)
% x is the vector to be classified
% branches is the total number of branches in the tree
% storeBranchLength is the length of each branch
% x(storeBranchVecI) tells us which item of x is to evaluted at each branch
% storeBranchVal stores the vale which x(storeBranchVecI) is to be tested
% against
% storeBranchLogic tells us wheather the logic test result is 0 or 1,1 is x(storeBranchVecI) < storeBranchVal
% 0 is x(storeBranchVecI) >= storeBranchVal
% x1=[52.869720 
% 0.263962 
% -0.453335 
% -0.283159 
% -0.319548 
% -0.291982 
% -0.254286 
% -0.283412 
% -0.233625 
% -0.239595 
% -0.323514 
% -0.275569 
% 53.439194 
% 0.229304 
% -0.452157 
% -0.388987 
% -0.396270 
% -0.281962 
% -0.234098 
% -0.237805 
% -0.218959 
% -0.207660 
% -0.324528 
% -0.248987 
% 53.683029 
% 0.339063 
% -0.358595 
% -0.352039 
% -0.422821 
% -0.299704 
% -0.198314 
% -0.240878 
% -0.337651 
% -0.257626 
% -0.305605 
% -0.272209];
for bi=1:branches
       result(bi)=1;
   for ni=1: storeBranchLength(bi)
       test(bi,ni)=nan;
       if storeBranchLogic(bi,ni)==1
       if x1(storeBranchVecI(bi,ni))<storeBranchVal(bi,ni)
                test(bi,ni)=1;

       end
       end
       
        if storeBranchLogic(bi,ni)==0
       if x1(storeBranchVecI(bi,ni))>=storeBranchVal(bi,ni)
           test(bi,ni)=1;
       end
       end
       
          result(bi)=result(bi)*test(bi,ni);

   end

end

class=Class(find(result==1));