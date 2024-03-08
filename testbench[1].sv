//						Constraints Solutions:


//Q1 : Constraint to generate the pattern 0102030405.

class QC_1;
  
  //dynamic array
  rand int addr[];
  //int count=0;
  
  constraint c1 { 
    addr.size() == 10;
  }
  
  constraint c2 {
   // int count=1;
    foreach(addr[i]) {
      if((i%2)==0) {
        addr[i] == 0;
        //count == count + 1;
      } else {
        //addr[i] == count;
        addr[i] == (i+1)/2;
      }
    }
  }
   
 //Alternative way
        /*
   constraint c{foreach (addr[i])          
    if(i%2==0)
      addr[i]==0;
     else
     {
       if(i>1)
         {
           q[i]==q[i-2]+1;
           }
        else
            q[i]==1;
      }
              
    }
  */
        
endclass 
        
/* 
module Q1_m;
  
  QC_1 q1;
  
  initial begin
    q1=new();
    //q1 = QC_1::type_id::create("q1",this)  //for uvm_component, for uvm_object just "q1" is fine
    assert(q1.randomize());
    $display(q1.addr);
  end
  
endmodule
*/    
//Q2 : Constraint to generate unique numbers between 99 to 100?
      
class QC_2;
  
  //Getting error if i am using real data type varaible in constraint i.e ERROR VCP7710 "Operand this.addr of type real is not legal for constrained randomization." "testbench.sv" 66  1
  
  //rand real addr; through same above error
  
  real addr;
  rand int value;
  rand int i;
  
  constraint c1{ value inside {99,100};
               }
  
  //constraint c2{ unique {addr}; }
  constraint c2{ unique {i};
               i > 0;}
  
  function void post_randomize();
    if(value==99)
      addr = value + (value/((value+i)+0.0));
    else
      addr = (value) - (value/((value+i)+0.0));
  endfunction
  
  //Altenate method :
  /*
  constraint c1 { value inside {[990:1000];}}
  
  function void post_randomize();
    addr = value%10.0;
  endfunction

  */
  
endclass

/*      
module tb2;
  
  QC_2 q2;
  
  initial begin
    q2 = new();
    //In UVM => q2=QC_2::type_id::create("q2") //accr to uvm_object
    repeat(5) begin
      //assert(q2.randomize() with {q2.value==100;});
      assert(q2.randomize());
      $display(q2.addr,q2.value,q2.i);
    end
    //In UVM : uvm_info(get_type_name(),$sformat(q2.addr),UVM_NONE)
  end
  
endmodule
*/
      
//Question 3: Constraint - divisible by 5?
      
class QC3_c;
  
  rand int addr;
  
  constraint c1{
    addr%5 == 0;
  }
  
endclass

/*
module mqc3_m;
  
  QC3_c pkt;
  
  initial begin
    pkt = new();
    //pkt.c1.constraint_mode(1);
    assert(pkt.randomize());
    $display("pkt.addr=%0d",pkt.addr);
    //`uvm_info(get_type_name(),$sformat("pkt.addr=%0h",pkt.addr),UVM_HIGH)
  end
  
endmodule
*/
      
//Question 4: Derive odd numbers within the range of 10 to 30 using SV constraint?
      
class QC4_m;
  
  rand bit [5:0] addr;
  
  
  constraint c1{
    addr > 10;
    addr < 30;
  }
  
  constraint c2{
    addr%2 == 1;
  }
  
  //Alternative way
  //constraint c3 { addr inside{[10:30]}; addr%2==1;}
  
endclass

      /*
module mqc4_m;
  
  QC4_m pkt;
  
  initial begin
    pkt = new();
    //pkt.c1.constraint_mode(1);
    //pkt.c2.constraint_mode(1);
    repeat(5) begin
    assert(pkt.randomize());
    $display("pkt.addr=%d",pkt.addr);
    end
  end
  
endmodule
*/
      
//Question 5 : Write a constraint for 4-bit dynamic array. The size of the array 
//should be in between 15 to 20. There should be even number in odd 
//locations and odd number in even locations?
      
