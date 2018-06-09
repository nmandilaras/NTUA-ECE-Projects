# !/bin/bash
# Algorithms Tester
# 
# Author: Andreas Chantzos
# Date: 31/10/2016
#
# Platforms: Linux, OS X
#
# The scope of this bash script is to receive the folder with the 
# test cases Dr Fotakis releases and an executable and print the 
# differences between the program outputs and the correct ones (if there is any)
# as well as the execution time for each test case.
#
# The files of the folder with the testCases should not be changed!!!
# It is assumed that the pairs of input-output will be in the form input$i.txt, output$i.txt
#
#
# First argument: number of testCases in directory
# Second argument: relative path to directory with testcases
# Third argument: relative path to executable


# Function that checks if a command exists
command_exists () {
    type "$1" &> /dev/null ;
}

# Arguments
numberOfTests=$1
testCaseDir=$2
exeFile=$3
# Number of passed testCases
passed=0
#FILE = "./filename"

# Os detection
# if OS X
if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]
then
    for i in `seq 1 $numberOfTests`;
            do
                # start counting execution time of testcase
                startT=$(date +%s%N)
				{ 
				./$exeFile < $testCaseDir/input$i.txt > filename
				} 2>error # keep by these way the output of the above command that is produced by the shell
				retval=$? #The exit status of the last command executed
                endT=$(date +%s%N)				
                DIFF=$(diff -w filename $testCaseDir/output$i.txt)
                # program executed without error
                if [ $retval -eq 0 ]
                then
                    if [ "$DIFF" != "" ]
                    then
                        echo "Testcase$i: Wrong Output"
                        echo $DIFF # displays the differences (first output is for file1 second for file2 )
                    else
                        ((passed++))
                        echo "testcase$i: Passed"
                    fi
                    runtime=$(((endT-startT)/1000000));
                    # Calculate runtime
                    echo "Testcase$i execution time: $runtime ms"
                    echo
                else
                    echo "testcase$i: $(cat error)"
					echo 		
                fi
            done
     echo "Passed: $passed/$numberOfTests"
# Write a batch script man
elif [ -n "$COMSPEC" -a -x "$COMSPEC" ]
then
    echo $0: this script does not support Windows 
fi
exit
