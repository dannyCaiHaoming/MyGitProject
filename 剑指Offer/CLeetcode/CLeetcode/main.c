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


int divide(int a, int b);
int findRepeatNumber(int* nums, int numsSize);
bool findNumberIn2DArray(int** matrix, int matrixSize, int* matrixColSize, int target);
char* replaceSpace(char* s);
int fib(int n);
int numWays(int n);
int minArray(int* numbers, int numbersSize);
bool exist(char** board, int boardSize, int* boardColSize, char* word);
int numberSum(int m);
int movingCount(int m, int n, int k);
int cuttingRope(int n);
int cuttingRope2(int n);
int hammingWeight(uint32_t n);
double myPow(double x, int n);
int* printNumbers(int n, int* returnSize);
bool isNumber(char* s);
int* exchange(int* nums, int numsSize, int* returnSize);
int* spiralOrder(int** matrix, int matrixSize, int* matrixColSize, int* returnSize);
bool validateStackSequences(int* pushed, int pushedSize, int* popped, int poppedSize);
bool verifyPostorder(int* postorder, int postorderSize);
char** permutation(char* s, int* returnSize);
int majorityElement(int* nums, int numsSize);
int maxSubArray(int* nums, int numsSize);
int maxSubArray2(int* nums, int numsSize);
int lengthOfLongestSubstring(char * s);

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
//    {1,4,7,11,15},
//    {2,5,8,12,19},
//    {3,6,9,16,22},
//    {10,13,14,17,24},
//    {18,21,23,26,30}
//    int gridArr[3][4] =
//    {
//        {1,2,3,4},
//        {5,6,7,8},
//        {9,10,11,12}
//    };
//    int i, j;
//    int **grid = (int **) malloc(3 * sizeof(int *));  // 注意：是两个**
//    for (i = 0; i < 3; i++) {
//        //grid是6个（5个参数的一维数组）组成的数组
//        grid[i] = (int *) malloc(4 * sizeof(int));  // 注意：是一个*
//        for (j = 0; j < 4; j++) {
//            // 方式一：下标引用
//            grid[i][j] = gridArr[i][j];
//
//            // 方式二：指针计算
//            // *(*(grid + i) + j) = gridArr[i][j];
//        }
//    }
    
//    [[1,4,7,11,15],[2,5,8,12,19],[3,6,9,16,22],[10,13,14,17,24],[18,21,23,26,30]]
//    int colSize = 1;
//    int a = findNumberIn2DArray(grid, 1, &colSize, -10);
    // int a = findRepeatNumber(int_array,7);
    // int int_array[3] = {3,1,3};
    
    // char *input = "We are happy.";
    // char *a = replaceSpace(input);
    
    // int a = fib(43);
    // int a = numWays(7);
    
//    int a = movingCount(1,2,1);
    // int a = minArray(int_array,3);
    // printf("%s",a);
//    int a = cuttingRope(5);
//    int a = cuttingRope2(120);
//    int a = hammingWeight(128);
    
//    double a = myPow(2.0000, -2147483648);
//    int size = 9;
//    int *p = printNumbers(1, &size);
//
//    for (int i = 0; i < size; i++) {
//        printf("CH ---- a %d",p[i]);
//    }
    
//    int array[3] = {1,35};
//    int size = 3;
//    int a = exchange(array, 3, &size);
    
//    int size;
//    int colSize = 4;
//    int *p = spiralOrder(grid, 3, &colSize, &size);

//    bool a = isNumber("2e0");
    
//    printf("CH- -- %f",a);
//    printf("CH- -- %d",a);
    
//    for (int i = 0; i < size; i++) {
//        printf("CH ---- a %d",p[i]);
//    }
    
    
//    int p1[5] = {1,2,3,4,5};
//    int p2[5] = {4,5,3,2,1};
//   int a = validateStackSequences(p1, 5, p2, 5);
//    int p[8] = {1,2,5,10,6,9,4,3};
//    int a = verifyPostorder(p, 8);
//
//    printf("CH- -- %d",a);
    
//    char s[3] = "abc";
//    int returnSize;
//    permutation(s, &returnSize);
//
//    printf("%s",s);
//    printf("%d",returnSize);
    
    
    
//    int nums[9] = {1,2,3,2,2,2,5,4,2};
//    int a = majorityElement(nums, 9);
    
//    int nums[9] = {-2,1,-3,4,-1,2,1,-5,4};
//    int a = maxSubArray2(nums, 9);
    
    int a = lengthOfLongestSubstring("abcabcbb");
    
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