class QC5_c;
  
  rand bit [3:0] dy[];
  
  constraint c1{
    dy.size() inside {[15:20]};
  }
  
  constraint c2{
    foreach(dy[i]) {
      if(i%2==0) {
        dy[i]%2 == 1;
      } else {
        dy[i]%2 == 0;
      }
     }
   }
        
endclass

/*        
module QC5_m;
  
  QC5_c pkt;
  
  initial begin
    pkt = new();
    assert(pkt.randomize());
    $display("pkt.dy=",pkt.dy);
    //`uvm_info(get_type_name(),$sformat("pkt.dy=%0h",pkt.dy),UVM_MEDIUM)
  end
  
endmodule
*/
        
//Question 6:  Write a constraint for two random variables such that one 
//variable should not match with the other & the total number of bits 
//toggled in one variable should be 5 w.r.t the other
        
class QC6_c;
  
  rand byte addr;
  rand byte data;
  
  constraint c1{
    addr != data;
  }
  
  constraint c2{
    $countones(addr^data) == 5;
  }
  
endclass
      /*
module mqc6_m;
  
  QC6_c pkt;
  
  initial begin
    pkt = new();
    repeat(5) begin
    assert(pkt.randomize());
      $display("pkt.addr=%0b",pkt.addr);
      $display("pkt.data=%0b",pkt.data);
    end
  end
  
endmodule
      */
      

//Question 7: Write a constraint such that when rand bit[3:0] a is randomized, the value of “a” should not be same as 5 previous occurrences of the value of “a”?
      
class QC7_c;
  
  rand bit [3:0] a;
  bit [3:0] queue[$:5];
  bit [3:0] val;
  
  constraint c1{
    !( a inside {queue});
  }
      
  function void post_randomize();
    if(queue.size() == 5) begin
      queue.pop_front();
      queue.push_back(a);
    end else begin
      queue.push_back(a);
    end
  endfunction
  
endclass
     
/*      
module QC7_m;
  
  QC7_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display("pkt.a=%0d, pkt.queue=%p",pkt.a,pkt.queue);
    end
  end
  
endmodule
*/
      
//Question 8: Constraint to generate 0, 1, x and z randomly?
      
class QC8_c;
  
  rand logic a;
  
  typedef enum {S0,S1,S2,S3} state;
  
  rand state st;
  
  function void post_randomize();
    case(st)
      S0: a=0;
      S1: a=1;
      S2: a=1'bx;
      S3: a=1'bz;
    endcase
  endfunction
  
endclass
      
/*      
module QC8_m;
  
  QC8_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.a,pkt.st);
    end
  end
  
endmodule
*/
      

//Question 9:
      // Write a program using dynamic array.
	//[i] array1: no. of elements should be between 30-40.
	//[ii] array2: sum of all elements should be < 100 
	//[iii] array3: sum of all elements should be > 100
      
      //Check this properly not working fine, source : verificationacademy.com
      
 class QC9_c;
   
   rand int dy_arr[];
   rand int sum;
   
   constraint c1{
     dy_arr.size() inside {[30:40]};
   }
   
   constraint c2{
     dy_arr.sum() < 100;
     dy_arr.sum() > 0;
   }
   
   //constraint c3{
     //dy_arr.sum() > 100;
   //}
   /*
   constraint c4{
     foreach(dy_arr[i]) {
       if(i>1) {
         sum == dy_arr[i] + dy_arr[i-1];
       }
     }
    }
    */
         
endclass
      
      /*
module qc9_m;
  
  QC9_c pkt;
  
  initial begin
    pkt=new();
    //pkt.c3.constraint_mode(0);
    repeat(2) begin
      assert(!pkt.randomize());
      $display(pkt.sum,pkt.dy_arr);
    end
  end
  
endmodule
   */
      
  
//Question 10:0.There are two constraints applied to same variable. One will generate the 
//value within the range of [25:50] and another expression should be greater 
//than 40. What should be the value generated, and what is the reason?
      
      //Ans : It will generate the value between 41 to 50 because it has to satisfy both the condition i.e
      // a inside {[25:50]}; and also a > 40;
     
      

      
      
//Question 11:Write a constraint such that addresses should be 4 byte aligned to each other.
      //like : Means agar 64 bit ka address h toh uske 32 bit Dusre address se overlap krenge
      
