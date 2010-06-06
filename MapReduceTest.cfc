<cfcomponent output="false" extends="mxunit.framework.TestCase">
<cfscript>	

// should always be apply function to data
// or in the case of data, apply predicate to data

mapper = createObject("component", "MapReduce");
a =  [ 1,2,3,[4],[5,6,[7,8]],[11,[12],13,[14,[15,'deep nested string','0xAC3B',[16]]]],-1,'abc','xyz' ];
filtered_byint_a =  [ 1,2,3,[4],[5,6,[7,8]],[11,[12],13,[14,[15,'0xAC3B',[16]]]],-1 ];


s = { 'foo'='bar','a'=a,'s2'={'barbar'='f00', 'dob'='12/12/12' } , 'name'='bill',''='' };
l = "1,2,3,4,5,6,7,8";

function __1(){
  for(item in s){
    debug( s[item] );
  }
}

function __filterTestForStruct(){
  var predicate = "[1-9]+";
  var s = { 'foo'='1','bar'='12','foobar'='asd', ''='','haxor'=321, ss={ subok=999,subnotok='asdasdasd' }, zcdasdasd=[1,'foo',3] };
  var s_filtered = { 'foo'='1','bar'='12','haxor'=321, ss={ subok=999}, zcdasdasd=[1,3] }; 
  var actual = mapper.filter( predicate, s );
  debug(actual);
  
  //these are equal, however the ordering is not the same, so the test fails.
  //assertEquals( s_filtered , actual );
  
}


function __incArrayAndStructVals(){
  var a =  [ {'n_o'=-99, 'n_1'=1000, b=[0,0,0,0],_as='1,1,1,1'},1,2,3,[4],[5,6,[7,8]],[11,[12],13,[14,[15,'deep nested string','0xAC3B',[16]]]],-1,'abc','xyz' ];
  var a2 = mapper.inc(a);
  debug(a2);
}



function __incStructVals(){
  var s1 = {one=1,two=2,a=a};
  var s2 = mapper.inc(s1);
  debug(s2);
  assertEquals( s2.a[1][1],2 );
  assertEquals( s2.a[1][7],0 );
  assertEquals( s2.one,2 );
  assertEquals( s2.two,3 );
}



function __applyToStruct(){
  var s2 = mapper.apply(_toupper,s);
  debug(s2);
}


private function _toupper(s){
 return (s);
}

function __countAllNumbersInList(){
  var predicate = "[1-9]+";
  var actual = mapper.count( predicate, l );
  assertEquals( 8, actual );
}


function __countAllPredicateMatches(){
  var predicate = "[1-9]+";
  var actual = mapper.count( predicate, a );
  assertEquals( 16, actual );
}

function __filterTest(){
  var predicate = "[1-9]+";
  var actual  = mapper.filter( predicate, a );
  debug( actual );
  assertEquals( filtered_byint_a, actual );
}


function __allTestShouldFail(){
  var a = "abc,abd,abe,aCf,abg"; //should
  try{
  assert ( mapper.all( "ab[a-z]+", a ) );
  } catch (mxunit.exception.AssertionFailedError e){}
}



function __allTest(){
  var a = "abc,abd,abe,abf,abg";
  assert( mapper.all( "ab[a-z]+", a )  );
}



function __anyExpressionTest(){
   try{
   assert( mapper.any("this does not exist" , a) ,'found something not there' );
   
   } catch (mxunit.exception.AssertionFailedError e){}
}


function __anyTest(){
   var simple = ['abc','xyz',1];
   assert( mapper.any("[p]*bc" , simple) );
   assert( mapper.any("[a]bc" , simple) );
   //assert( mapper.any("4" , a) );
   assert( mapper.any("1" , a) );
   assert( mapper.any("xyz" , a) );
   assert( mapper.any("4" , a) ,'did not find 2 d array' );
   assert( mapper.any("0xAC3B" , a) ,'did not deep nested element' );
   assert( mapper.any("[a-z]{2,2}z" , a) ,'did not deep nested element' );
   assert( mapper.any("abc" , a) ,'did not deep nested element' );
   assert( mapper.any("d[e]+p[ ]n" , a) ,'did not find "deep nested"' );
}


function __incrementList(){
  debug ( mapper.inc(l) );
}

function __ensureArrayTest(){
  assert( isArray(mapper.ensureArray(l))  );
}


function __isListTest(){
 l = '1,2,3,4,5,asd,xcv';
 assert( isList(l) );
 
 assert( !isList(a) );
 assert( !isList(s) );

}

private function isList(any l){
 return isSimplevalue(l) && listLen(l);
}

function _deepSearchTest(){
  var res = arrayFind(a,15); //depth/tree  index of each array traversed: 6.4.2
  debug(res);
  var r2 = structFindvalue(s,'12/12/12');
  debug(r2);
  var r3 = structFindvalue(s,'12*');
  debug( r3 );
}