/* ########################      04. 二维数组中的查找         ########################*/
/*
 每行的最后一个是行最大，每列的第一个是列最小
 可以先取行的最后一个和target判断大小
 last < target 则行数 + 1继续进行上一步
 last > target 则列数 -1 继续进行上一步
 */
bool findNumberIn2DArray(int** matrix, int matrixSize, int* matrixColSize, int target){
    if (matrixSize == 0 || *matrixColSize == 0) {
        return false;
    }
    int col = *matrixColSize-1;
    int row = 0;
    while (1) {
        if (row >= matrixSize) {
            return false;
        }
        while (1) {
            if (col < 0) {
                return false;
            }
            int cur = matrix[row][col];
            if (cur == target) {
                return true;
            }
            else if (cur < target) {
                row += 1;
                break;
            }else {
                col -= 1;
                break;
            }
        }
    }
    return false;
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



/* ########################      13. 机器人的运动范围        ########################*/
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



/* ########################       14- I. 剪绳子        ########################*/
/*
 1  1
 2  1x1
 3  1x2  1x1x1
 4  1x3  2x2  1x1x1
 5  1x4 2x3  2x2x1  1x1x3
 6  1x5  2x2x2  2x3x1  2x4  3x3
 7  3x4
 8  3x3x2
 10 3x3x4
 
 从规律可以得到尽量划分成3，如果遇到4，就分成2x2,
 */
int cuttingRope_cache[60] ={0};
int cuttingRope(int n){
    if (n == 2) {
        cuttingRope_cache[2] = 1;
        return 1;
    }
    if (n == 3) {
        cuttingRope_cache[3] = 2;
        return 2;
    }
    if (n == 4) {
        cuttingRope_cache[4] = 4;
        return 4;
    }
    if (cuttingRope_cache[n] != 0) {
        return cuttingRope_cache[n];
    }
    int next = 0;
    if (n-3 < 4) {
        next = n-3;
    }else {
        next = cuttingRope(n-3);
    }
    int result = 3 * next;
    cuttingRope_cache[n] = result;
    return result;
}



/* ########################       14- II. 剪绳子 II        ########################*/
/*
 这道题的答案范围会越界，因此处理上需要先考虑越界的情况，将数据类型改成long，然后取模操作后再重新赋值会int
 */
int cuttingRope2(int n){
    if (n == 2) {
        return 1;
    }
    if (n == 3) {
        return 2;
    }
    if (n == 4) {
        return 4;
    }
    int next = 0;
    if (n-3 < 4) {
        next = n-3;
    }else {
        next = cuttingRope(n-3);
    }
    long temp = (long)next * 3 % 1000000007;
    int result = (int)temp ;
    return result;
}


/* ########################       15. 二进制中1的个数        ########################*/
int hammingWeight(uint32_t n) {
    int count = 0;
    for (int i = 0; i < 32; i++) {
        count += n & 1;
        n = n >> 1;
    }
    return count;
}


/* ########################       16. 数值的整数次方        ########################*/
/*
 这种的大数算法，一次次遍历会超时。因此需要寻找能偷鸡的办法，幂次方的话，就可以每次计算减半的幂次方,
 同时需要注意这里，幂次数小于0，就得被1除!
 */
double pow1(double x, long long n) {
    if (n == 0) {
        return 1;
    }
    if (n == 1) {
        return x;
    }
    // 能对半开就half*half
    // 不能的话 就是对半开还多一个自己，例如3次方 就是half*half*x
    double halfPow = pow1(x, n/2);
    return n % 2 == 0 ? halfPow*halfPow : halfPow * halfPow * x;
}
double myPow(double x, int n)
{
    if (x == 0 && n < 0) {
        return 0.0;
    }
    long long ln = n;
    return n < 0 ? 1/pow1(x, -ln) : pow1(x, ln);
}


/* ########################       17. 数值的整数次方        ########################*/
/*
 1 1~9
 3  1~999
 */
int* printNumbers(int n, int* returnSize){
    int count = 1;
    for (int i = 0; i < n; i++) {
        count *= 10;
    }
    count -= 1;
    *returnSize = count;
    int *p = (int *)malloc(sizeof(int) * count);
    for (int i = 0; i < *returnSize; i++) {
        *(p+i) = i+1;
    }
    return p;
}


/* ########################       18. 删除链表的节点        ########################*/
struct ListNode* deleteNode(struct ListNode* head, int val){
    struct ListNode* temp = (struct ListNode *)malloc(sizeof(struct ListNode));
    if (head->val == val) {
        temp = head->next;
        head->next = NULL;
        return temp;
    }
    struct ListNode* first = (struct ListNode *)malloc(sizeof(struct ListNode));
    first = head;
    while (head->next != NULL) {
        if (head->next->val == val) {
            temp = head->next;
            head->next = temp->next;
            break;
        }
        head = head->next;
    }
    return first;
}



/* ########################       20. 表示数值的字符串        ########################*/
/*
 模式匹配：
 x. 需要将开头结尾的空格用循环先去掉
 y. 遇到数字也用循环先去掉，这样就减少很多杂项
 1.  开头能是符号或者字母或者数字
    1.  如果是数字
        a. 可以继续是数字
        b. 可以接字母，但是字母后面必须是符号,符号后就得是数字
        c. 可以接小数点，但是只有一个
    2.  如果是符号
        a. 只能继续是数字
    
 */
bool isNumber(char* s) {
    int len = strlen(s);
    bool hasNum = false, hasE = false, hasSign = false, hasDot = false;
    int index = 0;
    /* 去除前导空格 */
    while (index < len && s[index] == ' ') {
        index++;
    }
    /* 从头到尾遍历字符串 */
    while (index < len) {
        /* 如果当前字符c是数字：将hasNum置为true，
         * index往后移动一直到非数字或遍历到末尾位置；
         * 如果已遍历到末尾(index == n)，结束循环
         */
        while (index < len && s[index] >= '0' && s[index] <= '9') {
            index++;
            hasNum = true;
        }
        if (index == len) {
            break;
        }
        char c = s[index];
        if (c == 'e' || c == 'E') {
            /* 如果当前字符c是'e'或'E'：
            * 如果e已经出现或者当前e之前没有出现过数字，返回fasle；
            * 否则令hasE = true，并且将其他3个flag全部置为false，
            * 因为要开始遍历e后面的新数字了
            */
            if (hasE || !hasNum) {
                return false;
            }
            hasE = true;
            hasDot = hasNum = hasSign = false;
        } else if (c == '+' || c == '-') {
            /* 如果当前字符c是+或-：如果已经出现过+或-
             * 或者已经出现过数字或者已经出现过'.'，返回flase；
             * 否则令hasSign = true
             */
            if (hasSign || hasNum || hasDot) {
                return false;
            }
            hasSign = true;
        } else if (c == '.') {
            /* 如果当前字符c是'.'：
             * 如果已经出现过'.'或者已经出现过'e'或'E'，返回false；
             * 否则令hasDot = true
             */
            if (hasDot || hasE) {
                return false;;
            }
            hasDot = true;
        } else if (c == ' ') {
            /* 如果当前字符c是' '：
             * 结束循环，因为可能是末尾的空格了，
             * 但也有可能是字符串中间的空格，在循环外继续处理
             */
            break;
        } else {
            /* 如果当前字符c是除了上面5种情况以外的其他字符，直接返回false */
            return false;
        }
        index++;
    }
    /* 如果当前索引index与字符串长度相等，说明遍历到了末尾，
     * 但是还要满足hasNum为true才可以最终返回true，
     * 因为如果字符串里全是符号没有数字的话是不行的，而且e后面没有数字也是不行的，
     * 但是没有符号是可以的，所以4个flag里只要判断一下hasNum就行；
     * 所以最后返回的是hasNum && index == n
     */
    while (index < len && s[index] == ' ') {
        index++;
    }
    return hasNum && index == len;
}




/* ########################       21. 调整数组顺序使奇数位于偶数前面        ########################*/
int* exchange(int* nums, int numsSize, int* returnSize){
    *returnSize = numsSize;
    int i = 0,j = numsSize-1;
    
    
    while (i < numsSize && j >= 0 && i < j) {
        // 找出左边不是奇数
        while (i < numsSize && nums[i] % 2 != 0) {
            i += 1;
        }
        // 找出右边不是偶数
        while (j >= 0 && nums[j] % 2 == 0) {
            j -= 1;
        }
        if (i > j) {
            break;;
        }
        int temp = nums[i];
        nums[i] = nums[j];
        nums[j] = temp;
        i += 1;
        j -= 1;
    }
    
    return nums;
}



/* ########################        22. 链表中倒数第k个节点        ########################*/
/*
 应该是把k长度大于链表长度的时候，默认返回整个链表的长度了
 */
struct ListNode* getKthFromEnd(struct ListNode* head, int k){
    if (head->next == NULL && k == 1) {
        return head;
    }
    struct ListNode *first = (struct ListNode *)malloc(sizeof(struct ListNode));
    struct ListNode *second = (struct ListNode *)malloc(sizeof(struct ListNode));
    first = second = head;
    for (int i = 0; i < k; i++) {
        second = second->next;
    }
    if (second == NULL) {
        return first;
    }
    while (second != NULL) {
        second = second->next;
        first = first->next;
    }
    return first;
}


/* ########################        24. 反转链表        ########################*/
/*
 a -> b - > c
 
 l
 temp = a->next
 a->next = l
 l = temp
 
 
 C语言漏了空的特殊情况，会有一些内存异常的情况。
            
 */
struct ListNode* reverseList(struct ListNode* head){
    if (head == NULL  || head->next == NULL) {
        return head;
    }
    struct ListNode*left = NULL;
    struct ListNode*temp = NULL;
    while (head->next != NULL) {
        temp = head->next;
        head->next = left;
        left = head;
        head = temp;
    }
    head->next = left;
    return head;
}




/* ########################        26. 树的子结构       ########################*/
/*
想复杂了，子结构，应该就是比较root，left，right是否与B结构一样
 
 判断val相等的情况，递归判断左子树，和右子树的值是否一样。
 因此入口需要的是val==val || left==left || right==right
 递归的话，判断B是否为空，空就是判断完了
 A如果为空，则说明B还没判断完。
 */
bool isSubStructureLoop(struct TreeNode* A, struct TreeNode* B) {
    if (B == NULL) {
        return true;
    }
    if (A == NULL || A->val != B->val) {
        return false;
    }
    return isSubStructureLoop(A->left, B->left) && isSubStructureLoop(A->right, B->right);
}


bool isSubStructure(struct TreeNode* A, struct TreeNode* B){
    if (A == NULL || B == NULL) {
        return false;
    }
    return isSubStructureLoop(A, B) || isSubStructure(A->left, B) || isSubStructureLoop(A->right, B);
}



/* ########################        27. 二叉树的镜像       ########################*/
/*
 递归搞搞？
 判断是否有左子树，有的话用左子树去调用，是否有右子树，有的话去调用
 */
struct TreeNode* mirrorTree(struct TreeNode* root){
    if (root == NULL) {
        return NULL;
    }
    struct TreeNode*left = root->left;
    if (left != NULL) {
        left = mirrorTree(left);
    }
    struct TreeNode*right = root->right;
    if (right != NULL) {
        right = mirrorTree(right);
    }
    root->left = right;
    root->right = left;
    return root;
}




/* ########################        28. 对称的二叉树       ########################*/
/*
 简单想，就是先判断root是否相等，如果root相等就放到left，right，
 去递归判断left的left是否等于right的right，left的right是否等于right的left
 */
bool isSymetricDFS(struct TreeNode* left,struct TreeNode* right) {
    if (left == NULL && right == NULL) {
        return true;
    }
    if (left == NULL || right == NULL) {
        return false;
    }
    return left->val == right->val && isSymetricDFS(left->left, right->right) && isSymetricDFS(left->right, right->left);
}

bool isSymmetric(struct TreeNode* root){
    if (root == NULL) {
        return true;
    }
    if (root->left == NULL && root->right == NULL) {
        return true;
    }
    if (root->left != NULL && root->right != NULL) {
        return isSymetricDFS(root->left, root->right);
    }
    return false;
}




/* ########################        29. 顺时针打印矩阵       ########################*/
/*
 1,2,3
 4,5,6
 7,8,9
 
 1,2,3,4
 5,6,7,8
 9,10,11,12
 */
int* spiralOrder(int** matrix, int matrixSize, int* matrixColSize, int* returnSize){
    if (matrixSize == 0 || matrixColSize[0] == 0) {
        *returnSize = 0;
        return NULL;
    }
    int minX = 0, minY = 0;
    int maxX = *matrixColSize-1;
    int maxY = matrixSize-1;
    int x = 0,y = 0;
    *returnSize = matrixSize * (*matrixColSize);
    int *result = (int *)malloc(sizeof(int) * (*returnSize));
    int i = 0;
    while (minX <= maxX && minY <= maxY) {
        if (i < *returnSize) {
            while (x <= maxX) {
                result[i] = matrix[y][x];
                x++;
                i++;
            }
            x = maxX;
            minY++;
            y++;
        }
        if (i < *returnSize) {
            while (y <= maxY) {
                result[i] = matrix[y][x];
                y++;
                i++;
            }
            y = maxY;
            maxX--;
            x--;
        }
        if (i < *returnSize) {
            while (x >= minX) {
                result[i] = matrix[y][x];
                x--;
                i++;
            }
            x = minX;
            maxY--;
            y--;
        }
        if (i < *returnSize) {
            while (y >= minY) {
                result[i] = matrix[y][x];
                y--;
                i++;
            }
            y = minY;
            minX++;
            x++;
        }

    }
    return result;
    
}



/* ########################        30. 包含min函数的栈       ########################*/
#define max_size 10000
typedef struct {
    int *x_stack;
    int *min_stack;
    int x_top;
    int min_top;
    int min_value;
} MinStack;

/** initialize your data structure here. */

MinStack* minStackCreate() {
    MinStack *obj = (MinStack*)malloc(sizeof(MinStack));
    obj->x_stack = (int*)malloc(sizeof(int) * max_size);
    obj->min_stack = (int*)malloc(sizeof(int) * max_size);
    obj->min_top = obj->x_top = -1;
    obj->min_value = 0;
    return obj;
}

void minStackPush(MinStack* obj, int x) {
    if(obj->x_top < max_size)
    {
        if(obj->x_top == -1)
            obj->min_value = x;
        obj->x_stack[++(obj->x_top)] = x;
        if(x < obj->min_value)
            obj->min_value = x;     //当前元素比min_value小时改变min_value
        obj->min_stack[++(obj->min_top)] = obj->min_value;
    }
}

void minStackPop(MinStack* obj) {
    --(obj->x_top);
    --(obj->min_top);
    if(obj->min_top != -1)
        obj->min_value = obj->min_stack[obj->min_top];//出栈后将min_value变成min_stack的栈顶元素
}

int minStackTop(MinStack* obj) {
    return obj->x_stack[obj->x_top];
}

int minStackMin(MinStack* obj) {
    return obj->min_stack[obj->min_top];
}

void minStackFree(MinStack* obj) {
    free(obj->x_stack);
    free(obj->min_stack);
    free(obj);
}


/* ########################        31. 栈的压入、弹出序列       ########################*/
/*
使用辅助栈，将push栈的元素，重新模拟一遍入栈,然后同时看pop栈，如果pop栈栈顶有元素，则同时两边一起pop
 1,2,3,4,5
 4,5,3,2,1
注意C语言用的是数组进行栈操作，因此pop的时候是用下标回退一个来表示
 */

bool validateStackSequences(int* pushed, int pushedSize, int* popped, int poppedSize){
    int *stack = (int *)malloc(sizeof(int) * pushedSize);
    int top = -1;
    int popIndex = 0;
    for (int i = 0 ; i < pushedSize; i++) {
        stack[top++] = pushed[i];
        while (top != -1 && top < pushedSize && popIndex < poppedSize && stack[top] == popped[popIndex]) {
            popIndex++;
            top--;
        }
    }
    return top == -1;
}



/* ########################        32 - II. 从上到下打印二叉树 II       ########################*/
/*
    3
   / \
  9  20
    /  \
   15   7

[
  [3],
  [9,20],
  [15,7]
]

队列吧，  当队列不为空  则使用出队列往临时数组追加当前内容，且记录下下一级树的内容。
*returnSize: 返回数组个数
**returnColumnSize 指向二维数组，大小是数组个数，内容是每行的数量

C语言队列用数组处理的话，也是head+1作为出队列的操作，入队列就是tail+1进行处理
*/
#define MAXSIZE 10000
int** levelOrder(struct TreeNode* root, int* returnSize, int** returnColumnSizes){
    if (root == NULL)
    {
        *returnSize = 0;
        return NULL;
    }
    struct TreeNode*queue[MAXSIZE] = {0};
    int head,tail = 0;
    int **res = (int **)malloc(sizeof(int *)*MAXSIZE);
    *returnColumnSizes = (int *)malloc(sizeof(int *)*MAXSIZE);
    queue[tail++] = root;
    *returnSize = 0;
    while (tail > head)
    {
        int size = (tail-head+MAXSIZE)%MAXSIZE;
        (*returnColumnSizes)[*returnSize] = size;
        res[*returnSize] = (int *)malloc(sizeof(int *)*size);
        for (int i = 0; i < size; i++)
        {
            struct TreeNode *temp = queue[head++];
            res[*returnSize][i] = temp->val;
            if (temp->left)
            {
                queue[tail++] = temp->left;
            }
            if (temp->right)
            {
                queue[tail++] = temp->right;
            }
        }
        (*returnSize)++;
    }
    return res;
}



/* ########################         32 - III. 从上到下打印二叉树 III       ########################*/
/*
 对比上一道题，这道题应该需要用双向队列。
 即从左到右，就是普通队列，先进先出
 从右到左的时候，就是先进后出
 这里直接用简单方向来处理下一行内容增加的方向
 */
int** levelOrder3(struct TreeNode* root, int* returnSize, int** returnColumnSizes){
    if (root == NULL)
    {
        *returnSize = 0;
        return NULL;
    }
    struct TreeNode*queue[MAXSIZE] = {0};
    bool direction = false;
    int head,tail = 0;
    int **res = (int **)malloc(sizeof(int *)*MAXSIZE);
    *returnColumnSizes = (int *)malloc(sizeof(int *)*MAXSIZE);
    queue[tail++] = root;
    *returnSize = 0;
    while (tail > head)
    {
        int size = (tail-head+MAXSIZE)%MAXSIZE;
        (*returnColumnSizes)[*returnSize] = size;
        res[*returnSize] = (int *)malloc(sizeof(int *)*size);
        if (!direction) {
            for (int i = 0; i < size; i++)
            {
                struct TreeNode *temp = queue[head++];
                res[*returnSize][i] = temp->val;
                if (temp->left)
                {
                    queue[tail++] = temp->left;
                }
                if (temp->right)
                {
                    queue[tail++] = temp->right;
                }
            }
        }else {
            for (int i = size - 1; i >= 0; i--)
            {
                struct TreeNode *temp = queue[head++];
                res[*returnSize][i] = temp->val;
                if (temp->left)
                {
                    queue[tail++] = temp->left;
                }
                if (temp->right)
                {
                    queue[tail++] = temp->right;
                }
            }
        }
        direction = !direction;

        (*returnSize)++;
    }
    return res;
}



/* ########################         33. 二叉搜索树的后序遍历序列       ########################*/
/*
 二叉查找树（Binary Search Tree），（又：二叉搜索树，二叉排序树）它或者是一棵空树，或者是具有下列性质的二叉树： 若它的左子树不空，则左子树上所有结点的值均小于它的根结点的值； 若它的右子树不空，则右子树上所有结点的值均大于它的根结点的值；
 
 根据二叉查找树特性，左子树均比根节点小，右子树均比根节点大
 因此每次可以获取最后一个数，为根节点
 右子树，从第一个比根节点大的数开始（M），直到根节点前一个
 左子树，从第一个数，到M前一个为止
 貌似要对左子树的内容判断是否比跟小？ 对右子树的内容判断是否比跟大？
 
 !!!如果只是遍历找到第一个比根节点大的值，后面的值没有判断是否合理
 */
bool verifyPostorder(int* postorder, int postorderSize){

    if (postorder == NULL || postorderSize == 0) {
        return true;
    }
    if (postorderSize == 1) {
        return true;
    }
    
    int c = *(postorder + postorderSize- 1);
    int m;
    for (m = 0; m < postorderSize; m++) {
        if (*(postorder + m) > c) {
            break;;
        }
    }
    for (int i = m; i < postorderSize; i++) {
        if (*(postorder + i) < c) {
            return false;
        }
    }
    if (m == postorderSize) {
        return verifyPostorder(postorder, postorderSize-1);
    }
    if (m == 0) {
        return verifyPostorder(postorder+m, postorderSize-m-1);
    }
    return verifyPostorder(postorder, m) && verifyPostorder(postorder+m, postorderSize-m-1);
}




/* ########################         34. 二叉树中和为某一值的路径       ########################*/
/*
 从根节点到叶子节点，因此只需要遍历所有深度，貌似就能做出来？
 *returnSize为有多少个路径 **returnColumnSizes是各个路径分别长度为多少.
 
 头 孩子 叶子  ，孩子 叶子  ，  头，
 从每个节点，执行深度遍历，找出值符合target的值，或者找出target-val的值
 
 因为是记录跟节点到叶子节点的各个val，因此全局维护一个数组记录每个步骤，在进行子节点递归遍历之后，需要把每次的下标计数减回去
 */
int **path;
int *subPath;
int* pathColSize;
int pathCount = 0;
int subCount = 0;

void pathSumDFS(struct TreeNode *root,int target) {
    if (root == NULL) {
        return;
    }
    subPath[subCount++] = root->val;
    
    if (root->val == target && root->left == NULL && root->right == NULL) {
        
        int *temp = (int *)malloc(sizeof(int) * subCount);
        for (int i = 0; i < subCount; i++) {
            temp[i] = subPath[i];
        }
        path[pathCount] = temp;
        pathColSize[pathCount] = subCount;
        pathCount++;
    }
    pathSumDFS(root->left, target-root->val);
    pathSumDFS(root->right, target-root->val);
    
    // 为了将这次运算的影响恢复回去。应该也是回溯里面很重要的一步。
    subCount--;
}

int** pathSum(struct TreeNode* root, int target, int* returnSize, int** returnColumnSizes){
    
    path = malloc(sizeof(int*) * 2001);
    subPath = malloc(sizeof(int) * 2001);
    pathColSize = malloc(sizeof(int) * 2001);
    pathCount = subCount = 0;
    
    pathSumDFS(root, target);
    
    *returnSize = pathCount;
    *returnColumnSizes = pathColSize;
//    for (int i = 0; i < pathCount; i++) {
//        *returnColumnSizes[i] = pathColSize[i];
//    }
    
    return path;
}




/* ########################         35. 复杂链表的复制       ########################*/
/*
 链表的复制，简答的就是两个双指针方法，一个指向复制的开头，一个指向链表开头。
 但是题目多了一个任意指向的指针，因为可能存在指向的指针，还没有复制出来，因此可以使用map，对所有节点先进行一次存储。
 这样子在使用的时候，就可以通过当前的随机指向，找到指向的指针，
 */
//class Solution {
//    public Node copyRandomList(Node head) {
//        if(head == null) return null;
//        Node cur = head;
//        Map<Node, Node> map = new HashMap<>();
//        // 3. 复制各节点，并建立 “原节点 -> 新节点” 的 Map 映射
//        while(cur != null) {
//            map.put(cur, new Node(cur.val));
//            cur = cur.next;
//        }
//        cur = head;
//        // 4. 构建新链表的 next 和 random 指向
//        while(cur != null) {
//            map.get(cur).next = map.get(cur.next);
//            map.get(cur).random = map.get(cur.random);
//            cur = cur.next;
//        }
//        // 5. 返回新链表的头节点
//        return map.get(head);
//    }
//}


/* ########################         36. 二叉搜索树与双向链表       ########################*/
/*
 二叉搜索树的中序遍历是递增数列。
 在中序遍历的基础之上，对前缀，和后续进行一个记录。
 中序遍历的话，总能获取到当前节点的左子树，
 因此只需要获取到左子树的时候，判断当前记录的前缀是否为空，如果为空则说明是头结点，并且记录这个头结点
 如果前缀不为空，则当前的left是这个前缀，然后pre->right是当前，然后把pre指向当前
 右子树怎么处理，因为如果右子树为普通树的右子树，且如果它没有叶子节点，那么我们记录的pre，就是他的父节点。
 跑当前的right就能指向这个根节点，然后当前的left就能指向父节点
 */
//class Solution {
//    Node pre, head;
//    public Node treeToDoublyList(Node root) {
//        if(root == null) return null;
//        dfs(root);
//        head.left = pre;
//        pre.right = head;
//        return head;
//    }
//    void dfs(Node cur) {
//        if(cur == null) return;
//        dfs(cur.left);  // 左
//        if(pre != null) pre.right = cur;
//        else head = cur;     /* 根  */
//        cur.left = pre;
//        pre = cur;
//        dfs(cur.right); // 右
//    }
//}


/* ########################         38. 字符串的排列       ########################*/
/*
 a,b,c
 固定a，尝试交换自己，固定b，尝试交换自己，到c是最后一个不用交换，输出
 回到固定b，交换b，c， 到b是最后一个不用交换输出
 a，b交换，固定b，到a，尝试交换自己，到c尝试交换自己，输出
 固定b，交换a，c输出
 a，c交换，固定c，到b，到a，输出
 b和a交换，输出。
 
 排列类型的题目，可以从最简单的情况入手，这道题可以用三个数字，a，b，c开始
 所以就得到从第一位开始循环将每一位与第一位进行交换，这样子能解决掉不同开头的情况，
 但是交换了之后，就又进入到同一个问题，就是也是需要将第一位和后面每一位尝试交换。---一直到当前位是最后一位，就可以输出结果。

 
 */
char **permutationSize;
int permutationCount = 0;

void swapChar(char *s,int i,int j) {
    char temp = s[i];
    s[i] = s[j];
    s[j] = temp;
}

bool judgeRepeat(char *s, int start, int end) {
    // 剪枝，意味着就是已经去过上边位置的不需要再去一次了
    for (int i = start; i < end; i++){
        if (s[i] == s[end])
        {
            return true;
        }
    }
    return false;
}


void permutationDFS(char *s,int index,int length) {
    if (index == length-1) {
        char *temp = (char *)malloc(sizeof(char) * (length + 1));
        strcpy(temp, s);
        permutationSize[permutationCount++] = temp;
        return;
    }
    for (int i = index; i < length; i++) {
        if (judgeRepeat(s, index, i)) {
            continue;
        }
        swapChar(s, index, i);
        permutationDFS(s, index+1, length);
        swapChar(s, index, i);
    }
}



char** permutation(char* s, int* returnSize){
    if (s == NULL)
    {
        *returnSize = 0;
        return NULL;
    }
    int size = (int)strlen(s);
    permutationSize = (char **)malloc(sizeof(char *)* 100);
    permutationDFS(s, 0, size);
    *returnSize = permutationCount;
    return permutationSize;
}





/* ########################        39. 数组中出现次数超过一半的数字       ########################*/
/*
 先排序，然后取中间？
 */
//int majorityElement(int* nums, int numsSize){
//    for (int i = numsSize-1 ; i > 0; i--) {
//        int max = i;
//        for (int j = 0; j < i; j++) {
//            if (nums[j] > nums[max]) {
//                max = j;
//            }
//        }
//        if (max != numsSize-1) {
//            int temp = nums[max];
//            nums[max] = nums[i];
//            nums[i] = temp;
//        }
//        if (i <= numsSize/2) {
//            return nums[i];
//        }
//    }
//    return nums[numsSize/2];
//
//}
int cmp(const void* a, const void* b){
    return *(int*)a - *(int*)b;
}
int majorityElement(int* nums, int numsSize){
    qsort(nums, numsSize, 4, cmp);
    return nums[numsSize/2];
}

/* ########################         40. 最小的k个数       ########################*/
/*
 肯定也是能先排序，然后输出前k个数
 
 */
int change(void*num1,void*num2)
{
    return *(int*)num1-*(int*)num2;
}
int* getLeastNumbers(int* arr, int arrSize, int k, int* returnSize){
   qsort(arr,arrSize,sizeof(int),change);
   *returnSize=k;
   return arr;
}



/* ########################         42. 连续子数组的最大和       ########################*/
/*
 1.子数组，那就可以暴力，从第一个数开始，每次都遍历到结尾，看看每一个数字到结尾的各个最大值是多少。
 2.简单以两个数为例子， -，-  -，+， +，+  ，+，-
 */
int maxSubArray(int* nums, int numsSize){
    int ans = nums[0];
    int curSum = nums[0];
    for (int i = 1; i<numsSize; i++) {
        if (curSum + nums[i] < nums[i]) {
            curSum = nums[i];
        }else {
            curSum += nums[i];
        }
        if (ans < curSum) {
            ans = curSum;
        }
    }
    return ans;
}



int maxSubArray2(int* nums, int numsSize){
    int dp[numsSize];
    dp[0] = nums[0];
    int max = dp[0];
    for (int i = 1; i < numsSize; i++) {
        if (dp[i-1] < 0) {
            dp[i] = nums[i];
        }else {
            dp[i] = nums[i] + dp[i-1];
        }
        if (dp[i] > max) {
            max = dp[i];
        }
    }
    return max;
}




/* ########################         44. 数字序列中某一位的数字       ########################*/
int findNthDigit(int n){
    return 0;
}







/*
 1. 两数之和
 */
int* twoSum(int* nums, int numsSize, int target, int* returnSize){
    int size = 0;
    int *r = (int *)malloc(sizeof(int) * 2) ;
    for (int i = 0; i < numsSize; i++) {
        if (i == numsSize-1) {break;}
        for (int j = i+1;j < numsSize; j++) {
            if (nums[i] + nums[j] == target) {
                r[0] = i;
                r[1] = j;
                size = 2;
                break;
            }
        }
    }
    *returnSize = size;
    return r;
}



/*
 3. 无重复字符的最长子串
 */
int lengthOfLongestSubstring(char * s){
    int length = strlen(s);
    int *p = (int *)malloc(sizeof(int) * length);
    int max = 0;
    if (length > 0) {
        p[0] = 1;
        max = 1;
    }
    for (int i = 1; i < length; i++) {
        if (s[i] != s[i-1]) {
            bool hasSame = false;
            int sameCount = 0;
            for (int j = i-1; j >= (i-p[i-1]);j--) {
                if (s[j] == s[i]) {
                    hasSame = true;
                    sameCount = i-j;
                    break;
                }
            }
            if (hasSame) {
                p[i] = sameCount;
            }else {
                p[i] = p[i-1] + 1;
            }
            if (p[i] > max) {
                max = p[i];
            }
        }else {
            p[i] = 1;
        }
    }
    return max;
}