class QC11_c;
  
  rand bit [63:0] addr1;
  rand bit [63:0] addr2;
  
  constraint c1{
    addr1[31:0] == addr2[31:0];
  }
  
endclass
      
      /*
module qc11_m;
  
  QC11_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display("pkt.addr1=%0h, pkt.addr2=%0h",pkt.addr1,pkt.addr2);
    end
  end
  
endmodule
*/
      
      
//Question 12:Constraint with array size of 5 to 10 values & the array values should be in ascending order?
      
class QC12_c;
  
  rand bit [7:0] addr[];
  
  constraint c1{
    addr.size() inside {[5:10]};
  }
  
  constraint c2{
    foreach(addr[i]){
      if(i>0) {
        addr[i] > addr[i-1];  //for asending order
        //addr[i] < addr[i-1];    //for desendin order
      }
    }
   }
  
endclass
        
  /*      
module qc12_m;
  
  QC12_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
      assert(pkt.randomize());
      $display("pkt.addr=%p",pkt.addr);
    end
  end
  
endmodule
      */

        
    
//Question 13: Constraint - for 0-100 range 70% and for 101-255 range 30%?
        
class QC13_c;
  
  rand bit [7:0] addr;
  
  constraint c1{
    addr dist { [0:100] :/ 70, [101:255] :/ 30};
  }
  
endclass
      
      /*
module qc13_m;
  
  QC13_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
    assert(pkt.randomize());
      $display("pkt.addr=%0d",pkt.addr);
    end
  end
  
endmodule
*/
      
      
//Question 14: Without inside operator generate random values for the range 34-43??
      //I will use $urandom_range(34,43);
      
class QC14_c;
  
  rand bit [7:0] addr;
  
  constraint c1{ addr>=34;
                addr <=43;
               }
  
  //Alternative way
  //constraint c2{ (addr>=34) && (addr<=43);}
  
endclass

      /*
module qc14_m;
  QC14_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.addr);
    end
  end
  
endmodule
*/

    
      
//Question 15:  Generate unique values without using rand or randc?
      
class QC15_c;
  
  bit [3:0] a;
  
  function void post_randomize();
    a = $urandom;
  endfunction
  
endclass
 
      /*
module mqc15_m;
  
  QC15_c pkt;
  
  initial begin
    pkt =new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.a);
    end
  end
  
endmodule
*/
      
      
//Question 16:  Randomize the below variables:
	class randvar;
		rand bit[7:0] var1, var2, var3, var4;
	endclass
//i) Randomize all variables.
//ii) Randomize only var2.
//iii) Randomize var1 & var4.
//iv) Randomize var1, var3 and var4.
      
      /*
      module qc16_m;
        
        randvar pkt;
        initial begin
          monitor();
          pkt = new();
          //1=>randmoize all var
          assert(pkt.randomize());
          #5;
          //2=>randmoize only var2
          pkt.var1.rand_mode(0);
          pkt.var3.rand_mode(0);
          pkt.var4.rand_mode(0);
          assert(pkt.randomize());
          //			or
          //     pkt.randomize(var2);
          #5;
          //3=>randmoize var1 & var4
          pkt.var2.rand_mode(0);
          pkt.var1.rand_mode(1);
          pkt.var4.rand_mode(1);
          assert(pkt.randomize());
          //			or
          //	  pkt.randomize(var1,var4);
          #5;
          //4=>randomize var1,var3 & var4
          pkt.var3.rand_mode(1);
          assert(pkt.randomize());
          #5;
        end
        
        task monitor;
          $monitor($time,"var1=%0d, var2=%0d, var3=%0d, var4=%0d",pkt.var1,pkt.var2,pkt.var3,pkt.var4);
        endtask
        
      endmodule
      */
      
      
      
//Question 17: Write fibonacci series with constraint i.e 0,1,1,2,3,5,8,13??
      
class QC17_c;
  
  rand bit [7:0] addr[];
  
  constraint c1{
    addr.size() inside {[10:15]};
  }
  
  constraint c2{
    foreach(addr[i]){
      if(i==0) {
        addr[i] == 0;
      } else if(i==1) {
        addr[i] == 1;
      } else {
        addr[i] == addr[i-1] + addr[i-2];
      }
     }
   }
  
