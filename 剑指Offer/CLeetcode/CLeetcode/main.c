//
//  main.c
//  CLeetcode
//
//  Created by 蔡浩铭 on 2022/3/9.
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define INT_MAX  0X7fffffff
#define INT_MIN  0X80000000


// int divide(int a, int b);
// int findRepeatNumber(int* nums, int numsSize);
// char* replaceSpace(char* s);
// int fib(int n);
// int numWays(int n);
// int minArray(int* numbers, int numbersSize);
// bool exist(char** board, int boardSize, int* boardColSize, char* word);
int numberSum(int m);
int movingCount(int m, int n, int k);

struct ListNode
{
    int val;
    struct ListNode *next;
};


struct TreeNode
{
    int val;
    struct TreeNode *left;
    struct TreeNode *right;
};


int main()
{
    
    printf("start --- ");
    //    int a = divide(1,-1);
    // int int_array[7] = {2, 3, 1, 0, 2, 5, 3};
    // int a = findRepeatNumber(int_array,7);
    // int int_array[3] = {3,1,3};
    
    // char *input = "We are happy.";
    // char *a = replaceSpace(input);
    
    // int a = fib(43);
    // int a = numWays(7);
    
    int a = movingCount(1,2,1);
    // int a = minArray(int_array,3);
    // printf("%s",a);
    printf("CH- -- %d",a);
    
    
    printf("end --- ");
    
    return 0;
}


 /* ########################      001. 整数除法         ########################*/
 /*
 首先负数是以补码形式存储，是反码加1，因此有符号数中，负数位数会比正数多一个。
 因此符号位Int最小值转正整数回溢出。
 因此，将a，b都转成负数，就不会有溢出的风险。
 */
 int divide(int dividend, int divisor){
  // 处理特殊情况
         if (dividend == INT_MIN && divisor == -1)
             return INT_MAX;
         if (divisor == 1)
             return dividend;

         // 处理结果符号
         int sign = 1;
         if ((dividend > 0 && divisor < 0) || (dividend < 0 && divisor > 0))
             sign = 0;

         if (dividend > 0)
             dividend = -dividend;
         if (divisor > 0)
             divisor = -divisor;
         //基本方法
         // while(1) {
         //     if (dividend <= divisor) {
         //         dividend -= divisor;
         //         res += 1;
         //     }else {
         //         break;
         //     }
         // }

         // 优化处理 -- 倍增处理
         int res = 0;
         while(1) {
             int a = dividend, b = divisor, c = 1;
             if (a > b)
                 break;
             while(a - b <= b) {
                 c += c;
                 b += b;
             }
             res += c;
             dividend -= b;
         }
         if (!sign)
             return -res;
         return res;

 }



 /* ########################      03. 数组中重复的数字         ########################*/
 int findRepeatNumber(int* nums, int numsSize){
     return 0;
 }


 /* ########################      05. 替换空格         ########################*/
 /*

 */
 char* replaceSpace(char* s){
     int len = strlen(s);
     int count = 0;
     for (int i = 0; i < len; i++)
     {
         if (s[i] == ' ')
         {
             count += 1;
         }
     }
     int newLen = len + count * 2;
     char *result = malloc(sizeof(char) * newLen);
     for (int i = 0,j = 0; i < len; i++, j++)
     {
         if (s[i] == ' ')
         {
             result[j] = '%';
             result[j+1] = '2';
             result[j+2] = '0';
             j += 2;
         } else {
             result[j] = s[i];
         }
     }
     result[newLen-1] = '\0';
     return result;
 }



 /* ########################      06. 从尾到头打印链表         ########################*/
 void reversePrint_subFun(struct ListNode *head,
                          int *returnSize,
                          int *res)
 {
     if (head == NULL)
     {
         return;
     }
     reversePrint_subFun(head->next,returnSize,res);
     res[(*returnSize)++] = head->val;
 }

 int *reversePrint(struct ListNode *head, int *returnSize)
 {
     if (head == NULL)
     {
         *returnSize = 0;
         return NULL;
     }
     int* res = malloc(sizeof(int) * 10001);
     *returnSize = 0;
     reversePrint_subFun(head,returnSize,res);
     return res;
 }




 /* ########################      07. 重建二叉树         ########################*/
 struct TreeNode* buildTree(int* preorder, int preorderSize, int* inorder, int inorderSize){
     if (preorderSize != inorderSize || preorder == NULL || inorder == NULL || preorderSize == 0 || inorderSize == 0)
     {
         return NULL;
     }
     struct TreeNode *root = (struct TreeNode *)malloc(sizeof(struct TreeNode));
     root->val = preorder[0];
     if (preorderSize == 1)
     {
         return root;
     }
     int i;
     for (i = 0; i < inorderSize; i++)
     {
         if (inorder[i] == preorder[0])
         {
             break;
         }
     }
     // 寻找中缀中的左子树数组，右子树数组
     // 寻找前缀中的左子树数组，右子树数组
     // 构建左子树
     root->left = buildTree(preorder+1,i,&inorder,i);
     // 构建右子树
     root->right = buildTree(&preorder[i+1],preorderSize-i-i,&inorder[i+1],preorderSize-i-i);
     return root;
 }


 /* ########################      09. 用两个栈实现队列         ########################*/
 #define MAX_QUEUE_SIZE  10000
 typedef struct {
     int *stackA;
     int *stackB;
     int topA;
     int topB;
 } CQueue;


 CQueue* cQueueCreate() {
     CQueue *cq;
     cq = (CQueue *)malloc(sizeof(CQueue));
     if (cq == NULL)
     {
         return NULL;
     }
     cq->stackA = (int *)malloc(sizeof(int) * MAX_QUEUE_SIZE);
     cq->stackB = (int *)malloc(sizeof(int) * MAX_QUEUE_SIZE);
     if (cq->stackA == NULL)
     {
         free(cq);
         return NULL;
     }
     cq->topA = -1;
     if (cq->stackB == NULL)
     {
         free(cq->stackA);
         free(cq);
         return NULL;
     }
     cq->topB = -1;
     return cq;
 }

 void cQueueAppendTail(CQueue* obj, int value) {
     if (obj->topA != MAX_QUEUE_SIZE)
     {
         obj->stackA[++obj->topA] = value;
     }
 }

 int cQueueDeleteHead(CQueue* obj) {
     int topBEelm = 0, topAElem = 0;
     // 如果B栈不为空，直接倒出来
     if (obj->topB != -1)
     {
         topBEelm = obj->stackB[obj->topB--];
         return topBEelm;
     }
     // 如果B栈为空，A不为空
     if (obj->topB == -1 && obj->topA != -1)
     {
         while (obj->topA != -1)
         {
             topAElem = obj->stackA[obj->topA--];
             obj->stackB[++obj->topB] = topAElem;
         }
     }
         // 如果B栈不为空，直接倒出来
     if (obj->topB != -1)
     {
         topBEelm =  obj->stackB[obj->topB--];
         return topBEelm;
     }
     return -1;
 }

 void cQueueFree(CQueue* obj) {
     if (obj != NULL)
     {
         if (obj->stackA != NULL)
         {
             free(obj->stackA);
         }
         if (obj->stackB != NULL)
         {
             free(obj->stackB);
         }
         free(obj);
     }

 }



 /* ########################      10- I. 斐波那契数列        ########################*/
 int fibcache[101] = {0};
 int fib(int n){
     if (n == 0 || n == 1)
     {
         return n;
     }
     if (fibcache[n] != 0)
     {
         return fibcache[n];
     }
     int value = (fib(n-1) + fib(n-2)) % 1000000007;
     fibcache[n] = value;
     return value;
 }


 /* ########################      10- II. 青蛙跳台阶问题       ########################*/
 /*
 n台阶的数量，对应是n-1，n-2台阶的数量
 */
 int numwayscache[101] = {0};
 int numWays(int n){
     if (n == 0)
     {
         return 1;
     }
     if (n == 1 || n == 2)
     {
         return n;
     }
     if (numwayscache[n] != 0)
     {
         return numwayscache[n];
     }
     int value =  (numWays(n-1) + numWays(n-2)) % 1000000007;
     numwayscache[n] = value;
     return value;
 }



 /* ########################      11. 旋转数组的最小数字        ########################*/
 /*
 二分：
 mid 比right 大，则不需要看前面   2，3，4，5，1
 mid 比right 小，则不需要看后面  ,5,1,2,3,4
 mid和right一样，  则可以减少长度，再重新走上面两个规则
 1，2，3，4，5    3，4，5，1，2      4，5，1，2，3
 2,2,2,0,1
 [1,3,5]
 [1,3,3]
 [3,1,3]

 */
 int minArray(int* numbers, int numbersSize){
     if (numbers == NULL)
     {
         return -1;
     }
     if (numbersSize == 0)
     {
         return numbers[0];
     }

     if (numbersSize == 2)
     {
         int min = numbers[0];
         if (numbers[1] < min)
         {
             return numbers[1];
         }
         return min;
     }

     int mid = numbersSize / 2;
     if (numbers[mid] < numbers[numbersSize-1])
     {   // 小的在前
         return minArray(numbers,mid+1);
     }else if (numbers[mid] > numbers[numbersSize-1]){
         // 小在后半
         return minArray(&numbers[mid],numbersSize - mid);
     }else if (numbers[mid] == numbers[numbersSize-1])
     {
         return minArray(numbers,numbersSize-1);
     }else {
         return -1;
     }
 }



 /* ########################      12. 矩阵中的路径        ########################*/
 /*
 递归深度遍历，将当前遍历到的位置置位一个垃圾位，然后将上下左右四个方向的位置进行递归查找。最后再递归结束将原来的位置恢复
 */

 bool exist_dfs(char **board, int boardSize, int *boardColSize, char *word, int row, int col, int len)
 {
     //边界
     if (row < 0 || col < 0 || row >= boardSize || col >= *boardColSize || board[row][col] != word[len])
     {
         return false;
     }
     //是否完成路径，
     if (strlen(word)-1 == len)
     {
         return true;
     }
     char temp = board[row][col];
     board[row][col] = '/';
     bool res = exist_dfs(board,boardSize,boardColSize,word,row-1,col,len+1) ||
                 exist_dfs(board,boardSize,boardColSize,word,row+1,col,len+1) ||
                 exist_dfs(board,boardSize,boardColSize,word,row,col-1,len+1) ||
                 exist_dfs(board,boardSize,boardColSize,word,row,col+1,len+1);
     board[row][col] = temp;
     return res;

 }
 bool exist(char** board, int boardSize, int* boardColSize, char* word)
 {
     for (int i = 0; i < boardSize; i++)
     {
         for (int j = 0; j < *boardColSize; j++)
         {
             if (exist_dfs(board,boardSize,boardColSize,word,i,j,0))
             {
                 return true;
             }

         }

     }
     return false;
 }



