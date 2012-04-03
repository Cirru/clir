**状态: 中止**

既然`commit`都是中文了, 干脆不用英文得了, 估计没人打算玩这个.  
不过还是备下文档吧, 说不定以后不得不学`C`, 那就不得不折腾了  
目标
--
`C`语言重要, 但语法难看, 借鉴`CoffeeScript`语法, 用符号改变语法.  
主要目标是减少括号, 其次是对过于直白的语法加上适当的美化, 比如`int: i`.  
再有是`for/while`此类语句用更漂亮的语法进行修饰
说明
--
因为是尝试性质的, 没有规划, 而是对照教程, 学一点, 做一点.  
`C`我是大概在入门, 脚本语言用惯, 非常不能接受其思维方式, 因此找[教程][ln 1].  
现在我大概只能[`commit`][ln 2]当中的记录大致梳理一遍我所做的了.  
**总体**
我是按行匹配然后进行替换的, 另外有针对缩进自动回补`}`甚至`;`的过程,  
另外, 为了方便, 我规定`\`在行首非空白第一个字符时自动将该行拼到前一行  
**头文件**
头文件考虑`<>`和`""`两种, 简化了定义方式

    #include stdio.h mylib
 convert to
 
      dd
    #include <stdio.h>
    #include "mylib.h"
**类型定义**

    int: i
    char: c = 'a'
    int: hour = 11, minute = 59
 convert to
 
    int i;
    char c = 'a';
    int hour = 11, minute = 59;
 **函数**
 
    int: main <- void:
      => 0
to

    int main(void){
      return 0;
    }
**直接执行函数**
因为是通过正则特别匹配头尾, 所以中间嵌套的函数不能简写了

    newline ()
    printf "%s\n", str
to

    newline ();
    printf ("%s\n", str)
**if 语法**
    
    if x > 0
      printf "true"
    else
      printf "false"
to

    if (x>0){
      printf ("true")
    }
    else {
      printf ("false")
    }
 **switch/case**
 
    int: x = 1
    switch x
      case 0
        => 0
      case 1
        => 1
      case
        => -1
to

    int x = 1;
    switch (x) {
      case 0:
        return 0;
      case 1:
        return 1;
      default:
        return -1;
    }
**while**
    
    int: x = 10
    while x > 0
      x -= 1
to

    int x = 10;
    while (x>0) {
      x -= 1;
    }
**for**
    
    for i <- 1, 2.. n
      printf "%d",  i
to

    for (i=1; i<=n; i += (2-1)){
      printf ("%d", i);
    }
**break/continue**
    
    break
to

    break
**struct 定义**

    $ complex:
      double: x, y
    double: x = 0.3
    $ complex: z
    z.x = x
    z.y = 2.0
to

    struct complex {
      double x, y;
    }
    double x = 0.3;
    struct complex z;
    z.x = x;
    z.y = 2.0;
**sctruct 的函数**

    $ complex: create_complex <- double: x, double: y
      $ complex: z
      z.x = x
      z.y = y
    $ complex: a = create_complex (x, y)
to
    
    struct complex create_complex (double x, double y) {
      struct complex z;
      z.x = x;
      z.y = y;
    }
    struct complex a = create_complex (x, y);
**数组**

    char: str # 14 = "hello world\n"
    int: str # 4 = 1, 2, 3, 4
to

    char str[14] = "hello world\n";
    int str[4] = {1, 2, 3, 4};
**多维数组**

    char: days # 8 # 10 = "", "Mon", "Tue", "Wen",
      \ "Thu", "Fri", "Sta", "Sun"
to

    char days[8][10] = { "", "Mon", "Tue", "Wen",  "Thu", "Fri", "Sta", "Sun" };
**更多类型, 如`unsigned`**
    
    %unsigned int: a = 2
to

    unsigned int a = 2;
未尝试
--
* `enum/union`我当时跳过了, 不知道会不会用到
* 指针方面我没学, 不打算, 所以这个脚本当前用的余地都没有
* 脚本没有经过批量的使用和测试, `commit`中的例子能运行而已, 因此`bug`

计划
--
`C`就目前我能理解的, 因为能操作内存, 可以有很神奇的数据结构.  
而动态语言中我就被数据类型太少影响过, 总之我继续用`coffee`, 也准备可能还要碰`C`,  
短期不想看了, 后边关于内存的控制比我想象的复杂得多. 以后再说吧

[ln 1]:(http://learn.akae.cn/media/index.html)
[ln 2]:(https://github.com/jiyinyiyong/clear_converter/commits/master/)