endclass
  
        /*
module qc17_m;
  QC17_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.addr);
    end
  end
  
endmodule
*/
          
//Question 18:  Write a single constraint to generate random values for bit[8:0] 
		//		variable in the below range: 1-34, 127, 129-156, 192-202, 257-260?
        
class QC18_c;
  
  rand bit [8:0] addr;
  
  constraint c1{
    addr inside {[1:34],127,[129:156],[192:202],[257:260]};
  }
  
endclass
 
      /*
module qc18_m;
  
  QC18_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.addr);
    end
  end
  
endmodule
*/
          
      
//Question 19:  Generate unique random values without using unique constraint?
      
class QC19_c;
  
  rand bit [7:0] addr;
  
  bit [7:0] queue[$];
  
  constraint c1{
    !(addr inside {queue});
  }
  
  function void post_randomize();
    queue.push_back(addr);
  endfunction
  
endclass
   
      /*
module qc19_m;
  
  QC19_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $write("\t");
      $write(pkt.addr);
      $write("\t");
      $write(pkt.queue);
      $write("\n");
    end
  end
  
endmodule
*/
      
      
//Question 20:  Write a constraint for 16-bit variable such that no two consecutive (continuous) ones should be generated??
      
 class QC20_c;
   
   rand bit [15:0] var1;
   
   constraint c1{
     foreach(var1[i]) {
       if(var1[i]==1) {
         var1[i+1] == 0;
       }
     }
    }
         
endclass
        /* 
module qc20_m;
  QC20_c pkt;
  
  initial begin
    pkt=new();
    //pkt.c1.constraint_mode(1);   0-> disable, 1-> Enable
    repeat(10) begin
      assert(pkt.randomize());
      $display("pkt.var1=%0b",pkt.var1);
    end
  end
  
endmodule
*/
         
         
         

//Question 21: Write a constraint to randomly generate unique prime numbers 
//			   in an array between 1 and 200. The generated prime numbers 
 //			   should have 7 in it (Eg.: 7, 17, 37..)??
         
         
class QC21_c;
  
  rand bit [7:0] dy_arr[];
  rand bit [7:0] tmp[$];
  bit [4:0] j;
  
  constraint c1{
    dy_arr.size inside {[20:50]};
    //tmp.size() == dy_arr.size();
  }
  
  constraint c2{
    foreach(dy_arr[i]){
      dy_arr[i] inside {[1:200]};
    }
  }
      
      constraint c3{
        foreach(dy_arr[i]){
          dy_arr[i] == prime(i);
        }
      }
          
   function bit [7:0] prime(bit [7:0] val);
        if(val<2)
          return 2;
        else begin
          for(int i=2;i<val;i++) begin
            if(val%i==0) begin
              return 2;
            end
          end
          return val;  //it means the number is prime no
        end
   endfunction
        
   function void post_randomize();
     //tmp=new[dy_arr.size()];
     //j=0;
     foreach(dy_arr[i]) begin
       if(dy_arr[i]%10==7) begin
         //tmp[j]=dy_arr[i];
         //j++;
         tmp.push_back(dy_arr[i]);
       end
     end
     //dy_arr=tmp;
   endfunction
          
        
  
endclass
   /*     
module m21_m;
  
  QC21_c pkt;
  
  initial begin
    pkt=new();
    repeat(1) begin
      assert(pkt.randomize());
      $display("pkt.dy_arr=%p",pkt.dy_arr);
      $display("pkt.tmp=%p",pkt.tmp);
    end
  end
  
endmodule
*/
        
        
//Question 22:Write a constraint to generate multiples of power 2?
        
class QC22_c;
  
  rand bit [9:0] addr;
  
  constraint c1{
    addr%2==0;
  }
  
  constraint c2{
    $countones(addr)==1;
  }
  
endclass
        
  /*      
module qc22_m;
  
  QC22_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.addr);
    end
  end
  
endmodule
*/

        
        

//Question 23:Take a rand variable with array size 10,need to get unique values in each location without using unique keyword and for any of 2 locations we need to get same value?
        