/* ########################      剑指 Offer 13. 机器人的运动范围        ########################*/
/*
 构建一个二维数组记录当前位置不能走，然后递归上下左右四个方向，用最大值和当前加一
 */
int numberSum(int m)
{
    int sum = 0;
    int tempM = m;
    while (1)
    {
        int temp = tempM % 10;
        if (tempM > 0)
        {
            sum += temp;
            tempM = (tempM-temp) / 10;
        }else {
            break;
        }
    }
    return sum;
}

int max_Int(int a,int b) {
    // return a > b ? a : b
    if (a > b)
    {
        return a;
    }
    return b;
}

void movingCount_dfs(int **mark, int num, int col, int m, int n, int k, int *count)
{
    if (m >= 0 && m < num && n >= 0 && n < col)
    {
        int sums = numberSum(m) + numberSum(n);
        if (sums <= k && mark[m][n] == 0)
        {
            *count += 1;
            mark[m][n] = -1;
            movingCount_dfs(mark, num, col, m + 1, n, k, count);
            movingCount_dfs(mark, num, col, m - 1, n, k, count);
            movingCount_dfs(mark, num, col, m, n + 1, k, count);
            movingCount_dfs(mark, num, col, m, n - 1, k, count);
        }
    }
}

int movingCount(int m, int n, int k)
{
    int **visit = (int **)malloc(m * sizeof(int *));
    int count = 0;
    for (int i = 0; i < m; i++)
    {
        visit[i] = (int *)malloc(n * sizeof(int));
    }
    movingCount_dfs(visit, m, n, 0, 0, k,&count);
    return count;
}
