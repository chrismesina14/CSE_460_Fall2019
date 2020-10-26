/*
 Christian Mesina
 lab7.cpp
 11/12/19

       +------------------+
       |  TEXT            | x10000?
       |                  |
       |  instructions in | x4199271 = proc1
       |  machine code    | x4199501 = proc2
       |                  |
       +------------------+ x4199925 = etext
       |  DATA            | x4210740 = g1   global initialized
       |  - initialized   | x4210744 = g3
       |    variables     | x4210748 = ls1  static initialized
       |                  | x4210752 = ls3
       |                  | 
       | ---------------  | x4210756 = edata
       |                  | x4210820 = g0   global uninitialized
       |                  | x4210848 = g2   big array 
       |                  | x4210816 = g4
       |  - uninitialized | x4210788 = ls0  static uninitialized
       |    variables     | x4210792 = ls2
       |                  |
       |                  | 
       | ---------------  | x4216848 = end 
       |  - heap for      | x31294048 pointed to by heap1
       |  dynamic         | x31294080 pointed to by heap2
       |  allocation      |
       |                  |
       |                  |
       +------------------+ 
                |
                |
                V

                .
                .
                .

                ^
                |
                |
       +------------------+
       |  STACK           | 140721790805016 = lc4, lc6   | Activation record for 
       |  - function      | 140721790805020 = lc3, lc5   | proc1 or proc2
       |    activation    |
       |    records       |
       |  - local         | 140721790805044 = lc2       | Activation record for
       |    automatic     | 140721790805048 = lc1       | main
       |    variables     | 140721790805052 = lc0       |
       +------------------+

       5. As variables are added to the stack, do the addresses get smaller or larger?
          - The addresses get smaller as variables are added to the stack.
       
       6. Do variables stored on the stack ever have the same address as other variables?
          - No, the variables stored on the stack doesn't have the same address as other vraibles.

       7. Where would you expect variables (or arguments) in recursive functions to be stored (stack, heap, or other data segment)? When you are finished step 8 below, comment on whether your expectations were correct or not.
          - I think we would expect the variables (or aguments) in recursive functions to be stored in the stack. After finishing step 8, my expectations were correct.

*/

// Step 8
#include <iostream>

using namespace std;

int recursion(int n)
{
    if (n <= 1)
    {
        return 1;
    }
    else
    { 
       return n*recursion(n-1);
    }
}

int main()
{
   int num;
   
   cout << "Enter a number to find its factorial: ";
   cin >> num;
   cout << endl;
   
   cout << "The factorial of " << num << " is " << recursion(num) << endl;
   
   return 0;
}