class QC23_c;
  
  rand bit [5:0] dy_arr[];
  
  constraint c1{
    dy_arr.size() == 10;
  }
  
  constraint c2{
    foreach(dy_arr[i]) {
      if(i==1) {
        dy_arr[i] == dy_arr[i-1];
      } else if(i>1){
        dy_arr[i] != dy_arr[i-1];
      }
        }
  }
        
endclass
  /*      
module qc23_m;
  
  QC23_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
      assert(pkt.randomize());
      $display("dy_arr=%p",pkt.dy_arr);
    end
  end
  
endmodule
      */
      
        /*
module abc;
 
  class aa;
    rand int unsigned val[10];
 
    constraint s1 {
      foreach(val[i]){
        val[i] < 10;
        foreach(val[j]){
          if(i < 9 && j < 9 && i != j)
            val[i] != val[j];
        }
      }
    }
    
    //this below logic for any random 2 values should be equal
 
     function void post_randomize();
        val[10] = val[$urandom_range(0,8)];
     endfunction
 
  endclass
 
 initial begin
    aa a1 = new();
   repeat(5) begin
    a1.randomize();
    $display(a1.val);
   end
  end
 
endmodule
*/
        
        
//Question 24: Create a class for a graphics image that is 10x10 pixels. The value for each pixel can be randomized to black or white. Randomly generate an image that is,on average, 20% white. Print the image and report the number of pixels of each type.
        //POINT : .size() method is not working for multi-dimentional array
        
class QC24_c;
  
  rand bit chess[10][10];
  /*
  constraint c0{
    //foreach(chess[i]){
      chess.size() == 10;
    //}
  }
  */
  
  constraint c1{
    foreach(chess[i]){
      foreach(chess[j]) {
        chess[i][j] dist {1:=80, 0:=20};
      }
    }
  }
      
endclass
        /*
module qc24_m;
  
  QC24_c pkt;
  
  initial begin
    pkt = new();
    assert(pkt.randomize());
    $display("pkt.chess=%p",pkt.chess);
    //$display("pkt.size()=%d",pkt.chess.size());
    foreach(pkt.chess[i]) begin
      foreach(pkt.chess[j]) begin
        $write(pkt.chess[i][j]);
      end
      $display();
    end
  end
  
endmodule
*/
        
        
        
        
//Question 25: How can we randomize 2D array?
        
class QC25_c;
  
  rand bit arr[][];
  
  constraint c1{
    arr.size() == 5;
    foreach(arr[i]){
      arr[i].size() == 5;
    }
  }
      
endclass
      /*
module qc25_m;
  
  QC25_c pkt;
  
  initial begin
    pkt = new();
    assert(pkt.randomize);
    $display(pkt.arr);
  end
  
endmodule
     */
      
      
//Question 26: For 3D?
      
class QC26_c;
  
  rand bit arr[][][];
  
  constraint c1{
    //arr.size() inside {6,7};  it is also working
    arr.size() == 5;
    foreach(arr[i]){
      //arr[i].size() inside {[3:4]}; it is also working
      arr[i].size() == 3;
      foreach(arr[i,j]) {
        arr[i][j].size() == 2;
      }
    }
  }
      
endclass
      /*
module qc26_m;
  
  QC26_c pkt;
  
  initial begin
    pkt = new();
    assert(pkt.randomize);
    $display(pkt.arr);
    foreach(pkt.arr[i,j,k]) begin
      $display("pkt.arr[%0d][%0d][%0d]=%d",i,j,k,pkt.arr[i][j][k]);
    end
  end
  
endmodule
*/
        
        
//Question 27:first two even next two odd constraint?
        
class QC27_c;
  
  rand bit [7:0] addr[];
  
  constraint c1{
    addr.size() == 10;
  }
  /*
  constraint c2{
    //for(int i=0;i<=addr.size();i=i+4);{
    foreach(addr[i]){
      if(i>1 && i<10) {
        addr[i+1] == (addr[i-1]+1);
        addr[i+2] == (addr[i-2]+1);
      } else {
        addr[0] == 0;
        addr[1] == 2;
      }
        //i == (i[0]==0);  
  }
         }
         */
  
  function void post_randomize();
    for(int i=0;i<addr.size();) begin
      if(i>0) begin
        addr[i+1] = addr[i-1]+1;
        addr[i+2] = addr[i-1]+3;
        i=i+2;
      end else begin
        addr[0] = 2;
        addr[1] = 4;
        i=i+1;
      end
    end
  endfunction
      
