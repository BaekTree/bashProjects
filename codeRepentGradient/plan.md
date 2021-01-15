change the scope of the variables in functions.

5. include the limit number of input of each apple text function dynamically. now let user type the limit number in rules.txt.
if there is not explicit limit in each rules, set default number N.

4. in apple text  for loop, add 'type this...' code explicitly. check if the ans{i} is not " ", then add the code. 

3. \n new line char does not work in rules.txt by now. fix this.

4. MY UTILITY IS MAXIMIZED IN THE GRADIENT VECTOR DIRECTION IN REPENTECE IN GOD -> make this message response uppercase no matter the user type this in lowercase. use ${ans^^}.

wish there are few newlines between the rules and contents. two or three empty lines i assume.
>added "\n\n\n\n" in apple_txt argument : apple_text "${ruleArr[${i}]}\n\n\n\n${contArr[${i}]}"

6. type enter in ... rules.txt. not let user use \n. 빈칸이나 rule, cont, limit을 만나기 전까지는 다 읽어서 현재 항목에 new line과 함께 추가한다!

7. bug to read contents. from rule 6, the contents are pushed back by one row. : declare array and assign value in the specific element index. declared -a array.

8. multiple preview pictures are annoying.

9. debug mode. make specifiy the functio to run. skip the wait function.

Fri Jan 15 10:25:52 2021 +0900까지
[update] improve rules.txt
[fix : function.sh] remove comments of showing verses.
[update] upload init.sh, rules.txt. runner.sh
[update] use while loop to show all text dailog automatically.
[update] upload function.sh
[fix] fix bugs caused from the variable scope. change few variables from global to local in some parseTxt and parseBtnAns functions.
[update] file read with better form
[update] improve file read function
[fix] refactoring : define function wait
[fix] refactoring : define function read
[update] update with new file with additinal development.
[add] detatch rules and contents from the main script and create nwe text files. The main program reads the file and adapts its contents automaticall.y
[add] use nohup with init script. run ./init.sh
[add] use runner.sh to run timer.sh script repeatly over and over again with basis minutes.
[add] The time limit to run the timer.sh is basis minutes time + randomly additional time between 0 ~ 1/4 of basis mins.
[update] shows remaining time expression