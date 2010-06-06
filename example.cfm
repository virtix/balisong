<cfscript>
import Balisong;

balisong = new Balisong();

a = [1,2,3,4];
reduced = balisong.reduceLeft(a);
writeoutput('should be 10 : 1+2+3+4 = ');
writeoutput(reduced & '<br/>');

//-------------------------------------------

reduced = balisong.reduceLeft(a,'*');
writeoutput('should be 24 : 1*2*3*4 = ');
writeoutput(reduced);


</cfscript>