str = d1.netlist;
str = join(str, '');

f1 = fopen('d10_16.sp', 'wt');

str2 = join(str,'\n');

fprintf(f1, str2);
fclose(f1)
