function b = isdual(a)
%ISDUAL Return true if a is of class Dual, else return false
    b = strcmp(class(a),'Dual');
end