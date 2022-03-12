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
//    int gridArr[1][1] =
//    {
//        {-5},
//    };
//    int i, j;
//    int **grid = (int **) malloc(1 * sizeof(int *));  // 注意：是两个**
//    for (i = 0; i < 1; i++) {
//        //grid是6个（5个参数的一维数组）组成的数组
//        grid[i] = (int *) malloc(1 * sizeof(int));  // 注意：是一个*
//        for (j = 0; j < 1; j++) {
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
    

    bool a = isNumber("2e0");
    
//    printf("CH- -- %f",a);
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


