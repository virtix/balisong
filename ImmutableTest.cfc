<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>	
mr = createObject("component", "MapReduce");

a =  [ 1,2,3,[4],[5,6,[7,8]],[11,[12],13,[14,[15,'0xAC3B',[16]]]], -1,'abc','xyz', {foo='bar'} ];
s = { 'foo'='bar','a'=a,'s2'={'bar'='f00', 'dob'='12/12/12' } , 'name'='bill' };



function __isImmutable(){ 
  var i = structNew();
}

</cfscript>
</cfcomponent>