endclass
     /* 
module qc27_m;
  
  QC27_c pkt;
  
  initial begin
    pkt=new();
    assert(pkt.randomize());
    $display(pkt.addr);
  end
  
endmodule
      */
      
      
      
//Question 28: Write a constraint to generate even and odd numbers in an array?
      
class QC28_c;
  
  rand bit [7:0] dy_arr[];
  
  constraint c1{
    dy_arr.size() inside {[5:10]};
  }
  
  constraint c2{
    foreach(dy_arr[i]){
      if(i%2==0){
        dy_arr[i][0]==0;  // or dy_arr[i]%2==0
      }else{
        dy_arr[i]%2==1;
      }
     }
   }
  
endclass
        /*
module tb28_m;
  
  QC28_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.dy_arr);
    end
  end
  
endmodule
*/
        
        
//Question 29:Generate Square numbers
        
class QC29_c;
  
  rand bit [14:0] arr[];
  rand bit [2:0] n;
  
  constraint c1{
    arr.size() inside {[4:7]};
    n==5;
  }
  
  constraint c2{
    foreach(arr[i]){
      if(i>0){
        arr[i] == arr[i-1]*n;   //using "*" operator
        //arr[i] == 2**i;         //using "**" operator
        //arr[i] == arr[0]<<i;      //using "<<" left shift operator but it will work fine only for n=2
      }else{
        arr[i] == n;
      }
    }
   }
        
endclass
        
/*
module qc29_m;
  
  QC29_c pkt;
  
  initial begin
    pkt = new();
    repeat(5) begin
      assert(pkt.randomize());
      $display(pkt.arr);
    end
  end
  
endmodule
*/
        


//Question 30: Write a program for prime numbers=>2,3,5,7,11,13,17,19,23,29,31,37,39...?
        
class QC30_c;
  
  rand bit [7:0] dy_arr[];
  
  constraint c1{
    dy_arr.size() == 10;
  }
  
  constraint c2{
    foreach(dy_arr[i]){
      dy_arr[i] == prime_num(i);
    }
  }
      
      function bit [7:0] prime_num(int i);
    if(i<=1) begin
      return 2;
    end else begin
      for(int n=2;n<i;n++) begin
        if(i%n==0) begin
          return 2;
        end 
      end
      return i;
    end
  endfunction
    
endclass
    /*
module qc30_m;
  
  QC30_c pkt;
  
  initial begin
    pkt=new();
    repeat(1) begin
      assert(pkt.randomize());
      $display(pkt.dy_arr);
    end
  end
  
endmodule
*/
    
    
//Question 31:Generate real numbers between 1 to 200?
    
class QC31_c;
  
  rand bit [7:0] value;
  real addr;
  
  constraint c1{
    value inside {[10:2000]};
  }
  
  function void post_randomize();
    addr = value/10.0;
  endfunction
  
endclass
    /*
module qc31_m;
  
  QC31_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display("pkt.addr=%0f,pkt.value=%0d",pkt.addr,pkt.value);
    end
  end
  
endmodule
*/
    
    
//Question 32: Write a constraint to generate sum of all elements of an array is equal to 100?
    