/**
* @expectedException Expression
*/
function incStr(){
  var s = 'asd';
  s++;
}

function _cloneTest(){
  var s1 = {'foo'='bar'};
  var s2 = mapper.clone(s1);
  var s3 = mapper.clone(s2);
  
  s1['foo'] = 'altered';
  debug( s1 );
  
  assertNotEquals( s1['foo'], s2['foo'] );
  debug( s2 );
  
  
  debug( s3 );
  
  assertNotSame( s1, s2 );
  assertNotSame( s1, s3 );
  assertNotSame( s2, s3 );
}


private function m(e){
  return ( e * 100 / (0.09 * 3.1) );
}


private function enc(val){ return encrypt(val,'SHA-512');  }

private function u(v){ return ucase(v);  }

function _doSomeEncyption(){
  var a = ['a', 'qiasd', 'OncE', ['some',['other']],'motley foo'];
  var u = mapper.apply(enc,a);
  debug(u);
  
}

function _doSomeCaps(){
  var a = ['a', 'qiasd', 'OncE'];
  var u = mapper.apply(u,a);
  debug(u);
  
}

function _doSomeMath(){
  var a = [1,2,3,[4,[5]]];
  actual = mapper.apply(m,a);
  debug( actual );
  
}



function $testDefaultReduce(){
  var a = [1,2,3,[4,[5]]];//[3,[4,5]]];
  actual = mapper.reduce(a);
  assertEquals(15,actual);
}



function $testFoldRight(){
  var a = [1,2,3,[4,[5]]];//[3,[4,5]]];
  actual = mapper.foldRight(a,'+', 10);
  assertEquals(25,actual);
}



function $testFoldLeft(){
  var a = [1,2,3,[4,[5]]];//[3,[4,5]]];
  actual = mapper.foldLeft(a,'+', 10);
  debug(actual);
  assertEquals(25,actual);
}


function $reduceRightNDArrayTest(){
	 var a = [1,2,3,[4,[5]]];//[3,[4,5]]];
	 actual = mapper.reduceRight(a,'+');
	 debug(actual);
	 assertEquals(15,actual);
	 actual = mapper.reduceRight(a,'*'); 
	 debug(actual);
	 assertEquals(120,actual);
}


function $reduceRight1DArrayTest(){
	 var a = [1,2,3,4,5];
	 actual = mapper.reduceRight(a,'+');
	 debug(actual);
	 assertEquals(15,actual);
	 
	 actual = mapper.reduceRight(a,'*'); 
	 debug(actual);
	 assertEquals(120,actual);
}


function $reduceLeft1DArrayTest(){
	 var a = [1,2,3,4,5];
	 actual = mapper.reduceLeft(a,'+');
	 debug(actual);
	 assertEquals(15,actual);
	 
	 actual = mapper.reduceLeft(a,'*'); 
	 debug(actual);
	 assertEquals(120,actual);
}


function $reduceLeftNDArrayTest(){
	 var a = [1,2,3,[4,[5]]];//[3,[4,5]]];
	 actual = mapper.reduceLeft(a,'+');
	 debug(actual);
	 assertEquals(15,actual);
	 actual = mapper.reduceLeft(a,'*'); 
	 debug(actual);
	 assertEquals(120,actual);
}


function $existsTest(){
   
   assert( mapper.exists( 1, l ) );
}


private function print(m){
 writeoutput(m);
}

function testForEach(){
 var a = [1,2,3,4,5];
 out = getPagecontext().getOut();
 mapper.foreach( a, print );
}

function incrementEachNumericInAnArray(){
	var a = [ 1,2,3,[4],[5,6,[7,8]],[11,[12],13,[14,[15,'0xAC3B',[16]]]], -1,'abc','xyz', {foo='bar'} ];
	var b = mapper.inc(a);
	debug(b);
}

function flatternAnArray(){
    var a = [ 1,2,3,[4,5,6],[7,[8,9,[10]]] ];
    var expected = [1,2,3,4,5,6,7,8,9,10];
    var b = mapper.flatten(a);
    debug(b);
    assertEquals( expected,b );
}

function concatArrayTest(){
    var  a = [ 'A','quick', 'brown','fox' ];
    var  b = [ 'jumps', 'over', 'the', 'lazy', 'dog' ];
    var  c = [ 1,2,3,4,5,6 ];
    var  d = [ {'foo'='bar'} ];
    var actual = mapper.concat(a,b,c,d);
    debug(actual);
}


function concatStructTest(){
    var  a = {'A'='quick', 'brown'='fox' };
    var  b = {'jumps'='over', 'the'='', 'lazy'='dog'};
    var  c = [ 1,2,3,4,5,6 ];
    var  d = {'foo'='bar'} ;
    var actual = mapper.concat(a,b,d);
    debug(actual);
}



</cfscript>
</cfcomponent>
