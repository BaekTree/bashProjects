10. change the scope of the variables in functions.

11. runner.sh option : start one iteratoin and then wait the basis minutes.






2. multiple preview pictures are annoying.



문제는 limit 위에 빈줄이 있으면 인식을 못한다? limit에 빈줄까지 들어가버린다. 빈줄에 개행문자를 추가했기 때문! 다른 항목들은 어차피 string이라서 상관 없는데 limitArr은 number이어야 해서 문제가 생길 수 있음. 이 부분 추후에 디버그 해야 함. rules.txt에 limit이 개행과 함께 올 가능성이 많기 때문에 급하고 중요하게 수정해야 함.

1. runner_up.sh 삭제 하기. diff runner.sh runner_up.sh 해보면 runner.sh가 모든 기능에 앞선다. 나중에 헷갈려서 runner.sh 지워버릴 것 같으니까 이거 runner.sh으로 대체하기. 대신에 runner.sh에 시간과 디버그 input 인자로 넣는 기능 사용하기. 그래서 -d 넣으면 timer_up을 실행하고, 숫자 넣으면 해당 숫자를 base min으로 사용하기.


2. apple script 글자 크기 혹은 가운데 정렬 등 서식 변경할 수 있는지 알아보기
---
[fix] fix newline \n char not work in rules.txt. used '\\n'
[update] silence runner_up.sh. silence wait function. 
[update] when the limit length of the answer of each question is not specified, set it default 0. 
[update] now rules.txt may handle newline string! 
[update] link the limit number in rules.txt to the real limit of each questions. 
[fix] fix bug, which required limit number of answer in a question with free answer. It was the problem caused from reading with nameref array.
[update] using nameref to read and save rules. 
[fix] fix ans{i} is not adapted in the first apple txt dialog. 
[update] MY UTILITY IS MAXIMIZED IN THE GRADIENT VECTOR DIRECTION IN REPENTECE IN GOD -> make this message response uppercase no matter the user type this in lowercase. used ${ans^^}.
[fix] When there is a correct response that the user must type, the checking to correct the answer has been missed. This has been fixed.
[update] added "\n\n\n\n" in apple_txt argument : apple_text "${ruleArr[${i}]}\n\n\n\n${contArr[${i}]}"
[update] debug mode. make specifiy the functio to run. skip the wait function. -d 붙이면 기본 함수들(clear hideAll ...) 실행하지 않고 나머지 코드를 실행. -d와 getRules을 붙이면 getRules만 실행.
[update] if the seconds argument is not number, time_up.sh causes an error and do not run.
[update] if no seconds argument for time_up.sh, it sets the default time to 5 seconds.
[update] check if current running file is in development while timer.sh runs funciton.sh. if it is in still develop, run function_up.sh instead of function.sh

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