class QC32_c;
  
  rand bit [7:0] arr[];
  
  constraint c1{
    arr.size() inside {[1:10]};
    arr.sum() with (int'(item)) == 100;
  }
  
endclass
    /*
module qc32_m;
  
  QC32_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      assert(pkt.randomize());
      $display(pkt.arr);
      $display(pkt.arr.sum() with (int'(item)));
    end
  end
  
endmodule
*/
    
    
    
//Question 33:Write a constraint to generate 10 numbers of ones?
    
class QC33_c;
 
  rand int addr;
  
  constraint c1{
    $countones(addr)==10;
  }
  
endclass
    /*
module qc33_m;
  
  QC33_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
    assert(pkt.randomize())
    $display("pkt.addr=%0b",pkt.addr);
    end
  end
  
endmodule
*/
    
    
//Question 34: Write a constraint to generate an even number in an array by adding any 3 consecutive numbers in an array?
    
//Ans : Confuse with Statement
    

//Question 35: Write a constraint to generate these numbers: 
    // a)  25,27,40,45,30,36
    // b)  6,7,14,24,18,12,21
    
//Ans:
    
class Q35_c;
  
  rand bit [7:0] addr;
  rand bit [5:0] vari;
  
  constraint c1{
    (addr>=25 && addr<=45);
    addr != 35;
  }
  
  constraint c2{
    ((addr%5==0) || (addr%9==0));
  }
  
  constraint c3{
    (vari >= 6)&&(vari <=24);
  }
  
  constraint c4{
    ((vari%6==0) || (vari%7==0));
  }
  
endclass
    /*
module Q35_m;
  
  Q35_c pkt;
  
  initial begin
    pkt = new();
    repeat(15) begin
      pkt.randomize();
      $display($time,"pkt.addr=%0d, pkt.vari=%0d",pkt.addr,pkt.vari);
      //`uvm_info(get_full_name(),$sforamt("pkt.addr=%d",pkt.addr),UVM_LOW)
    end
  end
  
endmodule
*/
    
    
//Question 36: Write a constraint in an array
    //a) To Find minimum number using array methods?
    //b) Without using array methods?
    
//Ans:
    
class Q36_c;
  
  rand bit [7:0] arr[];
  bit [7:0] var1[$];
  bit [7:0] var2;
  
  constraint c1{
    arr.size() == 10;
  }
  
  //With uses pre defined methods
  /*
  function void post_randomize();
    var1 = arr.min();
  endfunction
  */
  
  //Without pre-defined methods
  function void post_randomize();
    var2 = func_min(arr);
  endfunction
  
  function bit [7:0] func_min(input bit [7:0] arr[]);
    bit [7:0] tmp;
    foreach(arr[i]) begin
      if((i<=8) && (arr[i] < arr[i+1])) begin
        tmp = arr[i];
      end
    end
    return tmp;
  endfunction
  
endclass
    /*
module q36_m;
  
  Q36_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
      pkt.randomize();
      $display($time,pkt.arr,pkt.var2);
    end
  end
  
endmodule
    */
    
    

//Question 37: Write a constraint to generate leap year
    //Example : The number will be divisible by 4 and 400
    
class Q37_c;
  
  rand bit [12:0] year;
  
  constraint c1{
    (year%4==0)&&(year%400);
    year > 1999;
    year < 2100;
  }
  
endclass
    /*
module Q37_m;
  
  Q37_c pkt;
  
  initial begin
    pkt = new();
    repeat(10) begin
      pkt.randomize();
      $display($time,pkt.year);
      //`uvm_info(get_full_name(),$sformat("pkt.year=%0d",pkt.year),UVM_DEBUGG);
    end
  end
  
endmodule
*/
    
    
//Question 38: Write constraint in an array to generate below pattern
    // 1,2,2,3,3,3,4,4,4,4,5,5,5,5,5
    
 
class Q38_c;
    
  rand bit [7:0] arr[];
  
  constraint c1{
    arr.size() == 15;
  }
  
  function void post_randomize();
    int j=0;
    int tmp=1;
    for(int i=0; i<=10; ) begin
      for(j=0; j<=i; j++) begin
        arr[i+j] = tmp;
      end
      i=i+tmp;
      tmp++;
    end
  endfunction
      
endclass
    /*
module Q38_m;
  
  Q38_c pkt;
  
  initial begin
    pkt=new();
    assert(pkt.randomize());
    $display(pkt.arr);
  end
  
endmodule
*/
    
    
//Question 39: Write a constraint to generate fibonaccci series :
    // 0,1,1,2,3,5,8,13,21,34...
    
//Ans:
    
class Q39_c;
  
  rand bit [7:0] fibarr[];
  
  constraint c1{
    fibarr.size() == 10;
  }
  
  constraint c2{
    foreach(fibarr[i]){
      if(i==0)
        fibarr[0]==0;
      else if(i==1)
        fibarr[1]==1;
      else
        fibarr[i]==fibarr[i-1]+fibarr[i-2];
    }
  }
      
endclass
      /*
module tb_39;
  
  Q39_c pkt;
  
  initial begin
    pkt=new();
    assert(pkt.randomize());
    $display(pkt.fibarr);
    //`uvm_info(get_full_name(),$sformat("pkt.fibarr=%p",pkt.fibarr),UVM_LOW)
  end
  
endmodule
*/
      

//Question 40: Write a constraint in an array to generate average of all even and odd numbers in an array?
      
//Ans:
      
class Q40_c;
  
  rand bit [2:0] arr[];
  real even,odd;
  real e_num;
  real o_num;
  
  constraint c1{
    arr.size()==10;
  }
  /*
  constraint c2{
    foreach(arr[i]){
      if(arr[i]%2==0)
        even==even+arr[i];
      else
        odd==odd+arr[i];
    }
  }
  */
  
  function void post_randomize();
    foreach(arr[i]) begin
      if(arr[i]%2==0) begin
        even = even + arr[i];
        e_num = e_num + 1;
      end else begin
        odd = odd + arr[i];
        o_num = o_num + 1;
      end
    end
    even=even/e_num;
    odd=odd/o_num;
  endfunction
      
endclass
      /*
module tb40_m;
  
  Q40_c pkt;
  
  initial begin
    pkt=new();
    //pkt.c2.constraint_mode(0);
    repeat(2) begin
    assert(pkt.randomize());
    $display(pkt.arr);
    $display(pkt.even);
    $display(pkt.odd);
    end
    //`uvm_info(get_type_name(),$sformat("pkt.arr=%p",pkt.arr),UVM_LOW)
  end
  
endmodule
*/
    

    
//Question 41: Which data types we can't use in randomize?

//Ans: 1.real
    // 2.string can't be declared rand/randc so basically use enum concept
    // 3.We can use 4 state data type but randomization will not generate X & Z values
    
class Q41_c;
  /*
  typedef enum {A,B} e;
  rand e e1;
  */
  
  rand logic num;
  
endclass
    /*
module q41_m;
  
  Q41_c pkt;
  
  initial begin
    pkt=new();
    repeat(10) begin
    assert(pkt.randomize);
    $display(pkt.num);
    end
    //$display(pkt.e1.name);
  end
  
endmodule
*/
    
//Question 42: Randomly generate square matrix (NxN) of integers; N dimension should be a random odd number?
    
//Ans:
    
class Q42_c;
  
  rand int arr[][];
  rand bit [2:0] num;
  
  constraint c1{
    (num%2!=0);
  }
  
  constraint c2{
    arr.size()==num;
    foreach(arr[i]){
      arr[i].size()==num;
    }
  }
  
endclass
    /*
module q42_m;
  
  Q42_c pkt;
  
  initial begin
    pkt=new();
    repeat(5) begin
    assert(pkt.randomize());
    $display(pkt.num,pkt.arr);
    //`uvm_info(get_full_name(),$sformat("pkt.num=%0d,pkt.arr=%p",pkt.num,pkt.arr),UVM_MEDIUM)
    end
  end
  
endmodule
*/
      
      
//Question 43: 200 int in the array, random array to have only 5 different numbers in the range [0:50], make sure every number appears 40 times and no same number in any 4 consecutive slots?
      
//Ans : Try it later
      
      
      
      
//Question 44: Generate gray code pattern using constraint like : 0 1 3 2 6 7 5 4
      
class Q44_c;
  
  rand bit [2:0] bin[];
  rand bit [2:0] gray[];
  /*
  constraint c1{
    gray[2]==bin[2];
    gray[1]==bin[1]^bin[2];
    gray[0]==bin[0]^bin[1];
  }
  */
  
  constraint c2{
    bin.size()==5;
    gray.size()==5;
  }
  
  constraint c3{
      foreach(gray[j]){
        gray[j]=={bin[j][2],bin[j][2]^bin[j][1],bin[j][1]^bin[j][0]};
      }
  }
  
endclass
    /*
module q44_m;
  
  Q44_c pkt;
  
  initial begin 
    pkt=new();
    repeat(5) begin
    assert(pkt.randomize());
    $display(pkt.bin);
    $display(pkt.gray);
    end
  end
  
endmodule
*/
      

  
  
  


    
 

    
    
  
  

      
        
        
  
  
  
        
        
   
  

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      